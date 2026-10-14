
import User from './user.js';
import Student from './student.js';
import Lecturer from './lecturer.js';

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

export {
    User,
    Student,
    Lecturer
};
