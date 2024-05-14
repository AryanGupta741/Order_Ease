const mongoose = require('mongoose');
const ratingSchema=require('./rating');

// Define product schema
const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String, required: true, trim: true },
  quantity: { type: Number, required: true },
  price: { type: Number, required: true },
  category: { type: String, required: true },
  imageurls: [
    {
      type: String,
      required: true,
    },
  ],
  ratings: [ratingSchema]

});

// Create Product model (with error handling)
try {
  const Product = mongoose.model("Product", productSchema);
  module.exports = Product;
} catch (error) {
  console.error('Error creating Product model:', error);
}
