import jsonwebtoken from 'jsonwebtoken';
import User from '../models/user.js';

const auth = async (req,res,next)=>{
    try {
        const token = req.header('x-auth-token');
        if(!token) return res.status(401).json({msg:"Authorization Failed"});
        const verified = jsonwebtoken.verify(token,process.env.ACCESS_TOKEN_SECRET_KEY);
        if(!verified) return res.status(401).json({msg:"TOken verification failed"});
        const user = await User.findById(verified.id);
        if(!user) return res.status(401).json({msg:"User with this token id doesn't exist"});
        req.user = user;
        req.token = token;
        next();
    } catch (error) {
        if (error.name === "TokenExpiredError") {
      return res.status(401).json({ msg: "Access token expired" });
    }

    if (error.name === "JsonWebTokenError") {
      return res.status(401).json({ msg: "Invalid token" });
    }

    console.error(error);
    return res.status(500).json({ msg: "Internal Server Error" });
  
    }
}

export default auth;