module Pages.Room.Id_Int exposing (..)

-- import Html exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D
import Ports exposing (..)
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)


page : Page Params Model Msg
page =
    Page.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Params =
    { id : Int
    }


type alias Model =
    { draft : String
    , messages : List String
    }


init : Url Params -> ( Model, Cmd Msg )
init { params } =
    ( { draft = "", messages = [ "some", "example", "text" ] }
    , sendMessage { kind = "join room", message = String.fromInt params.id }
    )



-- UPDATE


type Msg
    = DraftChanged String
    | Send
    | Recv String



-- Use the `sendMessage` port when someone presses ENTER or clicks
-- the "Send" button. Check out index.html to see the corresponding
-- JS where this is piped into a WebSocket.
--


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DraftChanged draft ->
            ( { model | draft = draft }
            , Cmd.none
            )

        Send ->
            ( { model | draft = "" }
            , sendMessage { kind = "chat message", message = model.draft }
            )

        Recv message ->
            ( { model | messages = model.messages ++ [ message ] }
            , Cmd.none
            )



-- SUBSCRIPTIONS
-- Subscribe to the `messageReceiver` port to hear about messages coming in
-- from JS. Check out the index.html file to see how this is hooked up to a
-- WebSocket.
--


subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver Recv



-- VIEW
-- view : Model -> Document Msg
-- view model =
--     { title = "Chat room"
--     , body =
--         [ html <|
--             div []
--                 [ h1 [] [ text "Echo Chat" ]
--                 , ul []
--                     (List.map (\msg -> li [] [ text msg ]) model.messages)
--                 , input
--                     [ type_ "text"
--                     , placeholder "Draft"
--                     , onInput DraftChanged
--                     , on "keydown" (ifIsEnter Send)
--                     , value model.draft
--                     ]
--                     []
--                 , button [ onClick Send ] [ text "Send" ]
--                 ]
--         ]
--     }


view : Model -> Document Msg
view model =
    { title = "Chat room"
    , body =
        [ el
            [ Element.width fill
            , Element.height fill
            ]
          <|
            column
                [ Element.width fill
                , Element.height fill
                ]
                [ el
                    [ Font.bold
                    , paddingXY 0 5
                    , Font.size 30
                    ]
                    (text "Echo Chat")
                , column
                    [ paddingXY 5 15
                    , spacingXY 0 5
                    , Font.size 18
                    , Element.height fill
                    , Element.width fill
                    , Background.color (rgb 1 1 1)
                    ]
                    (List.map (\msg -> el [ Font.family [ Font.monospace ] ] (text msg)) model.messages)
                , Input.text
                    [ Element.width fill
                    , Element.htmlAttribute <| Html.Events.on "keydown" (ifIsEnter Send)
                    ]
                    { onChange = \draft -> DraftChanged draft
                    , text = model.draft
                    , placeholder = Nothing
                    , label =
                        Input.labelRight
                            [ Border.width 1
                            , Border.color (rgb 0.8 0.8 0.8)
                            , Border.solid
                            , Border.rounded 5
                            , Element.height fill
                            ]
                        <|
                            Input.button
                                [ centerY
                                , padding 5
                                ]
                                { onPress = Just Send, label = text "Send" }
                    }
                ]
        ]
    }



-- DETECT ENTER


ifIsEnter : msg -> D.Decoder msg
ifIsEnter msg =
    D.field "key" D.string
        |> D.andThen
            (\key ->
                if key == "Enter" then
                    D.succeed msg

                else
                    D.fail "some other key"
            )
