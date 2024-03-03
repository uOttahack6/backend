import * as dotenv from 'dotenv';
dotenv.config();
import cors from 'cors';
import express, { Express, Request, Response } from 'express';
import { auth, requiredScopes } from 'express-oauth2-jwt-bearer';
import app from './App';
import { dbHandler } from './db';
//import cron from 'node-cron';

const expressApp: Express = express();
const port = 5000;

expressApp.use(express.json());
expressApp.use(cors());

const db = new dbHandler(app);

const checkJwt = auth({
    audience: process.env.REACT_APP_URL,
    issuerBaseURL: process.env.AUTH0_DOMAIN
});

expressApp.get('/', (req: Request, res: Response) => {
    res.send('Hello uOttaHack!');
});

expressApp.get('/testing/users', async (req: Request, res: Response) => {
    const result = await db.users();
    res.json(result.rows);
});

expressApp.get('/testing/scores', async (req: Request, res: Response) => {
    const result = await db.scores();
    res.json(result.rows);
});

expressApp.get('/api/private', checkJwt, function (req: Request, res: Response) {
    res.json({
        message: 'Hello from a private endpoint! You need to be authenticated to see this.'
    });
});

expressApp.post('/api/private/TaskDone', checkJwt, function (req: Request, res: Response) {
    const userId: string = req.body.user.sub;
    const taskId: number = req.body.taskId;
    console.log('Task done by user', userId, 'Task ID:', taskId);
});

function initializeApplication() {
    app.initialize();
}
initializeApplication();

const scheduledTask = async () => {
    console.log('Checking for scheduled tasks...');
    db.checkScheduledTasks().then((tasks) => {
        console.log('Tasks to process:', tasks);
        app.publishMessage('ScheduledTasks', JSON.stringify(tasks));
    }).catch((error) => {
        console.error('Error checking scheduled tasks:', error);
    });
}
/* Schedule the task check every day at 9 am
cron.schedule('0 9 * * *', () => {
    scheduledTask();
});
 */

expressApp.get('/testing/scheduledTasks', (req: Request, res: Response) => {
    scheduledTask();
    res.status(200).send('{"result":"ok"}');
});

expressApp.listen(port, () => {
    return console.log(`Express is listening at http://localhost:${port}`);
});