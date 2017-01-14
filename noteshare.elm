port module Noteshare exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, class, classList, src, name, type_, title, placeholder)
import Html.Events exposing (..)
import Http

import Json.Encode as Encode
import Json.Decode exposing (string, int, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional)

import Task


main : Program Never Document Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : (Document, Cmd Msg)
init =
  ( Document "0" "Introductory Magick" "Don't believe a single word of it!" "Don't believe a <b>single</b> word of it!"
  , Cmd.none
  )

  
-- MODEL

type alias Document =
  { id : String
  , title : String
  , text : String
  , renderedText: String
  }


--UPDATE

type Msg
  = None | SetId String| GetDocument | LoadDocument (Result Http.Error String)
--  = None | SetId String| GetDocument | LoadDocument (Result Http.Error Document)

update : Msg -> Document -> (Document, Cmd Msg)
update msg model =
  case msg of
    None ->
      ( model, Cmd.none )

    SetId id ->
        ({ model | id = id}, Cmd.none  )

    GetDocument ->
      (model, getDocument model.id)

    -- LoadDocument (Ok payload) ->
    --   (payload, Cmd.none)


    LoadDocument (Ok payload) ->
          ({ model | renderedText = payload }, Cmd.none)

    LoadDocument (Err error) ->
      handleError model error



handleError model error =
     ({ model | renderedText = "Error requesting document " ++ model.id}, Cmd.none)

-- VIEW

view : Document -> Html Msg
view model =
  div [Html.Attributes.style [("margin", "40px")]]
    [
     button [ onClick GetDocument ] [text "Get"]
     , input [ type_ "text", Html.Attributes.placeholder "ID", onInput SetId ] []
    --  p [ ] [ text model.error]
    , br [] []
    ,h2 [] [text model.title]
    , br [] []
    , div [ renderedText model ] []
    ]

renderedText : { a | renderedText : String } -> Attribute msg
renderedText model =
    (Html.Attributes.property "innerHTML" (Encode.string model.renderedText))

-- HTTP

-- "http://localhost:2300/v1"
-- "http://xdoc-api.herokuapp.com/v1"

apiServerUrl : String
apiServerUrl = "http://localhost:2300/v1"
-- apiServerUrl = "http://xdoc-api.herokuapp.com/v1"

documentDecoder2 : Decoder Document
documentDecoder2 =
    decode buildDocument
        |> required "id" string
        |> required "title" string
        |> required "text" string
        |> required "rendered_text" string

buildDocument : String -> String -> String -> String -> Document
buildDocument id title text rendered_text =
    Document id title text rendered_text
    -- { id = id, title = title, text = text, rendered_text = rendered_text }


documentDecoder : Decoder String
documentDecoder =
  Json.Decode.at ["document", "rendered_text"] string

getDocument : String -> Cmd Msg
getDocument id =
  let
    url =
      apiServerUrl ++ "/documents/" ++ id ++ "?toc"
  in
    Http.send LoadDocument (Http.get url documentDecoder)


-- SUBSCRIPTIONS

subscriptions : Document -> Sub Msg
subscriptions model =
  Sub.none
