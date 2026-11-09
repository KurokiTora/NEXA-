
import {
    attendanceToValue,
    calculateAttendancePercentage
} from './services/attendanceservice.js';

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

function testAttendanceService() {
    console.log('--- Testing attendance status conversion ---');

    assertEqual(attendanceToValue('present'), 1, 'Present counts as 1');
    assertEqual(attendanceToValue('late'), 1, 'Late counts as 1');
    assertEqual(attendanceToValue('excused'), 1, 'Excused counts as 1');
    assertEqual(attendanceToValue('absent'), 0, 'Absent counts as 0');
    
    assertThrows(
        () => attendanceToValue('late'),
        'Undefined late-attendance rule'
    );

    assertThrows(
        () => attendanceToValue('unknown'),
        'Invalid attendance status'
    );

    console.log('\n--- Testing attendance percentages ---');

    assertEqual(
        calculateAttendancePercentage([
            'present',
            'present',
            'absent',
            'excused'
        ]),
        75,
        'Two present, one absent, one excused'
    );

    assertEqual(
        calculateAttendancePercentage([
            'present',
            'absent',
            'excused',
            'present',
            'present',
            'absent'
        ]),
        66.67,
        'Attendance percentage rounded to two decimals'
    );

    assertEqual(
        calculateAttendancePercentage([
            'present',
            'present',
            'present'
        ]),
        100,
        'Full attendance'
    );

    assertEqual(
        calculateAttendancePercentage([
            'absent',
            'absent'
        ]),
        0,
        'No attendance'
    );

    assertThrows(
        () => calculateAttendancePercentage([]),
        'No applicable sessions'
    );

    assertThrows(
        () => calculateAttendancePercentage('present'),
        'Invalid input type'
    );

    console.log('\nAll attendance service tests passed.');
}

try {
    testAttendanceService();
} catch (error) {
    console.error('Attendance service test failed:', error);
    process.exitCode = 1;
}
