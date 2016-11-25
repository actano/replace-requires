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


getFileExtension = (file) ->
    index = file.lastIndexOf('.')
    return file.substring index

checkIfRegexExistsInFile = Promise.coroutine (file, regex) ->
    fileReader = yield FileReader.create file

    while (fileReader.hasNextLine())
        line = yield fileReader.nextLine()

        if line.match regex
            return true

    return false

checkIfUnwantedRegexIsInFile = Promise.coroutine (file) ->
    wanted = ///
        (
        require\s+['"]
        [A-Za-z0-9_/\-\.]+
        ['"]
        |
        require
        \(['"]
        [A-Za-z0-9_/\-\.]+
        ['"]\)
#        |
#        window\.require
        |
        require[A-Za-z]
        |
        [A-Za-z]require
        |
        'require'
        )
    ///g

    unwanted = /require/

    fileReader = yield FileReader.create file

    inBlockComment = false

    while (fileReader.hasNextLine())
        line = yield fileReader.nextLine()

        {line, inBlockComment} = filterBlockComments line, inBlockComment

        comment = line.indexOf '#'
        if comment > 0
            line = line.substring 0, comment

        line = line.replace wanted, ''
        if line.match(unwanted)
            return true

    return false

filterBlockComments = (line, inBlockComment) ->
    index = line.indexOf '###'

    if inBlockComment
        if index > 0
            line = line.substring (index+2)
            inBlockComment = false
        else
            line = ''
    else
        if index > 0
            line = line.substring 0, (index+2)
            inBlockComment = true

    return {line, inBlockComment}

findFileExtensionsWithRequires = Promise.coroutine ->
    resultSet = new Set()
    regex = /require/g
    counter = 0

    fileLister = createFileLister()
    files = yield fileLister.listAllFilesInRootFolder()

    for file in files
        # console.log file, ++counter
        regexFound = yield checkIfRegexExistsInFile file, regex
        if regexFound
            resultSet.add getFileExtension(file)

    return resultSet


findUnwantedRequires = Promise.coroutine ->
    resultSet = new Set()
    fileLister = createFileLister()
    files = yield fileLister.listAllFilesInRootFolder()
    counter = 0

    for file in files
        # console.log file, ++counter
        regexFound = yield checkIfUnwantedRegexIsInFile file
        if regexFound
            resultSet.add file

    return resultSet

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
    findFileExtensionsWithRequires
    findUnwantedRequires
    findRegexInFiles
}
