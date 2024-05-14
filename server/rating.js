const mongoose = require("mongoose");

const ratingSchema=mongoose.Schema({
//     userId:{
//         type:String,
//         required: true
//     },
     rating:{
        type:Number,
        required:true,
     },
     comment:{
     type: String
     }
});

module.export=ratingSchema;