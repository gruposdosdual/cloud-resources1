const express = require('express');
const mongoose = require('mongoose');

const app = express();
const PORT = 3000;

// Conexión a MongoDB
mongoose
  .connect('mongodb://database:27017/mydatabase', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log('Conectado a MongoDB'))
  .catch((err) => console.error('Error al conectar a MongoDB:', err));

// Ruta principal
app.get('/', (req, res) => {
  res.send('¡Hola desde el backend!');
});

// Servidor escuchando
app.listen(PORT, () => {
  console.log(`Backend ejecutándose en el puerto ${PORT}`);
});


/*

const express = require('express');
const mongoose = require('mongoose');
const app = express();
const PORT = 5000;
// Conexión a MongoDB 
mongoose.connect('mongodb://database:27017/myapp', { useNewUrlParser: true, useUnifiedTopology: true, }); 
// Ruta base 
app.get('/', (req, res) => { res.send('API en funcionamiento 🚀'); }); 
app.listen(PORT, () => { console.log(`Servidor corriendo en el puerto ${PORT}`); });
*/