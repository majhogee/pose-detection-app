port module Main exposing (Model, Msg(..), init, main, update, view, subscriptions)
import Browser
import Html exposing (Attribute, Html, button, div, img, canvas, h1, h2, input, text)
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Decode
import Json.Encode


port sendStuff : Json.Encode.Value -> Cmd msg

port receiveStuff : (List Keypoint -> msg) -> Sub msg

-- {score: 0.7709414958953857, part: "nose", position: {…}}

type alias Model =
    { url : String
    , submitted : Bool
    , keypoints: List Keypoint
    }

type alias Keypoint =
    {score: Float
    , part: String
    , position: Position
    }

type alias Position =
    { x : Float
    , y : Float
    }

type Msg
    =  UrlSubmitted
    |  Change String
    |  SendData
    |  Received (List Keypoint)

type alias Asia = Msg


type alias Flags =
    { value : Int
    }

 -- INIT


init : Flags -> ( Model, Cmd msg )
init flags =
       ( { url = "", submitted = False, keypoints = []}
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
        Received keypoints ->
            ( { model | keypoints = keypoints }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    if model.submitted == False then
        div []
            [ input [ placeholder "Type here", onInput Change ] []
            , button [ onClick UrlSubmitted ] [ text "Show image" ]
            ]

    else
        div []
            [  div [] [
                img [ id "posenetimg", src model.url, attribute "crossorigin" "anonymous" ] []
                , canvas [ id "canvas" ] []
            ]
            , button [ onClick SendData ] [ text "Send some data" ]
            ]

---- PROGRAM ----


subscriptions : Model -> Sub Msg
subscriptions model =
    receiveStuff Received


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
