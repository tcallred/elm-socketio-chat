port module Ports exposing (SocketIoMessage, messageReceiver, sendMessage)


type alias SocketIoMessage =
    { kind : String
    , message : String
    }


port sendMessage : SocketIoMessage -> Cmd msg


port messageReceiver : (String -> msg) -> Sub msg
