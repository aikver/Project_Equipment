const express = require('express'); 
const mongoose = require('mongoose'); 
const cors = require('cors'); // เพิ่มการใช้งาน CORS
const app = express();

const dotenv = require('dotenv');
const EquipmentRoutes = require('./routes/equipment');
const authRoutes = require('./routes/auth');  

app.use(express.json());
require('dotenv').config(); // เพิ่มเพื่อให้สามารถใช้ตัวแปรจากไฟล์ .env ได้
console.log("Access Token Secret:", process.env.ACCESS_TOKEN_SECRET);
console.log("Refresh Token Secret:", process.env.REFRESH_TOKEN_SECRET);
// 
// ใช้ CORS (คุณสามารถปรับการตั้งค่าให้อนุญาตเฉพาะโดเมนที่คุณต้องการได้)
app.use(cors({
  origin: process.env.CORS_ORIGIN || '*', // ใช้ค่าจาก .env หรือทุกที่ (สำหรับการพัฒนา)
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true, // หากคุณต้องการรองรับ cookies หรือข้อมูลการพิสูจน์ตัวตน
}));

// ConnectDB
mongoose.connect(process.env.MongoDB_URL, {})
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

// Define Route
app.use("/api/equipment", EquipmentRoutes);
app.use("/api/auth", authRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));