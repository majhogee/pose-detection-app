port module Main exposing (Model, Msg(..), init, main, update, view, subscriptions)
import Browser
import Html exposing (Attribute, Html, button, div, img, h1, h2, input, text)
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Decode
import Json.Encode


port sendStuff : Json.Encode.Value -> Cmd msg

port receiveStuff : (Json.Encode.Value -> msg) -> Sub msg


type alias Model =
    { url : String
    , submitted : Bool
    , counter : Int
    , error : String
    }

type Msg
    =  UrlSubmitted
    |  Change String
    |  SendData
    |  Received (Result Json.Decode.Error Int)


type alias Flags =
    { value : Int
    }

 -- INIT


init : Flags -> ( Model, Cmd msg )
init flags =
       ( { url = "", submitted = False, counter = flags.value, error = "No error"}
         , Cmd.none
       )


 -- UPDATE


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Change newUrl ->
            (  { model | url = newUrl }, Cmd.none )
        UrlSubmitted ->
            ( { model | submitted = True }, Cmd.none )
        SendData ->
            ( model, sendStuff <| Json.Encode.string "test" )
        Received result ->
            case result of
                Ok value ->
                    ( { model | counter = value }, Cmd.none )

                Err error ->
                    ( { model | error = Json.Decode.errorToString error }, Cmd.none )


valueDecoder : Json.Decode.Decoder Int
valueDecoder =
    Json.Decode.field "value" Json.Decode.int


-- VIEW


view : Model -> Html Msg
view model =
    if model.submitted == False then
        div []
            [ input [ placeholder "Type here", onInput Change ] []
            , button [ onClick UrlSubmitted ] [ text "Show image" ]
            , h2 [] [ text <| String.fromInt model.counter ]
            , h2 [] [ text model.error ]
            ]

    else
        div []
            [ img [ id "posenetimg", src model.url, attribute "crossorigin" "anonymous" ] []
            , button [ onClick SendData ] [ text "Send some data" ]
            ]

---- PROGRAM ----


subscriptions : Model -> Sub Msg
subscriptions model =
    receiveStuff (Json.Decode.decodeValue valueDecoder >> Received)


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
