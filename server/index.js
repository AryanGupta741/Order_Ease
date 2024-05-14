const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const adminRoutes = require('./admin'); // Assuming admin routes are defined here
const authRoutes = require('./auth');
const menuRoutes = require('./menu');
const searchRoutes=require('./search');
const cartRoutes=require('./cart');
const incomeRoutes = require('./income');


const app = express();
const port = 3000;

// Middleware to parse JSON bodies
app.use(bodyParser.json());


// Connect to MongoDB database
mongoose.connect('mongodb+srv://eanshgupta:mongodbanshgupta@cluster0.kndmqxp.mongodb.net/orderease?retryWrites=true&w=majority', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Database connection successful'))
  .catch((error) => {
    console.error('Error connecting to database:', error);
    // You can add more robust error handling logic here (e.g., exit the process)
  });

// Include routes (uncomment if you have admin routes)
app.use(adminRoutes); // Include admin routes if needed
app.use(authRoutes);
app.use(menuRoutes);
app.use(searchRoutes);
app.use(cartRoutes);
app.use(incomeRoutes);

// Error handling middleware (optional)
app.use((err, req, res, next) => {
  // Handle any errors that occur during request processing
  console.error(err.stack);
  res.status(500).json({ error: 'Internal Server Error' });
});

// Start the server
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
