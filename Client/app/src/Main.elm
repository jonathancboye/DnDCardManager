module Main exposing (..)

import Browser
import Element
    exposing
        ( Element
        , centerX
        , centerY
        , column
        , el
        , layout
        , rgb255
        , row
        , text
        )
import Element.Background exposing (color)
import Element.Events exposing (onClick)
import Element.Input as Input exposing (button)
import Html exposing (Html)
import Html.Attributes exposing (src)
import Http
import Json.Decode as Decode exposing (field, int, list, map8, string)



---- MODEL ----


type alias Model =
    { spells : List Spell
    , findSpell : String
    }


type alias Spell =
    { name : String
    , level : Int
    , school : String
    , time : String
    , range : String
    , components : String
    , duration : String
    , classes : String
    }


init : ( Model, Cmd Msg )
init =
    ( { spells = []
      , findSpell = ""
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = GetSpells
    | GotSpells (Result Http.Error (List Spell))
    | FilterSpells String


spellDecoder : Decode.Decoder (List Spell)
spellDecoder =
    field "spells"
        (list
            (map8 Spell
                (field "name" string)
                (field "level" int)
                (field "school" string)
                (field "time" string)
                (field "range" string)
                (field "components" string)
                (field "duration" string)
                (field "classes" string)
            )
        )


getSpells : Cmd Msg
getSpells =
    Http.get
        { url = "https://localhost:5001/api/spells"
        , expect = Http.expectJson GotSpells spellDecoder
        }


updateSearchText : String -> Model -> Model
updateSearchText filter model =
    { model
        | findSpell = filter
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FilterSpells filter ->
            ( updateSearchText filter model
            , Cmd.none
            )

        GetSpells ->
            ( model, getSpells )

        GotSpells (Ok spells) ->
            ( { model | spells = spells }, Cmd.none )

        GotSpells (Err error) ->
            case error of
                Http.BadUrl message ->
                    Debug.log message
                        ( model, Cmd.none )

                Http.Timeout ->
                    Debug.log "timeout"
                        ( model, Cmd.none )

                Http.NetworkError ->
                    Debug.log "networkError"
                        ( model, Cmd.none )

                Http.BadStatus status ->
                    Debug.log ("Bad status" ++ String.fromInt status)
                        ( model, Cmd.none )

                Http.BadBody message ->
                    Debug.log message
                        ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    layout []
        (column
            [ centerX
            , Element.spacing 10
            ]
            (spellsButton
                :: spellsFilter model
                :: spellsView model
            )
        )


spellsFilter : Model -> Element Msg
spellsFilter model =
    if List.length model.spells > 0 then 
     Input.text []
        { label = Input.labelHidden ""
        , onChange = FilterSpells
        , text = model.findSpell
        , placeholder = Just (Input.placeholder [] (Element.text "search"))
        }
    else
        Element.none

spellsButton : Element Msg
spellsButton =
    button
        [ color (rgb255 252 152 3)
        , Element.width (Element.px 200)
        , Element.height (Element.px 50)
        , centerX
        , centerY
        ]
        { onPress = Just GetSpells
        , label = text "Get Spells"
        }


spellsView : Model -> List (Element Msg)
spellsView model =
    model.spells
        |> List.filter
            (\spell ->
                String.contains model.findSpell spell.name
            )
        |> List.map spellView


spellView : Spell -> Element Msg
spellView spell =
    el [ centerX ] (text spell.name)



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
