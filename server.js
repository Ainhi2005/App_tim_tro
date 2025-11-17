// server.js
console.log('🚀 Starting TroFinder Server...');

const app = require('./app');
require('dotenv').config();

const PORT = process.env.PORT || 5000;

// Khởi động server
app.listen(PORT, '0.0.0.0', () => {
    console.log('\n' + '='.repeat(50));
    console.log('🎉 TROFINDER SERVER IS RUNNING!');
    console.log('='.repeat(50));
    console.log(`📍 Server URL: http://localhost:${PORT}`);
    console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log(`❤️  Health Check: http://localhost:${PORT}/health`);
    console.log(`🔧 Test API: http://localhost:${PORT}/api/test`);
    console.log('='.repeat(50));
    console.log('📋 Available Endpoints:');
    console.log('  GET  /health              - Health check');
    console.log('  GET  /api/test            - Test API');
    console.log('  POST /api/auth/register   - Đăng ký tài khoản');
    console.log('  POST /api/auth/login      - Đăng nhập');
    console.log('='.repeat(50));
    console.log('💡 Use Postman to test POST endpoints');
    console.log('='.repeat(50));
});