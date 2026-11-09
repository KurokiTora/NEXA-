
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const Enrollment = sequelize.define(
    'Enrollment',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },

        studentId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'student_id'
        },

        classId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'class_id'
        },

        status: {
            type: DataTypes.ENUM('active', 'dropped', 'completed'),
            allowNull: false,
            defaultValue: 'active'
        },

        enrolledAt: {
            type: DataTypes.DATE,
            allowNull: false,
            field: 'enrolled_at'
        }
    },
    {
        tableName: 'enrollments',
        timestamps: false,
        indexes: [
            {
                unique: true,
                fields: ['student_id', 'class_id']
            }
        ]
    }
);

export default Enrollment;
