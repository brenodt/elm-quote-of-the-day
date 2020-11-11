module Main exposing (Model(..), Msg(..), init, main, subscriptions, update, view)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Http
import Json.Decode exposing (Decoder, field, index, map3, string)



-- MAIN


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Quote =
    { quote : String
    , author : String
    , image : String
    }


type Model
    = Failure String
    | Loading
    | Success Quote


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , getQOD
    )



-- UPDATE


type Msg
    = GotQuote (Result Http.Error Quote)
    | AgainPlease


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AgainPlease ->
            ( Loading, getQOD )

        GotQuote result ->
            case result of
                Ok quote ->
                    ( Success quote, Cmd.none )

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

                Success quote ->
                    el
                        [ height fill
                        , width fill
                        , behindContent
                            (image
                                [ centerX, centerY, height fill, width fill ]
                                { src = quote.image
                                , description = ""
                                }
                            )
                        ]
                        (column
                            [ spacing 4
                            , Background.color (rgba 1 1 1 0.65)
                            , Border.rounded 12
                            , padding 4
                            , centerX
                            , centerY
                            ]
                            [ renderTitle
                            , renderQuote quote.quote
                            , renderAuthor quote.author
                            ]
                        )
            )
        ]
    }


renderTitle : Element msg
renderTitle =
    el
        [ centerX
        , padding 12
        , Font.underline
        , Font.size 32
        , Font.family
            [ Font.external
                { name = "Merriweather"
                , url = "https://fonts.googleapis.com/css2?family=Merriweather:wght@700&display=swap"
                }
            ]
        ]
        (text "Today's quote:")


renderQuote : String -> Element msg
renderQuote q =
    el
        [ padding 4
        , Font.size 26
        , Font.family
            [ Font.external { name = "Libre Franklin", url = "https://fonts.googleapis.com/css2?family=Libre+Franklin&display=swap" } ]
        ]
        (text q)


renderAuthor : String -> Element msg
renderAuthor a =
    el
        [ alignRight
        , Font.italic
        , Font.family
            [ Font.external { name = "Libre Franklin Italic", url = "https://fonts.googleapis.com/css2?family=Libre+Franklin:ital@1&display=swap" } ]
        ]
        (text ("-  " ++ a))



-- HTTP


getQOD : Cmd Msg
getQOD =
    Http.get
        { url = "https://quotes.rest/qod?language=en"
        , expect = Http.expectJson GotQuote quoteDecoder
        }


quoteDecoder : Decoder Quote
quoteDecoder =
    map3 Quote
        (field "contents" (field "quotes" (index 0 (field "quote" string))))
        (field "contents" (field "quotes" (index 0 (field "author" string))))
        (field "contents" (field "quotes" (index 0 (field "background" string))))
