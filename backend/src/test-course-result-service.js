
import sequelize from './config/database.js';

import {
    calculateAndSaveCourseResult
} from './services/courseresultservice.js';

async function testCourseResultService() {
    try {
        await sequelize.authenticate();

        console.log('Database connection successful.');
        console.log(
            'Service imported:',
            typeof calculateAndSaveCourseResult === 'function'
        );

        console.log(
            'Course result service is ready for integration testing.'
        );
    } catch (error) {
        console.error('Course result service test failed:', error);
        process.exitCode = 1;
    } finally {
        await sequelize.close();
    }
}

testCourseResultService();
