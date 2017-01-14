port module Noteshare exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, class, classList, src, name, type_, title, placeholder)
import Html.Events exposing (..)
import Http

import Json.Encode
-- import Json.Encode as Encode
import Json.Decode exposing (string, int, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional)




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
  ( Document 76 "Introductory Magick" "asciidoc-latex" False 39 "jc" False "2017" "2017" "Don't believe a single word of it!" "Don't believe a <b>single</b> word of it!"
  , Cmd.none
  )

  
-- MODEL


type alias Document =
    { id : Int
    , title : String
    , kind : String
    , has_subdocuments : Bool
    , owner_id : Int
    , author : String
    , public : Bool
    , created_at : String
    , updated_at : String
    , text : String
    , rendered_text : String
    }


type Msg
  = None
  | SetId String
  | GetDocument
  | LoadDocument (Result Http.Error DocumentPayload)



--UPDATE

update : Msg -> Document -> (Document, Cmd Msg)
update msg model =
  case msg of
    None ->
      ( model, Cmd.none )

    SetId id ->
        ({model | id = Result.withDefault 0 (String.toInt(id))}, Cmd.none)

    GetDocument ->
       (model, getDocument model.id)

    LoadDocument (Ok payload) ->
       -- ( model, Cmd.none )
       let doc = payload.document

       in ( doc, render doc.rendered_text)

    LoadDocument (Err error) ->
       ( model, Cmd.none )
       -- handleError model error



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
   -- , div [ renderedText model ] []
    ]

renderedText : { a | renderedText : String } -> Attribute msg
renderedText model =
    (Html.Attributes.property "innerHTML" (Json.Encode.string model.renderedText))
-- "http://xdoc-api.herokuapp.com/v1"


-- DECODERS


type alias DocumentPayload =
    { status : String
    , document : Document
    }


decodeDocumentPayload : Json.Decode.Decoder DocumentPayload
decodeDocumentPayload =
    Json.Decode.Pipeline.decode DocumentPayload
        |> Json.Decode.Pipeline.required "status" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "document" (decodeDocument)

decodeDocument : Json.Decode.Decoder Document
decodeDocument =
    Json.Decode.Pipeline.decode Document
        |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "title" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "kind" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "has_subdocuments" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "owner_id" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "author" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "public" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "created_at" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "updated_at" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "text" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "rendered_text" (Json.Decode.string)

encodeDocumentPayload : DocumentPayload -> Json.Encode.Value
encodeDocumentPayload record =
    Json.Encode.object
        [ ("status",  Json.Encode.string <| record.status)
        , ("document",  encodeDocument <| record.document)
        ]

encodeDocument : Document -> Json.Encode.Value
encodeDocument record =
    Json.Encode.object
        [ ("id",  Json.Encode.int <| record.id)
        , ("title",  Json.Encode.string <| record.title)
        , ("kind",  Json.Encode.string <| record.kind)
        , ("has_subdocuments",  Json.Encode.bool <| record.has_subdocuments)
        , ("owner_id",  Json.Encode.int <| record.owner_id)
        , ("author",  Json.Encode.string <| record.author)
        , ("public",  Json.Encode.bool <| record.public)
        , ("created_at",  Json.Encode.string <| record.created_at)
        , ("updated_at",  Json.Encode.string <| record.updated_at)
        , ("text",  Json.Encode.string <| record.text)
        , ("rendered_text",  Json.Encode.string <| record.rendered_text)
        ]


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

subscriptions : Document -> Sub Msg
subscriptions model =
  Sub.none
