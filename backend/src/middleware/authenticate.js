import jwt from 'jsonwebtoken';

export function authenticate(req, res, next) {
    const authHeader = req.headers.authorization;

    // Check whether the Authorization header exists
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({
            success: false,
            message: 'Authentication token is required.',
            data: null
        });
    }

    // Extract the token
    const token = authHeader.split(' ')[1];

    try {
        // Verify the token
        const decoded = jwt.verify(
            token,
            process.env.JWT_SECRET
        );

        // Validate the token payload
        if (
            !decoded.sub ||
            !['lecturer', 'student'].includes(decoded.role)
        ) {
            return res.status(401).json({
                success: false,
                message: 'Invalid authentication token.',
                data: null
            });
        }

        // Attach authenticated user information to the request
        req.user = {
            id: decoded.sub,
            role: decoded.role
        };

        next();

    } catch (error) {
        return res.status(401).json({
            success: false,
            message: 'Invalid or expired authentication token.',
            data: null
        });
    }
}