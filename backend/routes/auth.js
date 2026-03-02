import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import User from '../models/user.js';

const authRouter = express.Router();
authRouter.post('/api/sign-up',async(req,res)=>{
    try {
        const {fullname,email,password} = req.body;
        console.log(req.body,"hehehehe");
        
        if(!fullname || !email || !password){
            return res.status(400).json({msg:"Name or Email Or Password is missing!"});
        }
        const isUserExist = await User.findOne({email});
        if(isUserExist){
            return res.status(400).json({msg:"User already exist with this email"});
        }
        const hashedPassword = await bcrypt.hash(password,10);
        let newUser = new User(
            {
                fullname,
                email,
                password:hashedPassword
            }
        );
        newUser = await newUser.save();
        const token = jwt.sign({id:newUser._id},"superSecretKey");
        console.log("sign up successfully");
        // TODO : REMOVE PASSWORD FROM THE USER OBJECT
        res.status(200).json({user:newUser,token});

    } catch (error) {
        console.log(error);
        res.json({error:"Internal Server Error"});
    }
});

authRouter.post('/api/sign-in',async(req,res)=>{
    try {
        console.log("Sign in api request");
        const {email,password} = req.body;
        if(!email || !password){
            return res.status(400).json({msg:"email or password is missing"});
        }
        const user = await User.findOne({email});
        if(!user){
            return res.status(400).json({msg:"User with this email didn't exist"});
        }
        const verified = await bcrypt.compare(password,user.password);
        if(!verified){
            return res.status(401).json({msg:"Password is invalid"});
        }
        const token = jwt.sign({id:user._id},"superSecretKey");
        res.status(200).json({user:user._doc,token});

    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"})
    }
});

export default authRouter;