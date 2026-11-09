
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Class = sequelize.define(
    'Class',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },

        courseId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'course_id'
        },

        lecturerId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'lecturer_id'
        },

        academicPeriodId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'academic_period_id'
        },

        classCode: {
            type: DataTypes.STRING(50),
            allowNull: false,
            field: 'class_code'
        },

        joinCode: {
            type: DataTypes.STRING(50),
            allowNull: false,
            unique: true,
            field: 'join_code'
        }
    },
    {
        tableName: 'classes',
        timestamps: true,
        underscored: true,
        indexes: [
            {
                unique: true,
                fields: [
                    'course_id',
                    'academic_period_id',
                    'class_code'
                ]
            }
        ]
    }
);

export default Class;
