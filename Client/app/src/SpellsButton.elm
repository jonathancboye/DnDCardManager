module SpellsButton exposing (..)

import Animator
import Browser
import Element exposing (Element, centerX, centerY, el, rgb255, text)
import Element.Background exposing (color)
import Element.Events exposing (onMouseEnter, onMouseLeave)
import Element.Input exposing (button)
import Html exposing (Html)
import Time exposing (Posix)


type alias Model =
    { loading : Animator.Timeline Bool
    , hovering : Animator.Timeline Bool
    , label : String
    }


type Msg
    = Tick Posix
    | Hovering Bool
    | DoSomething


spellsButton : Model -> Element Msg
spellsButton model =
    let
        width =
            round <|
                Animator.linear model.hovering <|
                    \state ->
                        if state then
                            Animator.at 200

                        else
                            Animator.at 50
    in
    button
        [ color (rgb255 252 152 3)
        , Element.width (Element.px width)
        , Element.height (Element.px 50)
        , centerX
        , centerY
        , onMouseEnter (Hovering True)
        , onMouseLeave (Hovering False)
        ]
        { onPress = Just DoSomething
        , label = el [ centerX ] (text model.label)
        }


animator : Animator.Animator Model
animator =
    Animator.animator
        |> Animator.watching
            .hovering
            (\newHovering model ->
                { model | hovering = newHovering }
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Animator.toSubscription Tick model animator


init : () -> (Model, Cmd Msg)
init _ =
    ( { loading = Animator.init False
      , hovering = Animator.init False
      , label = "Get Text"
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( Animator.update newTime animator model
            , Cmd.none
            )

        Hovering isHovering ->
            ( { model
                | hovering =
                    model.hovering
                        |> Animator.go Animator.slowly isHovering
              }
            , Cmd.none
            )

        DoSomething ->
            Debug.log "Doing something"
                ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Element.layout [] (spellsButton model)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
