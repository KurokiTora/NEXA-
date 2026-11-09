
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const GradingConfiguration = sequelize.define(
    'GradingConfiguration',
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
        version: {
            type: DataTypes.INTEGER.UNSIGNED,
            allowNull: false,
            validate: {
                min: 1
            }
        },
        createdBy: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'created_by'
        },
        createdAt: {
            type: DataTypes.DATE,
            allowNull: false,
            field: 'created_at'
        }
    },
    {
        tableName: 'grading_configurations',
        timestamps: false,
        indexes: [
            {
                unique: true,
                fields: ['class_id', 'version']
            }
        ]
    }
);

export default GradingConfiguration;
