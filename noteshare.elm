import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Json.Encode as Encode exposing (string)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, optional, hardcoded)

import Task



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

update : Msg -> Document -> (Document, Cmd Msg)
update msg model =
  case msg of
    None ->
      ( model, Cmd.none )

    SetId id ->
        ({ model | id = id}, Cmd.none  )

    GetDocument ->
      (model, getDocument model.id)

    LoadDocument (Ok payload) ->
      ({ model | renderedText = payload }, Cmd.none)

    LoadDocument (Err _) ->
      ({ model | renderedText = "Error for document " ++ model.id }, Cmd.none)


-- VIEW

view : Document -> Html Msg
view model =
  div [Html.Attributes.style [("margin", "40px")]]
    [
     button [ onClick GetDocument ] [text "Get"]
     , input [ type_ "text", placeholder "ID", onInput SetId ] []
    --  p [ ] [ text model.error]
    , br [] []
    ,h2 [] [text model.title]
    , br [] []
    , div [ (Html.Attributes.property "innerHTML" (Encode.string model.renderedText)) ] []
    ]


-- HTTP

-- "http://localhost:2300/v1/documents/" ++ id ++ "?toc"
-- "http://xdoc-api.herokuapp.com/v1/documents/" ++ id ++ "?toc"

apiServer = "http://xdoc-api.herokuapp.com/v1/documents/"

getDocument : String -> Cmd Msg
getDocument id =
  let
    url =
      apiServer ++ id ++ "?toc"
  in
    Http.send LoadDocument (Http.get url decodeDocument)

decodeDocument : Decode.Decoder String
decodeDocument =
  Decode.at ["document", "rendered_text"] Decode.string


-- SUBSCRIPTIONS

subscriptions : Document -> Sub Msg
subscriptions model =
  Sub.none
