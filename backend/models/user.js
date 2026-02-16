
import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  fullname: {
    type: String, 
    required: true,
    trim: true
  },
  email: {
    type: String, 
    required: true, 
    unique: true,
    validate:{
        validator:(value)=>{
            const regex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
            return value.match(regex);
        },
        message:"Please enter a valid email address"
    }
  },
  password: {
    type: String,
    required: true,
  },
  phone:{
    type:Number 
  },

},{timestamps:true});

const User = mongoose.model("User", userSchema);
export default User;