const mongoose = require('mongoose');

const EquipmentSchema = new mongoose.Schema({
    equipment_name: { type: String, required: true },
    equipment_type: { type: String, required: true },
    price: { type: Number, required: true },
    unit: { type: String, required: true },
    status: { 
        type: String, 
        required: true, 
        enum: ['available', 'unavailable'], // Only allow 'available' or 'unavailable'
        default: 'available' // Default to 'available'
    }
}, { timestamps: true, versionKey: false });

const Equipment = mongoose.model('Equipment', EquipmentSchema);

module.exports = Equipment;