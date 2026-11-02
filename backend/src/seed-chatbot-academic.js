
import 'dotenv/config';
import sequelize from './config/database.js';

import {
    Student,
    Lecturer,
    Course,
    AcademicPeriod,
    Class,
    Enrollment,
    Assessment,
    Assignment,
    Submission,
    AssessmentScore,
    AttendanceSession,
    AttendanceRecord,
    GradingConfiguration,
    GradingComponent
} from './models/index.js';

import {
    calculateAndSaveCourseResult
} from './services/courseresultservice.js';

const GRADE_SCALE = [
    { minScore: 80, gradePoint: 4.0 },
    { minScore: 70, gradePoint: 3.0 },
    { minScore: 60, gradePoint: 2.0 },
    { minScore: 50, gradePoint: 1.0 },
    { minScore: 0, gradePoint: 0.0 }
];

async function seedChatbotAcademic() {
    let transaction;

    try {
        console.log('Memulai data simulasi NEXA...');

        await sequelize.authenticate();

        transaction = await sequelize.transaction();

        // 1. Ambil profil akun pengujian.
        const student = await Student.findOne({
            where: { userId: 3 },
            transaction
        });

        const lecturer = await Lecturer.findOne({
            where: { userId: 2 },
            transaction
        });

        if (!student || !lecturer) {
            throw new Error('Profil mahasiswa atau dosen tidak ditemukan.');
        }

        // 2. Buat mata kuliah.
        const [course] = await Course.findOrCreate({
            where: { courseCode: 'NEXA-SIM-101' },
            defaults: {
                courseName: 'Pemrograman Dasar',
                credits: 3
            },
            transaction
        });

        if (
            course.courseName !== 'Pemrograman Dasar' ||
            Number(course.credits) !== 3
        ) {
            throw new Error('Data mata kuliah simulasi tidak sesuai.');
        }

        // 3. Buat periode akademik.
        const [period] = await AcademicPeriod.findOrCreate({
            where: {
                academicYear: '2026/2027',
                semester: 'odd'
            },
            defaults: {
                startDate: '2026-08-01',
                endDate: '2026-12-31'
            },
            transaction
        });

        // 4. Buat kelas.
        const [classData] = await Class.findOrCreate({
            where: { joinCode: 'NEXA-SIM-JOIN-001' },
            defaults: {
                courseId: course.id,
                lecturerId: lecturer.id,
                academicPeriodId: period.id,
                classCode: 'NEXA-SIM-A'
            },
            transaction
        });

        if (
            Number(classData.courseId) !== Number(course.id) ||
            Number(classData.lecturerId) !== Number(lecturer.id) ||
            Number(classData.academicPeriodId) !== Number(period.id)
        ) {
            throw new Error('Relasi kelas simulasi tidak sesuai.');
        }

        // 5. Daftarkan mahasiswa ke kelas.
        const [enrollment] = await Enrollment.findOrCreate({
            where: {
                studentId: student.id,
                classId: classData.id
            },
            defaults: {
                status: 'active',
                enrolledAt: '2026-08-05'
            },
            transaction
        });

        // 6. Buat tugas, UTS, dan UAS.
        const assessmentDefinitions = [
            {
                title: 'Tugas Simulasi 1',
                type: 'assignment',
                score: 90
            },
            {
                title: 'Ujian Tengah Semester',
                type: 'exam',
                score: 80
            },
            {
                title: 'Ujian Akhir Semester',
                type: 'exam',
                score: 90
            }
        ];

        const assessments = {};

        for (const item of assessmentDefinitions) {
            const [assessment] = await Assessment.findOrCreate({
                where: {
                    classId: classData.id,
                    title: item.title
                },
                defaults: {
                    description: `Data pengujian ${item.title}.`,
                    type: item.type,
                    maxScore: 100,
                    dueAt: null
                },
                transaction
            });

            if (assessment.type !== item.type) {
                throw new Error(`Tipe asesmen ${item.title} tidak sesuai.`);
            }

            assessments[item.title] = assessment;

            await AssessmentScore.findOrCreate({
                where: {
                    assessmentId: assessment.id,
                    enrollmentId: enrollment.id
                },
                defaults: {
                    score: item.score,
                    feedback: 'Nilai simulasi untuk pengujian chatbot.',
                    gradedAt: '2026-09-30 10:00:00'
                },
                transaction
            });
        }

        const assignmentAssessment =
            assessments['Tugas Simulasi 1'];

        const midtermAssessment =
            assessments['Ujian Tengah Semester'];

        const finalExamAssessment =
            assessments['Ujian Akhir Semester'];

        // 7. Buat data tugas dan pengumpulan.
        const [assignment] = await Assignment.findOrCreate({
            where: {
                assessmentId: assignmentAssessment.id
            },
            defaults: {
                assessmentId: assignmentAssessment.id
            },
            transaction
        });

        await Submission.findOrCreate({
            where: {
                assignmentId: assignment.id,
                enrollmentId: enrollment.id
            },
            defaults: {
                submittedAt: '2026-09-24 14:00:00'
            },
            transaction
        });

        // 8. Buat konfigurasi penilaian.
        const [gradingConfig] =
            await GradingConfiguration.findOrCreate({
                where: {
                    classId: classData.id,
                    version: 1
                },
                defaults: {
                    createdBy: lecturer.id
                },
                transaction
            });

        if (
            Number(gradingConfig.createdBy) !== Number(lecturer.id)
        ) {
            throw new Error('Pembuat konfigurasi nilai tidak sesuai.');
        }

        // 9. Komponen penilaian mengikuti gradingService.js.
        const gradingComponents = [
            {
                name: 'Rata-rata Tugas',
                componentType: 'assignment_average',
                weight: 40,
                assessmentId: null
            },
            {
                name: 'Kehadiran',
                componentType: 'attendance',
                weight: 30,
                assessmentId: null
            },
            {
                name: 'UTS',
                componentType: 'assessment',
                weight: 15,
                assessmentId: midtermAssessment.id
            },
            {
                name: 'UAS',
                componentType: 'assessment',
                weight: 15,
                assessmentId: finalExamAssessment.id
            }
        ];

        for (const item of gradingComponents) {
            const [component] =
                await GradingComponent.findOrCreate({
                    where: {
                        gradingConfigurationId: gradingConfig.id,
                        name: item.name
                    },
                    defaults: item,
                    transaction
                });

            if (
                component.componentType !== item.componentType ||
                Number(component.weight) !== item.weight ||
                Number(component.assessmentId ?? 0) !==
                    Number(item.assessmentId ?? 0)
            ) {
                throw new Error(
                    `Konfigurasi komponen ${item.name} tidak sesuai.`
                );
            }
        }

        // 10. Buat tiga sesi kehadiran.
        const attendanceData = [
            { date: '2026-09-02', status: 'present' },
            { date: '2026-09-09', status: 'late' },
            { date: '2026-09-16', status: 'absent' }
        ];

        for (const item of attendanceData) {
            const [session] = await AttendanceSession.findOrCreate({
                where: {
                    classId: classData.id,
                    sessionDate: item.date
                },
                defaults: {},
                transaction
            });

            await AttendanceRecord.findOrCreate({
                where: {
                    attendanceSessionId: session.id,
                    enrollmentId: enrollment.id
                },
                defaults: {
                    status: item.status
                },
                transaction
            });
        }

        // Simpan seluruh data akademik.
        await transaction.commit();
        transaction = null;

        // 11. Hitung nilai menggunakan service asli NEXA.
        const result = await calculateAndSaveCourseResult({
            enrollmentId: enrollment.id,
            midtermAssessmentId: midtermAssessment.id,
            finalExamAssessmentId: finalExamAssessment.id,
            gradingConfigurationId: gradingConfig.id,
            gradeScale: GRADE_SCALE
        });

        console.log('\nDATA SIMULASI BERHASIL DIBUAT');
        console.log('Mata kuliah:', course.courseName);
        console.log('Kode kelas:', classData.classCode);
        console.log('Mahasiswa:', student.fullName);
        console.log('Dosen:', lecturer.fullName);
        console.log('Rata-rata tugas:', result.assignmentAverage);
        console.log('Kehadiran:', result.attendance + '%');
        console.log('Nilai UTS:', result.midterm);
        console.log('Nilai UAS:', result.finalExam);
        console.log('Nilai akhir:', result.finalScore);
        console.log('Grade point:', result.gradePoint);

    } catch (error) {
        if (transaction && !transaction.finished) {
            await transaction.rollback();
        }

        console.error('\nGAGAL MEMBUAT DATA SIMULASI');
        console.error(error.message);

        process.exitCode = 1;
    } finally {
        await sequelize.close();
    }
}

seedChatbotAcademic();
