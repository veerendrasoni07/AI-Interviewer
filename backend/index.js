import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import {server,app} from './service/socket.js';
import reportRouter from './routes/report.js';
import authRouter from './routes/auth.js';
dotenv.config();
import db from './db.js';



const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.use(reportRouter);
app.use(authRouter);

app.get('/', (req, res) => {
  res.send('Hello from the backend!');
});

server.listen(PORT,'0.0.0.0',()=>{
    console.log(`Server is running on port ${PORT}`);
});
