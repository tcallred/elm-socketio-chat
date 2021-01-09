const express = require('express')
const app = express()
const http = require('http').createServer(app)
const path = require('path')
const io = require('socket.io')(http)
const port = 3000

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '/client/index.html'))
})

// TODO Make this better
app.get('/elm.js', (req, res) => {
    res.sendFile(path.join(__dirname, '/client/elm.js'))
})

io.on('connection', (socket) => {
    console.log('a user connected')
    socket.on('chat message', (msg) => {
        io.emit('chat message', msg);
    });
})

http.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
})