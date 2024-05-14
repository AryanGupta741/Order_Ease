const express = require('express');
const adminRoute=express.Router();
const mongoose=require('mongoose');
const Product  = require('./model');
const Cart=require('./model/cartModel');
// API Route to Save Product Data
adminRoute.post('/admin/saveItem', async (req, res) => {
  try {
    const { name, description, quantity, price, category, imageurls } = req.body;

    // Create a new product instance
    const newProduct = new Product({ name, description, quantity, price, category, imageurls});

    // Save the new product to the database
    await newProduct.save();

    res.status(201).json({ message: 'Product saved successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error saving product' });
  }
});
// Get all your products
adminRoute.get("/admin/get-products", async (req, res) => {
  try {
    const products = await Product.find({});
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get all your products
adminRoute.get("/admin/get-order", async (req, res) => {
  try {
    const products = await Cart.find({});
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Delete the product
adminRoute.delete('/admin/delete-products/:id', async (req, res) => {
  const foodId = req.params.id;

  try {
    const deletedFood = await Product.findByIdAndDelete(foodId);
    if (!deletedFood) {
      return res.status(404).json({ message: 'Food item not found' });
    }
    res.status(200).json({ message: 'Food item deleted successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

// Delete the product
adminRoute.delete('/admin/delete-ordered-item/:id', async (req, res) => {
  const foodId = req.params.id;

  try {
    const deletedFood = await Cart.findByIdAndDelete(foodId);
    if (!deletedFood) {
      return res.status(404).json({ message: 'Food item not found' });
    }
    res.status(200).json({ message: 'Food item deleted successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});
module.exports = adminRoute;


