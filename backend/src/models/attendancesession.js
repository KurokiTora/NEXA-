
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const AttendanceSession = sequelize.define(
    'AttendanceSession',
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
        sessionDate: {
            type: DataTypes.DATEONLY,
            allowNull: false,
            field: 'session_date'
        }
    },
    {
        tableName: 'attendance_sessions',
        timestamps: true,
        createdAt: true,
        updatedAt: false,
        underscored: true,
        indexes: [
            {
                unique: true,
                fields: ['class_id', 'session_date']
            }
        ]
    }
);

export default AttendanceSession;
