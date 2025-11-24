// routes/roomRoutes.js
const express = require('express');
const { 
  getHomeRooms, 
  getAllRooms, 
  getRoomById 
} = require('../controllers/roomController');

const router = express.Router();

router.get('/home', getHomeRooms); // API mới cho home
router.get('/', getAllRooms);
router.get('/:id', getRoomById);

module.exports = router;