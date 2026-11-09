
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const AttendanceRecord = sequelize.define(
    'AttendanceRecord',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },
        attendanceSessionId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'attendance_session_id'
        },
        enrollmentId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'enrollment_id'
        },
        status: {
            type: DataTypes.ENUM(
                'present',
                'late',
                'absent',
                'excused'
            ),
            allowNull: false
        },
        recordedAt: {
            type: DataTypes.DATE,
            allowNull: false,
            field: 'recorded_at'
        }
    },
    {
        tableName: 'attendance_records',
        timestamps: false,
        indexes: [
            {
                unique: true,
                fields: ['attendance_session_id', 'enrollment_id']
            }
        ]
    }
);

export default AttendanceRecord;
