
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
        required:true
    },
    strongAreas:{
        type:[String],
        required:true
    },
    improvements:{
        type:[String],
        required:true
    },
    tips:{
        type:[String],
        required:true
    }
});

const Report = mongoose.model("Report",reportSchema);
export default Report;