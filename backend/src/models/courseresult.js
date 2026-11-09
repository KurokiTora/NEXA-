
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const CourseResult = sequelize.define(
    'CourseResult',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },
        enrollmentId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'enrollment_id'
        },
        gradingConfigurationId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'grading_configuration_id'
        },
        finalScore: {
            type: DataTypes.DECIMAL(6, 2),
            allowNull: false,
            field: 'final_score',
            validate: {
                min: 0,
                max: 100
            }
        },
        gradePoint: {
            type: DataTypes.DECIMAL(3, 2),
            allowNull: false,
            field: 'grade_point',
            validate: {
                min: 0,
                max: 4
            }
        },
        calculatedAt: {
            type: DataTypes.DATE,
            allowNull: false,
            field: 'calculated_at'
        }
    },
    {
        tableName: 'course_results',
        timestamps: false,
        indexes: [
            {
                unique: true,
                fields: [
                    'enrollment_id',
                    'grading_configuration_id'
                ]
            }
        ]
    }
);

export default CourseResult;
