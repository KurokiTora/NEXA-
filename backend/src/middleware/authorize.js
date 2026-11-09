export function authorize(...allowedRoles) {
    return (req, res, next) => {

        // Ensure authentication has already happened
        if (!req.user) {
            return res.status(401).json({
                success: false,
                message: 'Authentication is required.',
                data: null
            });
        }

        // Check whether the user's role is permitted
        if (!allowedRoles.includes(req.user.role)) {
            return res.status(403).json({
                success: false,
                message: 'You do not have permission to access this resource.',
                data: null
            });
        }

        next();
    };
}