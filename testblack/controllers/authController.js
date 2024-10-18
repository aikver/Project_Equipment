const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../model/user");

// Register
exports.register = async (req, res) => {
    const { user_name,firstname,lastname, password, phone, role } = req.body;


    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = new User({ user_name,firstname,lastname, password: hashedPassword ,phone,role });
        await user.save();
        res.status(201).send("User registered ");
    } catch (err) {
        res.status(500).send(err.message);
    }
};

// Login
exports.login = async (req, res) => {
    const { user_name, password } = req.body;
    try {
        console.log(user_name, password);
        // res.json({user_name,password});
        
        const user = await User.findOne({ user_name });
        if(!user) return res.status(400).send("User not found.");
        // res.json(user);
        // if (!user) return res.status(400).send("User not found");
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) return res.status(400).send("Invalid credentials");

        const accessToken = jwt.sign(
            { userId: user._id },
            process.env.ACCESS_TOKEN_SECRET,
            { expiresIn: "1h" }
        );
        
        const refreshToken = jwt.sign(
            { userId: user._id },
            process.env.REFRESH_TOKEN_SECRET // ชื่อของตัวแปรต้องตรงกับในไฟล์ .env
        );

        
        res.json({ user, accessToken, refreshToken });
    } catch (err) {
        res.status(500).send(err.message);
    }
};


// Refresh
exports.refresh = async (req, res) => {
    const { token } = req.body;
    if (!token) return res.sendStatus(401);
    jwt.verify(token, process.env.REFRESH_TOKEN_SECRET, (err, user) => {
        if (err) return res.sendStatus(403);
        const accessToken = jwt.sign(
            { userId: user.userId },
            process.env.ACCESS_TOKEN_SECRET,
            { expiresIn: "1h" }
        );
        res.json({ accessToken });
    });
};