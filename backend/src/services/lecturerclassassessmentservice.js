import {
    Lecturer,
    Class,
    Assessment,
    Assignment
} from '../models/index.js';

export async function getLecturerClassAssessments(userId, classId) {
    // Find the lecturer's profile.
    const lecturer = await Lecturer.findOne({
        where: { userId }
    });

    if (!lecturer) {
        throw new Error('Lecturer profile not found.');
    }

    // Verify that this class belongs to the lecturer.
    const classRecord = await Class.findOne({
        where: {
            id: classId,
            lecturerId: lecturer.id
        }
    });

    if (!classRecord) {
        return null;
    }

    // Retrieve assessments belonging to this class.
    const assessments = await Assessment.findAll({
        where: {
            classId: classRecord.id
        },
        attributes: [
            'id',
            'title',
            'description',
            'type',
            'maxScore',
            'dueAt'
        ],
        order: [['id', 'ASC']]
    });

    if (assessments.length === 0) {
        return [];
    }

    // Find which assessments have an associated assignment.
    const assessmentIds = assessments.map(item => item.id);

    const assignments = await Assignment.findAll({
        where: {
            assessmentId: assessmentIds
        },
        attributes: ['assessmentId'],
        raw: true
    });

    const assignmentAssessmentIds = new Set(
        assignments.map(item => String(item.assessmentId))
    );

    // Format the response.
    return assessments.map(assessment => {
        const data = assessment.toJSON();

        return {
            id: data.id,
            title: data.title,
            description: data.description,
            type: data.type,
            maxScore: data.maxScore,
            dueAt: data.dueAt,
            hasAssignment: assignmentAssessmentIds.has(
                String(data.id)
            )
        };
    });
}