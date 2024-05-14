const express = require('express');
const authRoute = express.Router();
const mongoose = require('mongoose');
const Product = require("./model"); // Assuming productSchema is defined in productModel

// Define Data Schema
const dataSchema = new mongoose.Schema({
  name: String,
  email: String,
  userType: String,
  table: String
});

// Create Data Model
const Data = mongoose.model('Data', dataSchema);

// API Route to Save Data
authRoute.post('/api/sendData', async (req, res) => {
  try {
    const { name, email, userType, table } = req.body;

    // Here, cart should be an array of objects containing product IDs and quantities
    // Example:
    // cart: [{ productId: 'productId1', quantity: 2 }, { productId: 'productId2', quantity: 1 }]

    const newData = new Data({ name, email, userType, table });
    await newData.save();
    res.status(201).json({ message: 'Data saved successfully', newData });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error saving data' });
  }
});

module.exports = authRoute;
