import {
    Lecturer,
    Class,
    Assessment,
    Assignment,
    Submission,
    SubmissionFile,
    Enrollment,
    Student,
    AssessmentScore
} from '../models/index.js';

export async function getLecturerAssessmentSubmissions(
    userId,
    classId,
    assessmentId
) {
    // Find the lecturer's profile.
    const lecturer = await Lecturer.findOne({
        where: { userId }
    });

    if (!lecturer) {
        throw new Error('Lecturer profile not found.');
    }

    // Verify class ownership.
    const classRecord = await Class.findOne({
        where: {
            id: classId,
            lecturerId: lecturer.id
        }
    });

    if (!classRecord) {
        return null;
    }

    // Verify that the assessment belongs to this class.
    const assessment = await Assessment.findOne({
        where: {
            id: assessmentId,
            classId: classRecord.id
        }
    });

    if (!assessment) {
        return null;
    }

    // Verify that this assessment has an assignment record.
    const assignment = await Assignment.findOne({
        where: {
            assessmentId: assessment.id
        }
    });

    if (!assignment) {
        throw new Error('This assessment does not have an assignment.');
    }

    // Retrieve submissions and their associated student information.
    const submissions = await Submission.findAll({
        where: {
            assignmentId: assignment.id
        },
        attributes: [
            'id',
            'assignmentId',
            'enrollmentId',
            'submittedAt'
        ],
        include: [
            {
                model: Enrollment,
                attributes: ['id', 'studentId'],
                required: true,
                include: [
                    {
                        model: Student,
                        attributes: [
                            'id',
                            'studentId',
                            'fullName'
                        ],
                        required: true
                    }
                ]
            },
            {
                model: SubmissionFile,
                attributes: [
                    'id',
                    'fileName',
                    'mimeType',
                    'fileSize',
                    'uploadedAt'
                ],
                required: false
            }
        ],
        order: [['submittedAt', 'ASC']]
    });

    if (submissions.length === 0) {
        return [];
    }

    // Retrieve grading records for the submitted students.
    const enrollmentIds = submissions.map(
        item => item.enrollmentId
    );

    const scores = await AssessmentScore.findAll({
        where: {
            assessmentId: assessment.id,
            enrollmentId: enrollmentIds
        },
        attributes: [
            'enrollmentId',
            'score',
            'feedback',
            'gradedAt'
        ],
        raw: true
    });

    const scoreMap = new Map(
        scores.map(item => [
            String(item.enrollmentId),
            item
        ])
    );

    // Combine submission and grading information.
    return submissions.map(submission => {
        const data = submission.toJSON();

        const student = data.Enrollment.Student;

        const grading = scoreMap.get(
            String(data.enrollmentId)
        );

        return {
            submissionId: data.id,
            submittedAt: data.submittedAt,

            student: {
                id: student.id,
                studentId: student.studentId,
                fullName: student.fullName
            },

            files: data.SubmissionFiles || [],

            grading: grading
                ? {
                    score: grading.score,
                    feedback: grading.feedback,
                    gradedAt: grading.gradedAt
                }
                : null
        };
    });
}