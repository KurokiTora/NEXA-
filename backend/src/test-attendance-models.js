
import sequelize from './config/database.js';

import {
    Class,
    Enrollment,
    AttendanceSession,
    AttendanceRecord
} from './models/index.js';

async function testAttendanceModels() {
    try {
        await sequelize.authenticate();
        console.log('Database connection successful.');

        console.log('\n--- Testing AttendanceSession ---');
        console.log(
            'Associations:',
            Object.keys(AttendanceSession.associations)
        );
        await AttendanceSession.findAll({ limit: 1 });
        console.log('AttendanceSession query successful.');

        console.log('\n--- Testing AttendanceRecord ---');
        console.log(
            'Associations:',
            Object.keys(AttendanceRecord.associations)
        );
        await AttendanceRecord.findAll({ limit: 1 });
        console.log('AttendanceRecord query successful.');

        console.log('\n--- Checking related models ---');
        console.log('Class loaded:', Boolean(Class));
        console.log('Enrollment loaded:', Boolean(Enrollment));

        console.log('\nAll attendance model tests passed.');
    } catch (error) {
        console.error('Attendance model test failed:', error);
    } finally {
        await sequelize.close();
    }
}

testAttendanceModels();
