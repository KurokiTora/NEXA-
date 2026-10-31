import 'dotenv/config';
import express from 'express';
import cors from 'cors';

import sequelize from './config/database.js';
import apiRoutes from './routes/index.js';

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// API routes
app.use('/api', apiRoutes);

// Handle unknown routes
app.use((req, res) => {
    res.status(404).json({
        success: false,
        message: 'API endpoint not found.'
    });
});

// Connect to database, then start server
async function startServer() {
    try {
        await sequelize.authenticate();

        console.log('Database connection successful.');

        app.listen(PORT, () => {
            console.log(`Backend server running at http://localhost:${PORT}`);
        });
    } catch (error) {
        console.error('Unable to start backend:', error.message);
        process.exit(1);
    }
}

startServer();