import 'dotenv/config';
import { Sequelize } from 'sequelize';

const sequelize = new Sequelize(
    process.env.DB_NAME || 'lecturer_assistant',
    process.env.DB_USER || 'root',
    process.env.DB_PASSWORD ?? '',
    {
        host: process.env.DB_HOST || '127.0.0.1',
        port: Number(process.env.DB_PORT || 3306),
        dialect: 'mysql',
        logging: process.env.DB_LOGGING === 'true' ? console.log : false,
        timezone: process.env.DB_TIMEZONE || '+07:00'
    }
);

export default sequelize;
