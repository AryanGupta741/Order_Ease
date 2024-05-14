const mongoose = require('mongoose');

// Define product schema
const cartSchema = new mongoose.Schema({
  name: { type: String, required: true },
  quantity: { type: Number, required: true },
  category: { type: String, required: true },
  imageurls: [
    {
      type: String,
      required: true,
    },
  ],

});

// Create Product model (with error handling)
try {
  const Cart = mongoose.model("Cart", cartSchema);
  module.exports = Cart;
} catch (error) {
  console.error('Error creating Product model:', error);
}
