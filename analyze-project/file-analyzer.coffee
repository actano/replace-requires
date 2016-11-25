Promise = require 'bluebird'
fs = Promise.promisifyAll require('fs')
{FileLister, FileReader} = require './../generic-tools/file-lister'
{projectRoot} = require '../config'

createFileLister = ->
    excludedSubfolders = ///
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

    positiveFileFilter = ///
        ^(
#        .+\.jsx         # no requires
#        |
#        .+\.jade        # only correct pattern
#        |
#        .+\.styl        # only correct pattern
#        |
#        .+\.js          # analysis done, see README.md
#        |
        .+\.coffee
        )$
    ///

    negativeFileFilter = undefined

    return new FileLister(projectRoot, excludedSubfolders, positiveFileFilter, negativeFileFilter)

checkIfRegexExistsInFile = Promise.coroutine (file, regex) ->
    fileReader = yield FileReader.create file

    while (fileReader.hasNextLine())
        line = yield fileReader.nextLine()

        if line.match regex
            return true

    return false

findRegexInFiles = Promise.coroutine (regex) ->
    resultSet = new Set()
    fileLister = createFileLister()
    files = yield fileLister.listAllFilesInRootFolder()
    counter = 0

    for file in files
        # console.log file, ++counter
        regexFound = yield checkIfRegexExistsInFile file, regex
        if regexFound
            resultSet.add file

    return resultSet

module.exports = {
    createFileLister
    findRegexInFiles
}
