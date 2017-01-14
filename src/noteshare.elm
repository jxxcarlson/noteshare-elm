port module Noteshare exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, class, classList, src, name, type_, title, placeholder)
import Html.Events exposing (..)
import Http
import Json.Encode

import AppModel exposing(decodeDocumentPayload, DocumentPayload, Document)

type alias Model =
    {
        currentId: Int
       , query: String
       , document: Document

    }


main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : (Model, Cmd Msg)
init =
  let
    document = Document 76 "Test Document" "asciidoc-latex" False 0 "yerda" False "2017" "2017" "This _is_ a test" "This <i>is</i> a test"
    model = { document = document, query = "", currentId = 76 }
  in
    update GetDocument model


-- MODEL -- see also module Model


type Msg
  = None
  | SetId String
  | GetDocument
  | LoadDocument (Result Http.Error DocumentPayload)



--UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    None ->
      ( model, Cmd.none )

    SetId id ->
        let
            newModel = {model | currentId = Result.withDefault 0 (String.toInt(id))  }
        in
            (newModel, Cmd.none)

    GetDocument ->
       (model, getDocument model.currentId)

    LoadDocument (Ok payload) ->
       let
            doc = payload.document
            newModel = { model | document = payload.document}
       in
            ( newModel, render doc.rendered_text )

    LoadDocument (Err error) ->
       ( model, Cmd.none )
       -- handleError model error



handleError model error =
     ({ model | renderedText = "Error requesting document " ++ model.id}, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  div [] [
    tocView model
    , documentView model.document
  ]

tocView : Model -> Html Msg
tocView model = div [Html.Attributes.style [
    ("position", "absolute"), ("top", "40px"), ("left", "40px"),
    ("margin-left", "5%"), ("width", "25%")
    ]]
  [
  h2 [] [text "Contents" ]
  ]

documentView : Document -> Html Msg
documentView model =
  div [Html.Attributes.style [
    ("position", "absolute"), ("top", "13px"), ("left", "30%"),
    ("width", "70%")
    ]]

    [
     button [ onClick GetDocument ] [text "Get"]
     , input [ type_ "text", Html.Attributes.placeholder "ID", onInput SetId ] []
     , p [] [ text ("ID = " ++  (toString model.id)) ]
    , h2 [] [text model.title]
    , br [] []
    ]

renderedText : { a | renderedText : String } -> Attribute msg
renderedText model =
    (Html.Attributes.property "innerHTML" (Json.Encode.string model.renderedText))
-- "http://xdoc-api.herokuapp.com/v1"


-- DECODERS



-- HTTP

apiServerUrl : String
apiServerUrl = "http://localhost:2300/v1"
-- apiServerUrl = "http://xdoc-api.herokuapp.com/v1"

getDocument : Int -> Cmd Msg
getDocument id =
  let
    url =
      apiServerUrl ++ "/documents/" ++ toString(id) ++ "?toc"
  in
    Http.send LoadDocument (Http.get url decodeDocumentPayload)
    -- Http.send LoadDocument (Http.get url documentDecoder)


-- SUBSCRIPTIONS

port render : String -> Cmd msg

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
