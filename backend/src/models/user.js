
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const User = sequelize.define(
    'User',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },

        email: {
            type: DataTypes.STRING(255),
            allowNull: false,
            unique: true
        },

        passwordHash: {
            type: DataTypes.STRING(255),
            allowNull: false,
            field: 'password_hash'
        },

        role: {
            type: DataTypes.ENUM('student', 'lecturer'),
            allowNull: false
        }
    },
    {
        tableName: 'users',
        timestamps: true,
        underscored: true
    }
);

export default User;
