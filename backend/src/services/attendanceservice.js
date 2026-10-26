

/**
 * Converts an attendance status into a binary value.
 *
 * present = 1
 * late    = 1
 * excused = 1
 * absent  = 0
 */
export function attendanceToValue(status) {
    switch (status) {
        case 'present':
        case 'late':
        case 'excused':
            return 1;

        case 'absent':
            return 0;

        default:
            throw new Error(`Invalid attendance status: ${status}`);
    }
}

/**
 * Calculates attendance percentage from applicable class sessions.
 */
export function calculateAttendancePercentage(statuses) {
    if (!Array.isArray(statuses)) {
        throw new Error('Attendance statuses must be an array.');
    }

    if (statuses.length === 0) {
        throw new Error(
            'Cannot calculate attendance when there are no sessions.'
        );
    }

    const attendedSessions = statuses.reduce(
        (total, status) => total + attendanceToValue(status),
        0
    );

    return Number(
        ((attendedSessions / statuses.length) * 100).toFixed(2)
    );
}
