
import sequelize from './config/database.js';
import { User } from './models/index.js';

async function testCRUD() {
    const transaction = await sequelize.transaction();

    try {
        // CREATE
        const user = await User.create(
            {
                email: 'crud-test@example.com',
                passwordHash: 'temporary-test-hash',
                role: 'student'
            },
            { transaction }
        );

        console.log('Created user:', user.id, user.email);

        // READ
        const foundUser = await User.findByPk(user.id, {
            transaction
        });

        console.log('Read user:', foundUser.email);

        // UPDATE
        foundUser.email = 'updated-test@example.com';
        await foundUser.save({ transaction });

        console.log('Updated email:', foundUser.email);

        // DELETE
        await foundUser.destroy({ transaction });

        console.log('Deleted test user.');

        // Undo all test changes.
        await transaction.rollback();

        console.log('Transaction rolled back. No test data retained.');
    } catch (error) {
        if (!transaction.finished) {
            await transaction.rollback();
        }

        console.error('CRUD test failed:', error);
    } finally {
        await sequelize.close();
    }
}

testCRUD();
