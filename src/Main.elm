module Main exposing (Model(..), Msg(..), init, main, subscriptions, update, view)

--import Html exposing (..)
--import Html.Attributes exposing (..)
--import Html.Events exposing (..)

import Browser
import Element exposing (..)
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Input as Input
import Http
import Json.Decode exposing (Decoder, field, index, string)



-- MAIN


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = Failure String
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

                Err err ->
                    case err of
                        Http.BadUrl e ->
                            ( Failure ("Bad URL: " ++ e), Cmd.none )

                        Http.Timeout ->
                            ( Failure ("Timout reaching server: " ++ String.fromFloat e), Cmd.none )

                        Http.NetworkError ->
                            ( Failure ("No internet connection: " ++ String.fromFloat e), Cmd.none )

                        Http.BadStatus e ->
                            ( Failure ("Something went wrong with the request: " ++ String.fromInt e), Cmd.none )

                        Http.BadBody e ->
                            ( Failure ("Bad Body: " ++ e), Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Quote of the day"
    , body =
        [ layout
            []
            (case model of
                Failure err ->
                    text ("Unable to load quote.\n" ++ err)

                Loading ->
                    text "Loading..."

                Success fullText ->
                    column [ centerX, centerY, spacing 4 ]
                        [ Input.button [ centerX, Border.solid, Border.width 1, Border.rounded 8 ] { onPress = Just AgainPlease, label = el [ padding 4 ] (text "Load another please!") }
                        , text fullText
                        ]
            )
        ]
    }



-- HTTP


getQOD : Cmd Msg
getQOD =
    Http.get
        { url = "https://quotes.rest/qod?language=en"
        , expect = Http.expectJson GotQuote quoteDecoder
        }


quoteDecoder : Decoder String
quoteDecoder =
    field "contents" (field "quotes" (index 0 (field "quote" string)))
