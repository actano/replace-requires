{findRegexInFiles} = require './analyze-project/file-analyzer'
{projectRoot} = require './config'

config = {
    projectRoot: projectRoot

    negativeFileFilter: undefined

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
        .+\.jade        # only correct pattern
#        |
#        .+\.styl        # only correct pattern
#        |
#        .+\.js          # analysis done, see README.md
#        |
#        .+\.coffee
        )$
    ///

    requirePattern: ///
       (require\s+['"])
       ([A-Za-z0-9_/\-\.]+)
       (['"])
       |
       require
       \(['"]
       [A-Za-z0-9_/\-\.]+
       ['"]\)
    ///g
}

findRegexInFiles(config).then((res)->
    console.log 'Success', res, res.size
).catch((error) ->
    console.error 'Error', error
)
