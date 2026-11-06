import { Op } from 'sequelize';

import {
    Lecturer,
    Class,
    Enrollment,
    Assessment,
    Assignment,
    Submission,
    AssessmentScore
} from '../models/index.js';

export async function getLecturerDashboard(userId) {
    // 1. Find lecturer profile
    const lecturer = await Lecturer.findOne({
        where: { userId }
    });

    if (!lecturer) {
        throw new Error('Lecturer profile not found.');
    }

    // 2. Retrieve lecturer's classes
    const classes = await Class.findAll({
        where: { lecturerId: lecturer.id },
        attributes: ['id']
    });

    const classIds = classes.map(item => item.id);

    // Return empty metrics if lecturer has no classes
    if (classIds.length === 0) {
        return {
            totalClasses: 0,
            totalStudents: 0,
            pendingGrading: 0,
            upcomingAssessments: 0
        };
    }

    // 3. Count distinct actively enrolled students
    const enrollments = await Enrollment.findAll({
        where: {
            classId: { [Op.in]: classIds },
            status: 'active'
        },
        attributes: ['studentId'],
        raw: true
    });

    const uniqueStudentIds = new Set(
        enrollments.map(item => String(item.studentId))
    );

    // 4. Find assignments belonging to these classes
    const assessments = await Assessment.findAll({
        where: {
            classId: { [Op.in]: classIds }
        },
        attributes: ['id', 'dueAt']
    });

    const assessmentIds = assessments.map(item => item.id);

    const assignments = assessmentIds.length > 0
        ? await Assignment.findAll({
            where: {
                assessmentId: { [Op.in]: assessmentIds }
            },
            attributes: ['id', 'assessmentId'],
            raw: true
        })
        : [];

    const assignmentIds = assignments.map(item => item.id);

    // 5. Find submitted assignments
    const submissions = assignmentIds.length > 0
        ? await Submission.findAll({
            where: {
                assignmentId: { [Op.in]: assignmentIds }
            },
            attributes: ['id', 'assignmentId', 'enrollmentId'],
            raw: true
        })
        : [];

    // Map assignment IDs to their assessment IDs
    const assignmentAssessmentMap = new Map(
        assignments.map(item => [
            String(item.id),
            String(item.assessmentId)
        ])
    );

    // 6. Retrieve existing scores
    const scores = assessmentIds.length > 0
        ? await AssessmentScore.findAll({
            where: {
                assessmentId: { [Op.in]: assessmentIds }
            },
            attributes: ['assessmentId', 'enrollmentId', 'score'],
            raw: true
        })
        : [];

    // Identify submissions without a completed score
    const gradedSubmissions = new Set(
        scores
            .filter(item => item.score !== null)
            .map(item =>
                `${item.assessmentId}:${item.enrollmentId}`
            )
    );

    const pendingGrading = submissions.filter(submission => {
        const assessmentId = assignmentAssessmentMap.get(
            String(submission.assignmentId)
        );

        const gradingKey =
            `${assessmentId}:${submission.enrollmentId}`;

        return !gradedSubmissions.has(gradingKey);
    }).length;

    // 7. Count upcoming assessments
    const now = new Date();

    const upcomingAssessments = assessments.filter(assessment => {
        return assessment.dueAt &&
            new Date(assessment.dueAt) > now;
    }).length;

    return {
        totalClasses: classIds.length,
        totalStudents: uniqueStudentIds.size,
        pendingGrading,
        upcomingAssessments
    };
}