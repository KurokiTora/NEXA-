
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Assessment = sequelize.define(
    'Assessment',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },

        classId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'class_id'
        },

        title: {
            type: DataTypes.STRING(200),
            allowNull: false
        },

        description: {
            type: DataTypes.TEXT,
            allowNull: true
        },

        type: {
            type: DataTypes.ENUM(
                'assignment',
                'exam',
                'quiz',
                'other'
            ),
            allowNull: false
        },

        maxScore: {
            type: DataTypes.DECIMAL(6, 2),
            allowNull: false,
            field: 'max_score',
            validate: {
                min: 0.01
            }
        },

        dueAt: {
            type: DataTypes.DATE,
            allowNull: true,
            field: 'due_at'
        }
    },
    {
        tableName: 'assessments',
        timestamps: true,
        underscored: true
    }
);

export default Assessment;
