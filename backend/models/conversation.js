import mongoose  from "mongoose";

const conversationSchema = new mongoose.Schema({
    userId:{
        type:mongoose.Types.ObjectId,
        ref:'user'
    },
    conversationId:{
        type:String,
    },
    conversation:{
        type:String,
        required:true
    }
});

const Conversation = mongoose.model('Conversation',conversationSchema);

export default Conversation;