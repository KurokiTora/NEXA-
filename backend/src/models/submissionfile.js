
import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js';

const SubmissionFile = sequelize.define(
    'SubmissionFile',
    {
        id: {
            type: DataTypes.BIGINT.UNSIGNED,
            autoIncrement: true,
            primaryKey: true
        },

        submissionId: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'submission_id'
        },

        fileName: {
            type: DataTypes.STRING(255),
            allowNull: false,
            field: 'file_name'
        },

        storageKey: {
            type: DataTypes.STRING(500),
            allowNull: false,
            field: 'storage_key'
        },

        mimeType: {
            type: DataTypes.STRING(100),
            allowNull: false,
            field: 'mime_type'
        },

        fileSize: {
            type: DataTypes.BIGINT.UNSIGNED,
            allowNull: false,
            field: 'file_size',
            validate: {
                min: 1
            }
        },

        uploadedAt: {
            type: DataTypes.DATE,
            allowNull: false,
            field: 'uploaded_at'
        }
    },
    {
        tableName: 'submission_files',
        timestamps: false
    }
);

export default SubmissionFile;
