{findRegexInFiles} = require './analyze-project/file-analyzer'
{replaceInFiles} = require './modify-project/replace-in-file'
{projectRoot} = require './config'

config = {
    projectRoot: projectRoot

    excludedSubfolders: ///
        ^(
        /node_modules
        |
        /build
        |
        /karma\-[0-9]+
        |
        /test_reports
        |
        /agreements
        |
        /best_practices
        |
        /etc
        |
        /docs
        |
        /export
        |
        .*/\..*            # All folders that start with a dot (.)
        )$
    ///

    positiveFileFilter: ///
        ^(
#        .+\.jsx         # no requires
#        |
#        .+\.jade        # only correct pattern: mixins make stuff difficult
#        |
#        .+\.styl        # only correct pattern: No absolute requires
#        |
#        .+\.js          # analysis done, see README.md, only one change: lib/styleguide/Readme.js
#        |
        .+\.coffee
        )$
    ///

    negativeFileFilter: ///
        ^(
        /lib/testutils/views/test\.jade
        |
        /tools/config\.js                   # OK, nothing to do
        )$
    ///

    requirePattern: ///
       (require\s+')
       ([A-Za-z0-9_/\-][A-Za-z0-9_/\-\.]+)
       (')
#       |
#       (require\(')
#       ([A-Za-z0-9_/\-][A-Za-z0-9_/\-\.]*)
#       ('\))
    ///g
}



findRegexInFiles(config).then((res)->
    console.log 'Success', res, res.size
).catch((error) ->
    console.error 'Error', error
)

return

replaceInFiles(config).then(->
    console.log 'Success'
).catch((error) ->
    console.error 'Error', error
)

