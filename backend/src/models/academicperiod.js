
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const AcademicPeriod = sequelize.define(
    'AcademicPeriod',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },

        academicYear: {
            type: DataTypes.STRING(20),
            allowNull: false,
            field: 'academic_year'
        },

        semester: {
            type: DataTypes.ENUM('odd', 'even', 'short'),
            allowNull: false
        },

        startDate: {
            type: DataTypes.DATEONLY,
            allowNull: false,
            field: 'start_date'
        },

        endDate: {
            type: DataTypes.DATEONLY,
            allowNull: false,
            field: 'end_date',
            validate: {
                isAfterStartDate(value) {
                    if (value < this.startDate) {
                        throw new Error(
                            'End date cannot be before start date.'
                        );
                    }
                }
            }
        }
    },
    {
        tableName: 'academic_periods',
        timestamps: false,
        indexes: [
            {
                unique: true,
                fields: ['academic_year', 'semester']
            }
        ]
    }
);

export default AcademicPeriod;
