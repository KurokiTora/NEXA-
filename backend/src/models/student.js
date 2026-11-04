
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Student = sequelize.define(
    'Student',
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

        studentId: {
            type: DataTypes.STRING(50),
            allowNull: false,
            unique: true,
            field: 'student_id'
        },

        fullName: {
            type: DataTypes.STRING(150),
            allowNull: false,
            field: 'full_name'
        }
    },
    {
        tableName: 'students',
        timestamps: false
    }
);

export default Student;
