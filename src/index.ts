import * as dotenv from 'dotenv';
dotenv.config();
import express, { Express, Request, Response } from 'express';
import cors from 'cors';
import { auth, requiredScopes } from 'express-oauth2-jwt-bearer';
import { scores, users } from './db';

const app: Express = express();
const port = 5000;

app.use(express.json());
app.use(cors());

const checkJwt = auth({
    audience: process.env.REACT_APP_URL,
    issuerBaseURL: process.env.AUTH0_DOMAIN
});

app.get('/', (req: Request, res: Response) => {
    res.send('Hello uOttaHack!');
});

app.get('/users', async (req: Request, res: Response) => {
    const result = await users();
    res.json(result.rows);
});

app.get('/scores', async (req: Request, res: Response) => {
    const result = await scores();
    res.json(result.rows);
});

app.get('/api/private', checkJwt, function (req: Request, res: Response) {
    res.json({
        message: 'Hello from a private endpoint! You need to be authenticated to see this.'
    });
});

app.listen(port, () => {
    return console.log(`Express is listening at http://localhost:${port}`);
});