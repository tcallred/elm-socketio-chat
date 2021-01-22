const express = require('express')
const app = express()
const http = require('http').createServer(app)
const path = require('path')
const io = require('socket.io')(http)
const port = 3000


app.use(express.static(__dirname + '/public'));


app.get('*', (req, res) => {
    res.sendFile(path.resolve(__dirname, 'public/index.html'))
})


io.on('connection', (socket) => {
    console.log('a user connected')

    socket.on("join room", (roomId) => {
        console.log('user joining room ' + roomId)
        socket.join(roomId)
        socket.on('chat message', (msg) => {
            io.to(roomId).emit('chat message', msg)
        });
    })


})


http.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
})