
import mongoose from "mongoose";

const reportSchema = new mongoose.Schema({
    techStack:{
        type:String,
        required:true
    },
    accuracy:{
        type:Number,
        required:true
    },
    weakAreas:{
        type:[String],
       
    },
    fluency:{
        type:String,
    },
    strongAreas:{
        type:[String],
       
    },
    communication:{
        type:String,
        
    },
    improvements:{
        type:[String],
        
    },
    tips:{
        type:[String],
        required:true
    }
});

const Report = mongoose.model("Report",reportSchema);
export default Report;