// test-server.js
const express = require('express');
const app = express();

app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'success', 
    message: 'Test server is running!',
    port: 5000
  });
});

const PORT = 5000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 TEST Server running on http://localhost:${PORT}`);
  console.log(`🔗 Health check: http://localhost:${PORT}/api/health`);
});