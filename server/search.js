const express = require('express');
const Product = require('./model'); // Assuming model definition is here
const searchRoute = express.Router();

// Get all products by name
searchRoute.get("/get-item/:name", async (req, res) => {
  try {
    const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" }
    });
    res.json(products);
  } catch (error) {
    console.error(error); // Log the error for debugging
    res.status(500).json({ error: "Internal server error" }); // Generic error message
  }
});

// Endpoint to submit product ratings
searchRoute.post('/api/rate', async (req, res) => {
  const { productId, rating, comment } = req.body; // Extract productId, rating, and comment from request body

  try {
    // Find the product by its ID
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    // Add the rating to the product's ratings array
    product.ratings.push({ rating: rating, comment: comment });

    // Save the updated product
    await product.save();

    // Respond with a success message
    res.status(200).json({ message: 'Rating saved successfully' });
  } catch (error) {
    console.error('Error saving rating:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});
searchRoute.get('/api/get-ratings/:productId', async (req, res) => {
  const productId = req.params.productId;

  try {
    // Find the product by its ID
    const product = await Product.findById(productId);

    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    // Return the ratings of the product
    res.status(200).json(product.ratings);
  } catch (error) {
    console.error('Error fetching ratings:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = searchRoute;
