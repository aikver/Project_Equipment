const Equipment = require('../model/equipment'); // เรียกใช้โมเดล Product

//CRUD
exports.getProducts = async(req,res) =>{
    try{
        const Equipment = await Equipment.find();
        res.status(200).json(Equipment);

    }catch (err){
        res.status(500).json({message: err.message});
    }
};

exports.getProduct = async (req,res) =>{
    try{
        const { id } = req.params;
        const product  = await Equipment.findById(id);
        if (!product) return res.status(404).json({message:"Product not found"});
        res.status(200).json(product);
    }catch (err){
        res.status(500).json({ message: err.message });
    }
};

exports.createProduct = async (req,res) => {
    const {equipment_name, equipment_type, price, unit} = req.body;

    const product = new Equipment({equipment_name, equipment_type, price,unit})
    try{
        const newProduct = await product.save();
        res.status(201).json(newProduct);
    }catch (err){
        res.status(400).json({message: err.message});
    }
};

exports.updateProduct = async (req,res) => {
    try{
        const {id} = req.params;
        const product = await Equipment.findById(id);

        if(!product) return res.status(404).json({message : 'Product not found'});
        const data = {$set : req.body};

        await Equipment.findByIdAndUpdate(id,data);

        res.status(200).json({ message: 'Product updated successfully' });
    }catch (err) { 

        res.status(400).json({ message: err.message }); 

    }
}

exports.deleteProduct = async(req,res) =>{
    try{
        const { id } = req.params;
        const product = await Equipment.findById(id);
        if(!product) return res.status(404).json({message: 'Product not found'});
        await Equipment.findByIdAndDelete(id);
        res.status(200).json({ message: 'Product deleted successfully' });
    }catch(err){
        res.status(500).json({message : err.message});
    }
}
//การยืม
exports.borrowEquipment = async (req, res) => {
    try {
      const { id } = req.params; // Fetch equipmentId from URL params
  
      // Find the equipment by its ID
      const equipment = await Equipment.findById(id);
  
      if (!equipment) {
        return res.status(404).json({ message: 'Equipment not found' });
      }
  
      // Check if the equipment is already borrowed (status: 'unavailable')
      if (equipment.status === 'unavailable') {
        return res.status(400).json({ message: 'This equipment is already borrowed' });
      }
  
      // Update the status to "unavailable"
      equipment.status = 'unavailable';
  
      // Save the updated equipment status to the database
      await equipment.save();
  
      return res.status(200).json({ message: 'Equipment borrowed successfully', equipment });
    } catch (error) {
      return res.status(500).json({ message: 'Error borrowing equipment', error: error.message });
    }
  };