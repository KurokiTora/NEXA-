
import sequelize from './config/database.js';

import {
    Course,
    AcademicPeriod,
    Class,
    Enrollment
} from './models/index.js';

async function testAcademicModels() {
    try {
        await sequelize.authenticate();

        console.log('Database connection successful.');

        console.log('Course associations:',
            Object.keys(Course.associations));

        console.log('AcademicPeriod associations:',
            Object.keys(AcademicPeriod.associations));

        console.log('Class associations:',
            Object.keys(Class.associations));

        console.log('Enrollment associations:',
            Object.keys(Enrollment.associations));

        // Test reads against existing tables.
        const courses = await Course.findAll({ limit: 1 });
        const periods = await AcademicPeriod.findAll({ limit: 1 });
        const classes = await Class.findAll({ limit: 1 });
        const enrollments = await Enrollment.findAll({ limit: 1 });

        console.log('All academic models queried successfully.');
        console.log({
            coursesFound: courses.length,
            periodsFound: periods.length,
            classesFound: classes.length,
            enrollmentsFound: enrollments.length
        });
    } catch (error) {
        console.error('Academic model test failed:', error);
    } finally {
        await sequelize.close();
    }
}

testAcademicModels();
