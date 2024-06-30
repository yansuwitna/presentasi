const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const path = require('path');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

let slideIndex = 0;
const slidesCount = 10000;  // Update this to the actual number of slides in your PDF

app.use(express.static('public'));

io.on('connection', (socket) => {
    // Send the current slide index to the newly connected client
    socket.emit('slide', slideIndex);

    // Handle next slide
    socket.on('next', () => {
        if (slideIndex < slidesCount - 1) {
            slideIndex++;
            io.emit('slide', slideIndex);
        }
    });

    // Handle previous slide
    socket.on('prev', () => {
        if (slideIndex > 0) {
            slideIndex--;
            io.emit('slide', slideIndex);
        }
    });
});

app.get('/presentation', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'file.pdf'));
});

server.listen(3000, () => {
    console.log('Server is running on port 3000');
});
