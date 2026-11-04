
import sequelize from './config/database.js';
import { User, Student, Lecturer } from './models/index.js';

async function testAssociations() {
    try {
        await sequelize.authenticate();

        console.log(
            'User associations:',
            Object.keys(User.associations)
        );

        console.log(
            'Student associations:',
            Object.keys(Student.associations)
        );

        console.log(
            'Lecturer associations:',
            Object.keys(Lecturer.associations)
        );

        // Verify that Sequelize can query a user
        // together with the associated student profile.
        const users = await User.findAll({
            include: [
                { model: Student, as: 'student' },
                { model: Lecturer, as: 'lecturer' }
            ]
        });

        console.log('Association query successful!');
        console.log('Users retrieved:', users.length);
    } catch (error) {
        console.error('Association test failed:', error);
    } finally {
        await sequelize.close();
    }
}

testAssociations();
