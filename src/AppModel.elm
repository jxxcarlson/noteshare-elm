module AppModel exposing(decodeDocumentPayload, DocumentPayload, Document)

import Json.Encode
import Json.Decode exposing (string, int, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional)



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


-- DOCUMENT

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
