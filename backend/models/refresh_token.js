

import mongoose  from "mongoose";


const refreshTokenSchema = new mongoose.Schema({
    userId:{
        type:mongoose.Types.ObjectId,
        required:true,
        ref:'User'
    },
    revoked:{
        type:Boolean,
        default:false
    },
    replacedByToken:{
        type:String,
        default:null
    },
    refreshToken : {
        type:String,
        required:true,
        unique:true
    },
    expiresAt:{
        type:Date,
        required:true
    }
});


export default mongoose.model('RefreshToken',refreshTokenSchema);