import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import reportRouter from './routes/report.js';
dotenv.config();
import db from './db.js';



const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.use(reportRouter);


app.get('/', (req, res) => {
  res.send('Hello from the backend!');
});

app.listen(PORT,'0.0.0.0',()=>{
    console.log(`Server is running on port ${PORT}`);
});