import { Pool, Client } from 'pg';
import App from './App';

export class dbHandler {
    pool: Pool;
    client: Client;
    solaceapp: typeof App;
    constructor(app: typeof App) {
        this.pool = new Pool({
            user: process.env.POSTGRES_USER,
            database: process.env.DATABASE,
            password: process.env.PASSWORD,
            host: process.env.HOST,
            port: 5432,
        });
        this.client = new Client({
            user: process.env.POSTGRES_USER,
            database: process.env.DATABASE,
            password: process.env.PASSWORD,
            host: process.env.HOST,
            port: 5432,
        });
        this.solaceapp = app;
    }
    private connectWithPromise() {
        this.client.connect();
        this.client.query('LISTEN leaderboard_update');
        this.client.on('notification', (msg) => {
            console.log('Leaderboard update notification received:', msg.payload);
            this.getLeaderboard().then((leaderboard) => {
                this.solaceapp.publishMessage('Leaderboard', JSON.stringify(leaderboard));
            }).catch((error) => {
                console.error('Error getting leaderboard:', error);
            });
        });
        this.client.on('error', (err) => {
            console.error('Error in PostgreSQL client:', err);
        });
        process.on('exit', () => {
            this.client.end();
        });
    }

    public users = async () => {
        try {
            const text = `SELECT * FROM users;`;
            return this.pool.query(text,);
        } catch (err) {
            console.log(err);
            throw err;
        }
    }

    public scores = async () => {
        try {
            const text = `SELECT * FROM scores;`;
            return this.pool.query(text,);
        } catch (err) {
            console.log(err);
            throw err;
        }
    }

    public getUserScore = async (userId: string) => {
        try {
            const text = `SELECT * FROM scores WHERE user_id = $1;`;
            return this.pool.query(text, [userId]);
        } catch (err) {
            console.log(err);
            throw err;
        }
    }

    // Function to check and process tasks scheduled for today
    public checkScheduledTasks = async () => {
        const today = new Date().toISOString().split('T')[0]; // Get today's date in 'YYYY-MM-DD' format
        try {
            const result = await this.pool.query(
                'SELECT * FROM Tasks WHERE DatePublished = $1',
                [today]
            );
            const tasksToProcess = result.rows;
            return tasksToProcess;
        } catch (error) {
            console.error('Error checking scheduled tasks:', error);
        }
    };

    private getLeaderboard = async () => {
        try {
            const text = `SELECT * FROM leaderboard;`;
            const result = await this.pool.query(text);
            return result.rows;
        } catch (err) {
            console.log(err);
            throw err;
        }
    }
}