// Initial data passed to Elm (should match `Flags` defined in `Shared.elm`)
// https://guide.elm-lang.org/interop/flags.html
var flags = null

// Start our Elm application
var app = Elm.Main.init({ node: document.getElementById('app'), flags: flags })

// Ports go here
// https://guide.elm-lang.org/interop/ports.html

// Create your WebSocket.
var socket = io(); 

// When a command goes to the `sendMessage` port, we pass the message
// along to the WebSocket.
app.ports.sendMessage.subscribe(function(msg) {
    socket.emit(msg.kind, msg.message);
});

// When a message comes into our WebSocket, we pass the message along
// to the `messageReceiver` port.
socket.on('chat message', function(message) {
	app.ports.messageReceiver.send(message);
});
