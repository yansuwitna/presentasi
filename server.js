const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const path = require('path');
const multer = require('multer');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

const PORT = process.env.PORT || 3000;
const PUBLIC_DIR = path.join(__dirname, 'public');
const UPLOADS_DIR = path.join(PUBLIC_DIR, 'uploads');
const PDF_PATH = path.join(UPLOADS_DIR, 'presentation.pdf');
const PDF_PAGES = 400; // Ganti dengan jumlah halaman PDF yang sebenarnya

// Middleware untuk serve static files di public directory
app.use(express.static(PUBLIC_DIR));

// Konfigurasi multer untuk upload file
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, UPLOADS_DIR);
    },
    filename: function (req, file, cb) {
        cb(null, 'presentation.pdf'); // Nama file yang diupload akan disimpan sebagai presentation.pdf
    }
});
const upload = multer({ storage: storage });

// Socket.io connection handling
let slideIndex = 0;
io.on('connection', (socket) => {
    console.log('Client connected');

    // Mengirimkan indeks slide saat ini ke client yang baru terhubung
    socket.emit('slide', slideIndex);

    // Menangani perintah next slide dari client
    socket.on('next', () => {
        if (slideIndex < PDF_PAGES - 1) {
            slideIndex++;
            io.emit('slide', slideIndex);
        }
    });

    // Menangani perintah prev slide dari client
    socket.on('prev', () => {
        if (slideIndex > 0) {
            slideIndex--;
            io.emit('slide', slideIndex);
        }
    });

    // Menangani saat client disconnect
    socket.on('disconnect', () => {
        console.log('Client disconnected');
    });
});

// Route untuk menyajikan file PDF
app.get('/presentation', (req, res) => {
    res.sendFile(PDF_PATH);
});

// Route untuk menyajikan halaman kontrol server
app.get('/guru', (req, res) => {
    res.sendFile(path.join(PUBLIC_DIR, 'guru.html'));
});

// Route untuk menyajikan halaman upload
app.get('/upload', (req, res) => {
    res.sendFile(path.join(PUBLIC_DIR, 'upload.html'));
});

// Route untuk menyajikan halaman presentasi kepada client
app.get('/', (req, res) => {
    res.sendFile(path.join(PUBLIC_DIR, 'index.html'));
});

// Menangani upload file
app.post('/upload', upload.single('fileUpload'), (req, res) => {
    console.log('File uploaded:', req.file);
    // res.send('File uploaded successfully');
    res.redirect('/guru');
});

// Menjalankan server
server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
