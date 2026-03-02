import mongoose from "mongoose";

mongoose.connect("mongodb+srv://veerendrasoni0555_db_user:BxP0Dwy8YEzULcSy@cluster0.dtdh4cg.mongodb.net/?appName=Cluster0");

const db = mongoose.connection;

db.on("error", console.error.bind(console, "MongoDB connection error:"));
db.once("connected", function () {
  console.log("Connected to MongoDB successfully!");
});
db.once("disconnected", function () {
  console.log("Disconnected from MongoDB.");
});

export default db;