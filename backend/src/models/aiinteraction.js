
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const AIInteraction = sequelize.define(
    'AIInteraction',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },

        userId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'user_id'
        },

        userRole: {
            type: DataTypes.ENUM('student', 'lecturer'),
            allowNull: false,
            field: 'user_role'
        },

        question: {
            type: DataTypes.TEXT,
            allowNull: false
        },

        responseJson: {
            type: DataTypes.JSON,
            allowNull: false,
            field: 'response_json'
        },

        model: {
            type: DataTypes.STRING(100),
            allowNull: false
        },

        status: {
            type: DataTypes.ENUM('success', 'rejected'),
            allowNull: false,
            defaultValue: 'success'
        }
    },
    {
        tableName: 'ai_interactions',
        timestamps: true,
        createdAt: 'created_at',
        updatedAt: false,
        underscored: true
    }
);

export default AIInteraction;

