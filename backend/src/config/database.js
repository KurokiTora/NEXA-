import { Sequelize } from 'sequelize';

const sequelize = new Sequelize(
    'lecturer_assistant',
    'root',
    '',
    {
        host: 'localhost',
        dialect: 'mysql',
        logging: console.log
    }
);

export default sequelize;