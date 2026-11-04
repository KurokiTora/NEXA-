
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const AssessmentScore = sequelize.define(
    'AssessmentScore',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },

        assessmentId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'assessment_id'
        },

        enrollmentId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'enrollment_id'
        },

        score: {
            type: DataTypes.DECIMAL(6, 2),
            allowNull: false,
            validate: {
                min: 0
            }
        },

        feedback: {
            type: DataTypes.TEXT,
            allowNull: true
        },

        gradedAt: {
            type: DataTypes.DATE,
            allowNull: true,
            field: 'graded_at'
        }
    },
    {
        tableName: 'assessment_scores',
        timestamps: true,
        createdAt: false,
        updatedAt: 'updatedAt',
        underscored: true
    }
);

export default AssessmentScore;
