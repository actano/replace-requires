{findUnwantedRequires, findRegexInFiles} = require './analyze-project/file-analyzer'

findUnwantedRequires().then((res)->
    console.log 'Success', res, res.size
).catch((error) ->
    console.error 'Error', error
)
