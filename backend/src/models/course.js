
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Course = sequelize.define(
    'Course',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },

        courseCode: {
            type: DataTypes.STRING(50),
            allowNull: false,
            unique: true,
            field: 'course_code'
        },

        courseName: {
            type: DataTypes.STRING(150),
            allowNull: false,
            field: 'course_name'
        },

        credits: {
            type: DataTypes.DECIMAL(3, 1),
            allowNull: false,
            validate: {
                min: 0.1
            }
        }
    },
    {
        tableName: 'courses',
        timestamps: false
    }
);

export default Course;
