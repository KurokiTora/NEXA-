import 'dotenv/config';
import bcrypt from 'bcrypt';

import sequelize from './config/database.js';

import {
    User,
    Lecturer,
    Student
} from './models/index.js';

async function seedUsers() {
    const transaction = await sequelize.transaction();

    try {
        // Read test account credentials
        const lecturerEmail = process.env.SEED_LECTURER_EMAIL;
        const lecturerPassword = process.env.SEED_LECTURER_PASSWORD;
        const lecturerId = process.env.SEED_LECTURER_ID;

        const studentEmail = process.env.SEED_STUDENT_EMAIL;
        const studentPassword = process.env.SEED_STUDENT_PASSWORD;
        const studentId = process.env.SEED_STUDENT_ID;

        // Validate environment variables
        if (
            !lecturerEmail || !lecturerPassword || !lecturerId ||
            !studentEmail || !studentPassword || !studentId
        ) {
            throw new Error('Missing test account environment variables.');
        }

        // Check for existing accounts
        const existingLecturer = await User.findOne({
            where: { email: lecturerEmail },
            transaction
        });

        const existingStudent = await User.findOne({
            where: { email: studentEmail },
            transaction
        });

        if (existingLecturer || existingStudent) {
            throw new Error(
                'One or both test accounts already exist. No accounts were created.'
            );
        }

        // Hash passwords
        const lecturerHash = await bcrypt.hash(lecturerPassword, 12);
        const studentHash = await bcrypt.hash(studentPassword, 12);

        // Create lecturer account
        const lecturerUser = await User.create({
            email: lecturerEmail,
            passwordHash: lecturerHash,
            role: 'lecturer'
        }, { transaction });

        await Lecturer.create({
            userId: lecturerUser.id,
            lecturerId,
            fullName: 'Test Lecturer'
        }, { transaction });

        // Create student account
        const studentUser = await User.create({
            email: studentEmail,
            passwordHash: studentHash,
            role: 'student'
        }, { transaction });

        await Student.create({
            userId: studentUser.id,
            studentId,
            fullName: 'Test Student'
        }, { transaction });

        // Commit transaction
        await transaction.commit();

        console.log('Test accounts created successfully.');
        console.log(`Lecturer: ${lecturerEmail}`);
        console.log(`Student: ${studentEmail}`);

    } catch (error) {
        await transaction.rollback();
        throw error;
    }
}

try {
    await sequelize.authenticate();
    await seedUsers();
} catch (error) {
    console.error('Seeding failed:', error.message);
    process.exitCode = 1;
} finally {
    await sequelize.close();
}