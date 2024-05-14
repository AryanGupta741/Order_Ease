const express = require('express');
const mongoose = require('mongoose');
const  Cart  = require('./model/cartModel'); // Assuming you have a User model defined in your auth module

const cartRoute = express.Router();

cartRoute.post('/api/add-to-cart', async (req, res) => {
  try {
    const { name, quantity, category, imageurls } = req.body;

    // Create a new product instance
    const newProduct = new Cart({ name, quantity, category, imageurls});

    // Save the new product to the database
    await newProduct.save();

    res.status(201).json({ message: 'Product saved successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error saving product' });
  }
});
module.exports = cartRoute;
