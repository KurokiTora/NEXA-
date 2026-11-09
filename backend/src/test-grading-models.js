
import sequelize from './config/database.js';

import {
    Class,
    Lecturer,
    Assessment,
    Enrollment,
    GradingConfiguration,
    GradingComponent,
    CourseResult
} from './models/index.js';

async function testGradingModels() {
    try {
        await sequelize.authenticate();
        console.log('Database connection successful.');

        const models = [
            ['GradingConfiguration', GradingConfiguration],
            ['GradingComponent', GradingComponent],
            ['CourseResult', CourseResult]
        ];

        for (const [name, Model] of models) {
            console.log(`\n--- Testing ${name} ---`);

            console.log(
                'Associations:',
                Object.keys(Model.associations)
            );

            await Model.findAll({ limit: 1 });

            console.log(`${name} query successful.`);
        }

        console.log('\n--- Checking related models ---');
        console.log('Class loaded:', Boolean(Class));
        console.log('Lecturer loaded:', Boolean(Lecturer));
        console.log('Assessment loaded:', Boolean(Assessment));
        console.log('Enrollment loaded:', Boolean(Enrollment));

        console.log('\nAll grading model tests passed.');
    } catch (error) {
        console.error('Grading model test failed:', error);
    } finally {
        await sequelize.close();
    }
}

testGradingModels();
