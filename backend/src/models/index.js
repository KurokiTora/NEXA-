
import User from './user.js';
import Student from './student.js';
import Lecturer from './lecturer.js';
import Course from './course.js';
import AcademicPeriod from './academicperiod.js';
import Class from './class.js';
import Enrollment from './enrollment.js';
import Assessment from './assessment.js';
import Assignment from './assignment.js';
import Submission from './submission.js';
import SubmissionFile from './submissionfile.js';
import AssessmentScore from './assessmentscore.js';

// A user account may have one student profile.
User.hasOne(Student, {
    foreignKey: 'userId',
    as: 'student'
});

Student.belongsTo(User, {
    foreignKey: 'userId',
    as: 'user'
});

// A user account may have one lecturer profile.
User.hasOne(Lecturer, {
    foreignKey: 'userId',
    as: 'lecturer'
});

Lecturer.belongsTo(User, {
    foreignKey: 'userId',
    as: 'user'
});

/* Academic structure */

// A course can have many class offerings.
Course.hasMany(Class, {
    foreignKey: 'courseId',
    as: 'classes'
});

Class.belongsTo(Course, {
    foreignKey: 'courseId',
    as: 'course'
});

// An academic period can contain many classes.
AcademicPeriod.hasMany(Class, {
    foreignKey: 'academicPeriodId',
    as: 'classes'
});

Class.belongsTo(AcademicPeriod, {
    foreignKey: 'academicPeriodId',
    as: 'academicPeriod'
});

// A lecturer can teach many classes.
Lecturer.hasMany(Class, {
    foreignKey: 'lecturerId',
    as: 'classes'
});

Class.belongsTo(Lecturer, {
    foreignKey: 'lecturerId',
    as: 'lecturer'
});

// A class can have many enrollments.
Class.hasMany(Enrollment, {
    foreignKey: 'classId',
    as: 'enrollments'
});

Enrollment.belongsTo(Class, {
    foreignKey: 'classId',
    as: 'class'
});

// A student can enroll in many classes.
Student.hasMany(Enrollment, {
    foreignKey: 'studentId',
    as: 'enrollments'
});

Enrollment.belongsTo(Student, {
    foreignKey: 'studentId',
    as: 'student'
});

/* Assessments and submissions */

// A class contains many assessments.
Class.hasMany(Assessment, {
    foreignKey: 'classId',
    as: 'assessments'
});

Assessment.belongsTo(Class, {
    foreignKey: 'classId',
    as: 'class'
});

// An assessment may have one file-submission assignment.
Assessment.hasOne(Assignment, {
    foreignKey: 'assessmentId',
    as: 'assignment'
});

Assignment.belongsTo(Assessment, {
    foreignKey: 'assessmentId',
    as: 'assessment'
});

// An assignment can receive submissions from many enrollments.
Assignment.hasMany(Submission, {
    foreignKey: 'assignmentId',
    as: 'submissions'
});

Submission.belongsTo(Assignment, {
    foreignKey: 'assignmentId',
    as: 'assignment'
});

// One enrollment can submit to many assignments.
Enrollment.hasMany(Submission, {
    foreignKey: 'enrollmentId',
    as: 'submissions'
});

Submission.belongsTo(Enrollment, {
    foreignKey: 'enrollmentId',
    as: 'enrollment'
});

// A submission can contain multiple files.
Submission.hasMany(SubmissionFile, {
    foreignKey: 'submissionId',
    as: 'files'
});

SubmissionFile.belongsTo(Submission, {
    foreignKey: 'submissionId',
    as: 'submission'
});

// An assessment can have scores for many enrollments.
Assessment.hasMany(AssessmentScore, {
    foreignKey: 'assessmentId',
    as: 'scores'
});

AssessmentScore.belongsTo(Assessment, {
    foreignKey: 'assessmentId',
    as: 'assessment'
});

// An enrollment can receive scores for many assessments.
Enrollment.hasMany(AssessmentScore, {
    foreignKey: 'enrollmentId',
    as: 'assessmentScores'
});

AssessmentScore.belongsTo(Enrollment, {
    foreignKey: 'enrollmentId',
    as: 'enrollment'
});


export {
    User,
    Student,
    Lecturer,
    Course,
    AcademicPeriod,
    Class,
    Enrollment,
    Assessment,
    Assignment,
    Submission,
    SubmissionFile,
    AssessmentScore
};
