import { Pool } from 'pg';

const pool = new Pool({
    user: process.env.POSTGRES_USER,
    database: process.env.DATABASE,
    password: process.env.PASSWORD,
    host: process.env.HOST,
    port: 5432,
});

export const users = async () => {
    try {
        const text = `SELECT * FROM users;`;
        return pool.query(text,);
    } catch (err) {
        console.log(err);
        throw err;
    }
}

export const scores = async () => {
    try {
        const text = `SELECT * FROM scores;`;
        return pool.query(text,);
    } catch (err) {
        console.log(err);
        throw err;
    }
}

// Function to check and process tasks scheduled for today
export const checkScheduledTasks = async () => {
    const today = new Date().toISOString().split('T')[0]; // Get today's date in 'YYYY-MM-DD' format
    try {
        const result = await pool.query(
            'SELECT * FROM Tasks WHERE DatePublished = $1',
            [today]
        );
        const tasksToProcess = result.rows;
        return tasksToProcess;
    } catch (error) {
        console.error('Error checking scheduled tasks:', error);
    }
};