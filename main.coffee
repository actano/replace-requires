{findRegexInFiles} = require './analyze-project/file-analyzer'
{findUnwantedRequires} = require './analyze-project/find-invalid-requires'
{listNodeModules, listLib, listSchedulemanager} = require './modify-project/find-require-targets'

listSchedulemanager().then((res)->
    console.log 'Success', res, res.length
).catch((error) ->
    console.error 'Error', error
)
