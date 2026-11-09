export const GRADE_WEIGHTS = Object.freeze({
    assignments: 40,
    attendance: 30,
    midterm: 15,
    finalExam: 15
});

function validateScore(name, score) {
    if (
        typeof score !== 'number' ||
        !Number.isFinite(score) ||
        score < 0 ||
        score > 100
    ) {
        throw new Error(
            `${name} score must be a number between 0 and 100.`
        );
    }
}

export function calculateFinalScore({
    assignments,
    attendance,
    midterm,
    finalExam
}) {
    validateScore('Assignments', assignments);
    validateScore('Attendance', attendance);
    validateScore('Midterm', midterm);
    validateScore('Final exam', finalExam);

    const finalScore =
        assignments * (GRADE_WEIGHTS.assignments / 100) +
        attendance * (GRADE_WEIGHTS.attendance / 100) +
        midterm * (GRADE_WEIGHTS.midterm / 100) +
        finalExam * (GRADE_WEIGHTS.finalExam / 100);

    return Number(finalScore.toFixed(2));
}

export function convertToGradePoint(finalScore, gradeScale) {
    validateScore('Final score', finalScore);

    if (!Array.isArray(gradeScale) || gradeScale.length === 0) {
        throw new Error('A grade scale is required.');
    }

    for (const grade of gradeScale) {
        if (
            typeof grade.minScore !== 'number' ||
            !Number.isFinite(grade.minScore) ||
            grade.minScore < 0 ||
            grade.minScore > 100 ||
            typeof grade.gradePoint !== 'number' ||
            !Number.isFinite(grade.gradePoint) ||
            grade.gradePoint < 0 ||
            grade.gradePoint > 4
        ) {
            throw new Error('The grade scale contains an invalid entry.');
        }
    }

    const sortedScale = [...gradeScale].sort(
        (a, b) => b.minScore - a.minScore
    );

    if (sortedScale[sortedScale.length - 1].minScore !== 0) {
        throw new Error(
            'The grade scale must include a minimum score of 0.'
        );
    }

    const matchedGrade = sortedScale.find(
        grade => finalScore >= grade.minScore
    );

    return matchedGrade.gradePoint;
}
