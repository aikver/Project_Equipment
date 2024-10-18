const express = require('express'); 

const { getProducts, getProduct, createProduct, updateProduct, deleteProduct,borrowEquipment} = require('../controllers/equipmentController');

const authenticateToken = require("../middlewares/auth");

const router = express.Router();

router.get('/',authenticateToken, getProducts);
router.get('/:id',authenticateToken,getProduct);
router.post('/',authenticateToken,createProduct);
router.put('/:id',authenticateToken, updateProduct);
router.delete('/:id',authenticateToken, deleteProduct);


router.put('/borrow/:id',authenticateToken, borrowEquipment);


module.exports = router;