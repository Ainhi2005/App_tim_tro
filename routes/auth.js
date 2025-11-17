// routes/auth.js
const express = require('express');
const router = express.Router();

// Test route đơn giản
router.post('/register', (req, res) => {
  console.log('Register body:', req.body);
  res.json({
    status: 'success',
    message: 'Register endpoint working!',
    data: req.body
  });
});

router.post('/login', (req, res) => {
  res.json({
    status: 'success', 
    message: 'Login endpoint working!'
  });
});

module.exports = router;