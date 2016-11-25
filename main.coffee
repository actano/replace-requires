{findUnwantedRequires} = require './analyze-project/file-analyzer'

findUnwantedRequires().then((res)->
    console.log 'Success', res
).catch((error) ->
    console.error 'Error', error
)
