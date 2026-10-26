

import {
    GRADE_WEIGHTS,
    calculateFinalScore,
    convertToGradePoint
} from './services/gradingservice.js';

function assertEqual(actual, expected, message) {
    if (actual !== expected) {
        throw new Error(
            `${message}: expected ${expected}, received ${actual}`
        );
    }

    console.log(`PASS: ${message}`);
}

function assertThrows(callback, message) {
    let threw = false;

    try {
        callback();
    } catch {
        threw = true;
    }

    if (!threw) {
        throw new Error(`FAIL: ${message} should have thrown an error.`);
    }

    console.log(`PASS: ${message}`);
}

function testGradingService() {
    console.log('--- Testing fixed grading weights ---');

    assertEqual(GRADE_WEIGHTS.assignments, 40, 'Assignments weight');
    assertEqual(GRADE_WEIGHTS.attendance, 30, 'Attendance weight');
    assertEqual(GRADE_WEIGHTS.midterm, 15, 'Midterm weight');
    assertEqual(GRADE_WEIGHTS.finalExam, 15, 'Final exam weight');

    const totalWeight = Object.values(GRADE_WEIGHTS).reduce(
        (sum, weight) => sum + weight,
        0
    );

    assertEqual(totalWeight, 100, 'Fixed weights total 100%');

    console.log('\n--- Testing final score calculation ---');

    const result = calculateFinalScore({
        assignments: 80,
        attendance: 90,
        midterm: 75,
        finalExam: 85
    });

    // 80*0.40 + 90*0.30 + 75*0.15 + 85*0.15 = 83.5
    assertEqual(result, 83.5, 'Weighted final score');

    assertThrows(
        () => calculateFinalScore({
            assignments: 101,
            attendance: 90,
            midterm: 75,
            finalExam: 85
        }),
        'Assignments score above 100'
    );

    assertThrows(
        () => calculateFinalScore({
            assignments: 80,
            attendance: -1,
            midterm: 75,
            finalExam: 85
        }),
        'Negative attendance score'
    );

    console.log('\n--- Testing grade-point conversion ---');

    // Illustrative scale for testing only.
    const exampleGradeScale = [
        { minScore: 80, gradePoint: 4.0 },
        { minScore: 70, gradePoint: 3.0 },
        { minScore: 60, gradePoint: 2.0 },
        { minScore: 50, gradePoint: 1.0 },
        { minScore: 0, gradePoint: 0.0 }
    ];

    assertEqual(
        convertToGradePoint(83.5, exampleGradeScale),
        4.0,
        'Grade-point conversion'
    );

    assertThrows(
        () => convertToGradePoint(101, exampleGradeScale),
        'Final score above 100'
    );

    console.log('\nAll grading service tests passed.');
}

try {
    testGradingService();
} catch (error) {
    console.error('Grading service test failed:', error);
    process.exitCode = 1;
}

