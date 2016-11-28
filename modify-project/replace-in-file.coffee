Promise = require 'bluebird'
fs = require 'fs'
{FileReader} = require '../generic-tools/file-lister'
{calculateRelativePath} = require './calculate-relative-path'

requirePattern = ///
    (require\s+['"])
    ([A-Za-z0-9_/\-\.]+)
    (['"])
#    |
#    require
#    \(['"]
#    [A-Za-z0-9_/\-\.]+
#    ['"]\)
///g

replaceRequirePaths = (projectRoot, currentFile, line) ->
    myFunction = (match, requireStartPart, requiredPathPart, requireEndPart) ->
        relativePath = calculateRelativePath(projectRoot, currentFile, requiredPathPart)
        return requireStartPart + relativePath + requireEndPart

    return line.replace requirePattern, myFunction

replaceInFile = Promise.coroutine (projectRoot, file) ->
    processedLines = []

    mode = fs.statSync(file).mode
    fileReader = yield FileReader.create file

    while fileReader.hasNextLine()
        line = yield fileReader.nextLine()
        line = replaceRequirePaths projectRoot, file, line
        processedLines.push (line + '\n')

    data = processedLines.join()
    fs.writeFileSync file, data, {mode}

module.exports = {
    replaceInFile
}