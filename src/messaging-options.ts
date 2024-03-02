
export default function msgOptions() {
    return {
        host: process.env.SOLACE_HOST,
        username: process.env.SOLACE_USERNAME,
        password: process.env.SOLACE_PASSWORD,
        clientId: process.env.SOLACE_CLIENT_ID,
        keepalive: 10,
        clean: true,
        reconnectPeriod: 1000,
        connectTimeout: 10000,
        will: {
            topic: 'WillMsg',
            payload: Buffer.from('Connection Closed abnormally..!', 'utf-8'),
            qos: 1 as 0 | 1 | 2,
            retain: false
        },
        rejectUnauthorized: false
    }
}