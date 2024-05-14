const express = require('express');
const mongoose = require('mongoose');
const incomeRoute = express.Router();

// Define schema for daily income
const dailyIncomeSchema = new mongoose.Schema({
  date: Date,
  income: Number,
});

// Define model for daily income
const DailyIncome = mongoose.model('DailyIncome', dailyIncomeSchema);

// API endpoint to save daily income
incomeRoute.post('/api/save_daily_income', async (req, res) => {
  const { date, income } = req.body;

  try {
    // Check if a record with the same date exists
    let existingRecord = await DailyIncome.findOne({ date });

    if (existingRecord) {
      // If record exists, update the income by adding the new amount
      existingRecord.income += income;
      await existingRecord.save();
    } else {
      // If record does not exist, create a new record
      await DailyIncome.create({ date, income });
    }

    res.status(200).json({ message: 'Daily income saved successfully' });
  } catch (error) {
    console.error('Error saving daily income:', error);
    res.status(500).json({ error: 'Failed to save daily income' });
  }
});
incomeRoute.get('/api/chartdata', async (req, res) => {
  try {
    const data = await DailyIncome.find();
    res.json(data);
  } catch (error) {
    console.error('Error fetching chart data:', error);
    res.status(500).json({ error: 'Failed to fetch chart data' });
  }
});

module.exports=incomeRoute;
