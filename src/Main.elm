module Main exposing (Model(..), Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = Failure
    | Loading
    | Success String


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , getQOD
    )



-- UPDATE


type Msg
    = GotQuote (Result Http.Error String)
    | AgainPlease


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AgainPlease ->
            ( Loading, getQOD )

        GotQuote result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Failure ->
            text "Unable to load quote"

        Loading ->
            text "Loading..."

        Success fullText ->
            div []
                [ button [ onClick AgainPlease, style "display" "block" ] [ text "Load another please!" ]
                , text fullText
                ]



-- HTTP


getQOD : Cmd Msg
getQOD =
    Http.get
        { url = "https://quotes.rest/qod?language=en"
        , expect = Http.expectJson GotQuote quoteDecoder
        }


quoteDecoder : Decoder String
quoteDecoder =
    field "contents" (field "quote" string)
