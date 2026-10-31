import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

import { User } from '../models/index.js';

export async function loginUser(email, password) {
    // Validate input
    if (!email || !password) {
        throw new Error('Email and password are required.');
    }

    // Find account
    const user = await User.findOne({
        where: {
            email: email.trim().toLowerCase()
        }
    });

    // Reject nonexistent accounts
    if (!user) {
        throw new Error('Invalid email or password.');
    }

    // Verify password
    const passwordMatches = await bcrypt.compare(
        password,
        user.passwordHash
    );

    if (!passwordMatches) {
        throw new Error('Invalid email or password.');
    }

    // Ensure JWT configuration exists
    if (!process.env.JWT_SECRET) {
        throw new Error('JWT_SECRET is not configured.');
    }

    // Generate JWT
    const token = jwt.sign(
        {
            sub: String(user.id),
            role: user.role
        },
        process.env.JWT_SECRET,
        {
            expiresIn: process.env.JWT_EXPIRES_IN || '1d'
        }
    );

    // Return sanitized account information
    return {
        token,
        user: {
            id: user.id,
            email: user.email,
            role: user.role
        }
    };
}