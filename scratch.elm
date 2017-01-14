import Json.Encode
import Json.Decode
-- elm-package install -- yes noredink/elm-decode-pipeline
import Json.Decode.Pipeline

type alias QueryResponse =
    { status : String
    , document_count : Int
    , documents : List ComplexType
    , first_document : QueryResponseFirst_document
    }

type alias QueryResponseFirst_documentLinksParent =
    { id : Int
    , url : String
    , title : String
    , author : String
    , public : Bool
    , owner_id : Int
    , identifier : String
    }

type alias QueryResponseFirst_documentLinks =
    { images : String
    , parent : QueryResponseFirst_documentLinksParent
    }

type alias QueryResponseFirst_documentDictBackup =
    { date : String
    , number : Int
    }

type alias QueryResponseFirst_documentDict =
    { backup : QueryResponseFirst_documentDictBackup
    }

type alias QueryResponseFirst_document =
    { id : Int
    , identifier : String
    , title : String
    , kind : String
    , has_subdocuments : Bool
    , url : String
    , owner_id : Int
    , author : String
    , public : Bool
    , created_at : String
    , updated_at : String
    , text : String
    , rendered_text : String
    , links : QueryResponseFirst_documentLinks
    , dict : QueryResponseFirst_documentDict
    , tags : String
    }

decodeQueryResponse : Json.Decode.Decoder QueryResponse
decodeQueryResponse =
    Json.Decode.Pipeline.decode QueryResponse
        |> Json.Decode.Pipeline.required "status" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "document_count" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "documents" (Json.Decode.list decodeComplexType)
        |> Json.Decode.Pipeline.required "first_document" (decodeQueryResponseFirst_document)

decodeQueryResponseFirst_documentLinksParent : Json.Decode.Decoder QueryResponseFirst_documentLinksParent
decodeQueryResponseFirst_documentLinksParent =
    Json.Decode.Pipeline.decode QueryResponseFirst_documentLinksParent
        |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "url" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "title" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "author" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "public" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "owner_id" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "identifier" (Json.Decode.string)

decodeQueryResponseFirst_documentLinks : Json.Decode.Decoder QueryResponseFirst_documentLinks
decodeQueryResponseFirst_documentLinks =
    Json.Decode.Pipeline.decode QueryResponseFirst_documentLinks
        |> Json.Decode.Pipeline.required "images" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "parent" (decodeQueryResponseFirst_documentLinksParent)

decodeQueryResponseFirst_documentDictBackup : Json.Decode.Decoder QueryResponseFirst_documentDictBackup
decodeQueryResponseFirst_documentDictBackup =
    Json.Decode.Pipeline.decode QueryResponseFirst_documentDictBackup
        |> Json.Decode.Pipeline.required "date" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "number" (Json.Decode.int)

decodeQueryResponseFirst_documentDict : Json.Decode.Decoder QueryResponseFirst_documentDict
decodeQueryResponseFirst_documentDict =
    Json.Decode.Pipeline.decode QueryResponseFirst_documentDict
        |> Json.Decode.Pipeline.required "backup" (decodeQueryResponseFirst_documentDictBackup)

decodeQueryResponseFirst_document : Json.Decode.Decoder QueryResponseFirst_document
decodeQueryResponseFirst_document =
    Json.Decode.Pipeline.decode QueryResponseFirst_document
        |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "identifier" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "title" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "kind" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "has_subdocuments" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "url" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "owner_id" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "author" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "public" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "created_at" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "updated_at" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "text" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "rendered_text" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "links" (decodeQueryResponseFirst_documentLinks)
        |> Json.Decode.Pipeline.required "dict" (decodeQueryResponseFirst_documentDict)
        |> Json.Decode.Pipeline.required "tags" (Json.Decode.string)

encodeQueryResponse : QueryResponse -> Json.Encode.Value
encodeQueryResponse record =
    Json.Encode.object
        [ ("status",  Json.Encode.string <| record.status)
        , ("document_count",  Json.Encode.int <| record.document_count)
        , ("documents",  Json.Encode.list <| List.map encodeComplexType <| record.documents)
        , ("first_document",  encodeQueryResponseFirst_document <| record.first_document)
        ]

encodeQueryResponseFirst_documentLinksParent : QueryResponseFirst_documentLinksParent -> Json.Encode.Value
encodeQueryResponseFirst_documentLinksParent record =
    Json.Encode.object
        [ ("id",  Json.Encode.int <| record.id)
        , ("url",  Json.Encode.string <| record.url)
        , ("title",  Json.Encode.string <| record.title)
        , ("author",  Json.Encode.string <| record.author)
        , ("public",  Json.Encode.bool <| record.public)
        , ("owner_id",  Json.Encode.int <| record.owner_id)
        , ("identifier",  Json.Encode.string <| record.identifier)
        ]

encodeQueryResponseFirst_documentLinks : QueryResponseFirst_documentLinks -> Json.Encode.Value
encodeQueryResponseFirst_documentLinks record =
    Json.Encode.object
        [ ("images",  Json.Encode.string <| record.images)
        , ("parent",  encodeQueryResponseFirst_documentLinksParent <| record.parent)
        ]

encodeQueryResponseFirst_documentDictBackup : QueryResponseFirst_documentDictBackup -> Json.Encode.Value
encodeQueryResponseFirst_documentDictBackup record =
    Json.Encode.object
        [ ("date",  Json.Encode.string <| record.date)
        , ("number",  Json.Encode.int <| record.number)
        ]

encodeQueryResponseFirst_documentDict : QueryResponseFirst_documentDict -> Json.Encode.Value
encodeQueryResponseFirst_documentDict record =
    Json.Encode.object
        [ ("backup",  encodeQueryResponseFirst_documentDictBackup <| record.backup)
        ]

encodeQueryResponseFirst_document : QueryResponseFirst_document -> Json.Encode.Value
encodeQueryResponseFirst_document record =
    Json.Encode.object
        [ ("id",  Json.Encode.int <| record.id)
        , ("identifier",  Json.Encode.string <| record.identifier)
        , ("title",  Json.Encode.string <| record.title)
        , ("kind",  Json.Encode.string <| record.kind)
        , ("has_subdocuments",  Json.Encode.bool <| record.has_subdocuments)
        , ("url",  Json.Encode.string <| record.url)
        , ("owner_id",  Json.Encode.int <| record.owner_id)
        , ("author",  Json.Encode.string <| record.author)
        , ("public",  Json.Encode.bool <| record.public)
        , ("created_at",  Json.Encode.string <| record.created_at)
        , ("updated_at",  Json.Encode.string <| record.updated_at)
        , ("text",  Json.Encode.string <| record.text)
        , ("rendered_text",  Json.Encode.string <| record.rendered_text)
        , ("links",  encodeQueryResponseFirst_documentLinks <| record.links)
        , ("dict",  encodeQueryResponseFirst_documentDict <| record.dict)
        , ("tags",  Json.Encode.string <| record.tags)
        ]
