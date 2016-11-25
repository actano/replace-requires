{findRegexInFiles} = require './analyze-project/file-analyzer'
{findUnwantedRequires} = require './analyze-project/find-invalid-requires'

findUnwantedRequires().then((res)->
    console.log 'Success', res, res.size
).catch((error) ->
    console.error 'Error', error
)
