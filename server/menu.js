const express = require('express');
const Product  = require('./model'); // Assuming model definition is here
const menuRoute = express.Router();

// Get all products by category
menuRoute.get("/menu/get-item/", async (req, res) => {
  try {
    const { category } = req.query; // Access category from query string
    const products = await Product.find({ category });
    res.json(products);
  } catch (error) {
    console.error(error); // Log the error for debugging
    res.status(500).json({ error: "Internal server error" }); // Generic error message
  }
});

module.exports = menuRoute;
