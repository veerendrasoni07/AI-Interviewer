import express from 'express';
import { spawn } from 'node:child_process';
import auth from '../middleware/auth.js'
import crypto from 'crypto';
import { io } from '../service/socket.js';
import Report from '../models/report.js';
import Conversation from '../models/conversation.js';

const reportRouter = express.Router();





reportRouter.post('/api/generate-report',async(req,res)=>{
    try {
        const {message} = req.body;
        const conversation = message.transcript;
        const userId = message.assistant.variableValues.userId;
        console.log(conversation);
        if (!conversation) {
            return res.status(400).json({ error: "Conversation is required" });
        }
        io.to(userId).emit('generating',{msg:true});
        const pythonProcess = spawn("py",["./main.py"]);
        pythonProcess.stdin.write(JSON.stringify({ conversation }));
        pythonProcess.stdin.end();
        let reportData = '';
        pythonProcess.stdout.on('data',(data)=>{
            reportData += data.toString();
        });
        let errorData = '';
        pythonProcess.stderr.on('data', (data) => {
            errorData += data.toString();
        });
        pythonProcess.on('close',async ()=>{
            if (errorData) {
                console.log(errorData);
            }
            const parsedReport = JSON.parse(reportData);
            const savedReport = await Report.create({
                userId:userId,
                techStack: parsedReport.techStack,
                accuracy: parsedReport.accuracy,
                communication:parsedReport.communication,
                fluency:parsedReport.fluency,
                weakAreas: parsedReport.weakAreas,
                strongAreas: parsedReport.strongAreas,
                improvements: parsedReport.improvements,
                tips: parsedReport.tips
            });
            io.to(userId.toString()).emit("report", {
                report: savedReport,
            });
            console.log(savedReport);
            res.status(200).json({msg: "Report generated successfully"});
        });

    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
});

reportRouter.get('/api/get-reports',auth,async(req,res)=>{
    try {
        const userId = req.user.id;
        const reports = await Report.find({userId:userId});
        res.status(200).json({reports:reports});
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
})



export default reportRouter;
