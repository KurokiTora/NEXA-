
import sequelize from '../config/database.js';

import {
    Enrollment,
    Assessment,
    AssessmentScore,
    AttendanceSession,
    AttendanceRecord,
    GradingConfiguration,
    CourseResult
} from '../models/index.js';

import {
    calculateFinalScore,
    convertToGradePoint
} from './gradingService.js';

import {
    calculateAttendancePercentage
} from './attendanceservice.js';

/**
 * Converts a raw assessment score into a percentage.
 * Example: 40 / 50 = 80%.
 */
function normalizeScore(score, maxScore) {
    const numericScore = Number(score);
    const numericMaxScore = Number(maxScore);

    if (
        !Number.isFinite(numericScore) ||
        !Number.isFinite(numericMaxScore) ||
        numericMaxScore <= 0 ||
        numericScore < 0 ||
        numericScore > numericMaxScore
    ) {
        throw new Error('Invalid assessment score or maximum score.');
    }

    return (numericScore / numericMaxScore) * 100;
}

/**
 * Calculates and saves one student's course result.
 *
 * gradingConfigurationId is retained as a version reference.
 * The fixed grading weights are defined in gradingService.js.
 */
export async function calculateAndSaveCourseResult({
    enrollmentId,
    midtermAssessmentId,
    finalExamAssessmentId,
    gradingConfigurationId,
    gradeScale
}) {
    return sequelize.transaction(async transaction => {
        // 1. Verify the student's enrollment.
        const enrollment = await Enrollment.findByPk(enrollmentId, {
            transaction
        });

        if (!enrollment) {
            throw new Error('Enrollment not found.');
        }

        if (enrollment.status === 'dropped') {
            throw new Error(
                'Cannot calculate a result for a dropped enrollment.'
            );
        }

        const classId = Number(enrollment.classId);

        // 2. Verify the grading version belongs to this class.
        const gradingConfiguration =
            await GradingConfiguration.findByPk(
                gradingConfigurationId,
                { transaction }
            );

        if (
            !gradingConfiguration ||
            Number(gradingConfiguration.classId) !== classId
        ) {
            throw new Error(
                'Grading configuration not found for this class.'
            );
        }

        // 3. Retrieve the student's graded assessments.
        const scores = await AssessmentScore.findAll({
            where: { enrollmentId },
            include: [
                {
                    model: Assessment,
                    as: 'assessment',
                    attributes: [
                        'id',
                        'classId',
                        'title',
                        'type',
                        'maxScore'
                    ],
                    required: true
                }
            ],
            transaction
        });

        const classScores = scores.filter(
            item => Number(item.assessment.classId) === classId
        );

        // 4. Calculate the average of graded assignments.
        const assignmentScores = classScores.filter(
            item => item.assessment.type === 'assignment'
        );

        if (assignmentScores.length === 0) {
            throw new Error(
                'No graded assignments are available for this student.'
            );
        }

        const assignmentPercentages = assignmentScores.map(item =>
            normalizeScore(
                item.score,
                item.assessment.maxScore
            )
        );

        const assignmentAverage =
            assignmentPercentages.reduce(
                (sum, score) => sum + score,
                0
            ) / assignmentPercentages.length;

        // 5. Find the midterm and final exam scores.
        function getExamPercentage(assessmentId, examName) {
            const result = classScores.find(
                item =>
                    Number(item.assessment.id) ===
                    Number(assessmentId)
            );

            if (!result) {
                throw new Error(
                    `${examName} score has not been recorded.`
                );
            }

            if (result.assessment.type !== 'exam') {
                throw new Error(
                    `${examName} must refer to an exam assessment.`
                );
            }

            return normalizeScore(
                result.score,
                result.assessment.maxScore
            );
        }

        const midterm = getExamPercentage(
            midtermAssessmentId,
            'Midterm'
        );

        const finalExam = getExamPercentage(
            finalExamAssessmentId,
            'Final exam'
        );

        // 6. Retrieve all sessions and this student's records.
        const sessions = await AttendanceSession.findAll({
            where: { classId },
            include: [
                {
                    model: AttendanceRecord,
                    as: 'attendanceRecords',
                    where: { enrollmentId },
                    attributes: ['status'],
                    required: false
                }
            ],
            transaction
        });

        if (sessions.length === 0) {
            throw new Error(
                'No attendance sessions are available for this class.'
            );
        }

        // A missing attendance record is treated as absent.
        const attendanceStatuses = sessions.map(session => {
            const record = session.attendanceRecords[0];

            return record ? record.status : 'absent';
        });

        const attendance = calculateAttendancePercentage(
            attendanceStatuses
        );

        // 7. Calculate the final score using the fixed weights.
        const finalScore = calculateFinalScore({
            assignments: assignmentAverage,
            attendance,
            midterm,
            finalExam
        });

        // 8. Convert the final score to a grade point.
        const gradePoint = convertToGradePoint(
            finalScore,
            gradeScale
        );

        // 9. Update an existing result or create a new one.
        const [result, created] = await CourseResult.findOrCreate({
            where: {
                enrollmentId,
                gradingConfigurationId
            },
            defaults: {
                enrollmentId,
                gradingConfigurationId,
                finalScore,
                gradePoint,
                calculatedAt: new Date()
            },
            transaction
        });

        if (!created) {
            await result.update(
                {
                    finalScore,
                    gradePoint,
                    calculatedAt: new Date()
                },
                { transaction }
            );
        }

        return {
            enrollmentId: Number(enrollmentId),
            assignmentAverage: Number(
                assignmentAverage.toFixed(2)
            ),
            attendance,
            midterm: Number(midterm.toFixed(2)),
            finalExam: Number(finalExam.toFixed(2)),
            finalScore,
            gradePoint,
            courseResultId: result.id
        };
    });
}
