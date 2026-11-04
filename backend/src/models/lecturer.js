
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Lecturer = sequelize.define(
    'Lecturer',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },

        userId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            unique: true,
            field: 'user_id'
        },

        lecturerId: {
            type: DataTypes.STRING(50),
            allowNull: false,
            unique: true,
            field: 'lecturer_id'
        },

        fullName: {
            type: DataTypes.STRING(150),
            allowNull: false,
            field: 'full_name'
        }
    },
    {
        tableName: 'lecturers',
        timestamps: false
    }
);

export default Lecturer;
