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