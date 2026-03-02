import { Server } from 'socket.io';
import express from 'express';
import http from 'http';

const app = express();
const server = http.createServer(app);

const io = new Server(server,{
    cors:{
        origin:"*",
        methods:["POST","GET"]
    }
});

io.on('connection',(socket)=>{

    socket.on("join",async (userId)=>{
        socket.join(userId);
    });

});

export {io,server,app};

