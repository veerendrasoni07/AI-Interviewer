import express from 'express';
import { spawn } from 'node:child_process';
import Report from '../models/report.js';


const reportRouter = express.Router();

reportRouter.post('/api/generate-and-save-report',async(req,res)=>{
    try {
        console.log(req.body);
        const {conversation} = req.body;
        const pythonProcess = spawn('py',['./main.py']);
        pythonProcess.stdin.write(JSON.stringify({conversation}));
        pythonProcess.stdin.end();
        let reportData = '';
        pythonProcess.stdout.on('data',(data)=>{
            reportData +=data.toString();
        })
        pythonProcess.on('close',async ()=>{
            console.log("report generated successfully");
            console.log(reportData);
            const parsedReport = JSON.parse(reportData);

            await Report.create({
                techStack: parsedReport.tech_stack,
                accuracy: parsedReport.accuracy,
                weakAreas: parsedReport.weak_areas,
                strongAreas: parsedReport.strong_areas,
                improvements: parsedReport.improvements,
                tips: parsedReport.tips
            });
            res.json({report:reportData});
        });
        
    }
    catch (error) {
        console.log(error);
        res.json({error:"Internal Server Error"});
    }
});
export default reportRouter;