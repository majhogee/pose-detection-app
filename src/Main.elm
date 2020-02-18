port module Main exposing (Model, Msg(..), init, main, update, view, subscriptions)
import Browser
import Html exposing (Attribute, Html, button, div, img, input, text)
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (onClick, onInput)


type alias Model =
    { url : String
    , submitted : Bool
    }
type Msg
    =  UrlSubmitted
     |  Change String


 -- MAIN

main =
    Browser.element { init = init, view = view, update = update, subscriptions = subscriptions }



init : String -> ( Model, Cmd msg )
init flags =
       ( { url = "", submitted = False}
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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


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
