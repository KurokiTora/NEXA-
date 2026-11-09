
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const GradingComponent = sequelize.define(
    'GradingComponent',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },
        gradingConfigurationId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'grading_configuration_id'
        },
        name: {
            type: DataTypes.STRING(150),
            allowNull: false
        },
        componentType: {
            type: DataTypes.ENUM(
                'assessment',
                'assignment_average',
                'attendance'
            ),
            allowNull: false,
            field: 'component_type'
        },
        weight: {
            type: DataTypes.DECIMAL(5, 2),
            allowNull: false,
            validate: {
                min: 0,
                max: 100
            }
        },
        assessmentId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: true,
            field: 'assessment_id'
        }
    },
    {
        tableName: 'grading_components',
        timestamps: false
    }
);

export default GradingComponent;
