import {
    Lecturer,
    Class,
    Assessment,
    Enrollment,
    AssessmentScore
} from '../models/index.js';

export async function saveAssessmentGrade(
    userId,
    classId,
    assessmentId,
    studentId,
    score,
    feedback
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

    // Verify that the student is actively enrolled.
    const enrollment = await Enrollment.findOne({
        where: {
            studentId,
            classId: classRecord.id,
            status: 'active'
        }
    });

    if (!enrollment) {
        throw new Error('Active student enrollment not found.');
    }

    // Validate the score.
    const maxScore = Number(assessment.maxScore);

    if (
        !Number.isFinite(score) ||
        score < 0 ||
        score > maxScore
    ) {
        throw new Error(
            `Score must be between 0 and ${maxScore}.`
        );
    }

    // Create or retrieve the existing grading record.
    const [grading, created] = await AssessmentScore.findOrCreate({
        where: {
            assessmentId: assessment.id,
            enrollmentId: enrollment.id
        },
        defaults: {
            score,
            feedback: feedback ?? null,
            gradedAt: new Date()
        }
    });

    // Update the record if it already exists.
    if (!created) {
        await grading.update({
            score,
            feedback: feedback ?? null,
            gradedAt: new Date()
        });
    }

    return {
        assessmentId: assessment.id,
        studentId: enrollment.studentId,
        enrollmentId: enrollment.id,
        score: grading.score,
        maxScore: assessment.maxScore,
        feedback: grading.feedback,
        gradedAt: grading.gradedAt
    };
}