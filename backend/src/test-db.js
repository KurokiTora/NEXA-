import sequelize from './config/database.js';

async function testConnection() {
    try {
        await sequelize.authenticate();

        console.log('Database connection successful.');
    } catch (error) {
        console.error('Unable to connect to the database:');
        console.error(error);
    }
}

testConnection();