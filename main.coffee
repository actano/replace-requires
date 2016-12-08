{FileLister} = require './generic-tools/file-lister'
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
#        .+\.jade        # completely done
#        |
#        .+\.styl        # completely done
#        |
#        .+\.js          # analysis done, see README.md, only one change: lib/styleguide/Readme.js
#        |
        .+\.coffee
        )$
    ///

    negativeFileFilter: ///
        ^(
        /tools/config\.js                   # OK, nothing to do
        )$
    ///

    requirePattern: ///
#       (include\s)
#       ([A-Za-z0-9_/\-][A-Za-z0-9_/\-\.]*)
#       ([a-z])
       (require\s*\(?['"])
       ([A-Za-z0-9_/\-\.]+)
       (['"]\)?)
#       |
#       (require\(')
#       (\.[A-Za-z0-9_/\-\.]+)
#       ('\))
    ///g
}


#new FileLister(config.projectRoot, config.excludedSubfolders).listAllFilesInRootFolder().then((res)->
#    console.log 'Success', res, res.length
#).catch((error) ->
#    console.error 'Error', error
#)
#
#return
#
#findRegexInFiles(config).then((res)->
#    console.log 'Success', res, res.size
#).catch((error) ->
#    console.error 'Error', error
#)
#
#return

replaceInFiles(config).then(->
    console.log 'Success'
).catch((error) ->
    console.error 'Error', error
)

