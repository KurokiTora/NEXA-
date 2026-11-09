
import sequelize from './config/database.js';

import {
    Assessment,
    Assignment,
    Submission,
    SubmissionFile,
    AssessmentScore
} from './models/index.js';

async function testAssessmentModels() {
    try {
        await sequelize.authenticate();

        console.log('Database connection successful.');

        console.log('Assessment associations:',
            Object.keys(Assessment.associations));

        console.log('Assignment associations:',
            Object.keys(Assignment.associations));

        console.log('Submission associations:',
            Object.keys(Submission.associations));

        console.log('SubmissionFile associations:',
            Object.keys(SubmissionFile.associations));

        console.log('AssessmentScore associations:',
            Object.keys(AssessmentScore.associations));

        // Read from each existing table.
        const assessments = await Assessment.findAll({ limit: 1 });
        const assignments = await Assignment.findAll({ limit: 1 });
        const submissions = await Submission.findAll({ limit: 1 });
        const files = await SubmissionFile.findAll({ limit: 1 });
        const scores = await AssessmentScore.findAll({ limit: 1 });

        console.log('All assessment models queried successfully.');

        console.log({
            assessmentsFound: assessments.length,
            assignmentsFound: assignments.length,
            submissionsFound: submissions.length,
            filesFound: files.length,
            scoresFound: scores.length
        });
    } catch (error) {
        console.error('Assessment model test failed:', error);
    } finally {
        await sequelize.close();
    }
}

testAssessmentModels();
