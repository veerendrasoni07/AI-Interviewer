import jwt from 'jsonwebtoken'
import crypto from 'crypto';

export const hashToken = (token)=>{
    return crypto.createHash(
        "sha256",
    ).update(token).digest("hex");
}

export const generateRefreshToken =   (userId)=>{
    return jwt.sign(
        {id:userId},
        process.env.REFRESH_TOKEN_SECRET_KEY,
        {expiresIn:'7d'}
    );
}

export const generateAccessToken = (userId)=>{
    console.log("access token has been generated");
    return jwt.sign(
        {id:userId},
        process.env.ACCESS_TOKEN_SECRET_KEY,
        {expiresIn:'1h'}
    );
}