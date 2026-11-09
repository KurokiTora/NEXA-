
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Submission = sequelize.define(
    'Submission',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },

        assignmentId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'assignment_id'
        },

        enrollmentId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'enrollment_id'
        },

        submittedAt: {
            type: DataTypes.DATE,
            allowNull: false,
            field: 'submitted_at'
        }
    },
    {
        tableName: 'submissions',
        timestamps: true,
        underscored: true,
        indexes: [
            {
                unique: true,
                fields: ['assignment_id', 'enrollment_id']
            }
        ]
    }
);

export default Submission;
