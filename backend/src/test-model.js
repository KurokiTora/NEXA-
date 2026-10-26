
import sequelize from './config/database.js';
import User from './models/user.js';

async function testModel() {
    try {
        await sequelize.authenticate();

        const userCount = await User.count();

        console.log('User model works!');
        console.log('Current number of users:', userCount);
    } catch (error) {
        console.error('Model test failed:', error);
    } finally {
        await sequelize.close();
    }
}

testModel();
