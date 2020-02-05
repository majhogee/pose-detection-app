module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Attribute, Html, button, div, img, input, text)
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (onClick, onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { url : String
    , submitted : Bool
    }


init : Model
init =
    { url = ""
    , submitted = False
    }



-- UPDATE


type Msg
    = UrlSubmitted
    | Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newUrl ->
            { model | url = newUrl }

        UrlSubmitted ->
            { model | submitted = True }



-- urlSubmitted ->
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
            [ img [ id "posenetimg", src model.url ] []
            ]
