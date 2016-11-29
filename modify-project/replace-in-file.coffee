Promise = require 'bluebird'
fs = require 'fs'
{FileReader} = require '../generic-tools/file-lister'
{calculateRelativePath} = require './calculate-relative-path'

replaceRequirePaths = (config, currentFile, line) ->
    myFunction = (match, requireStartPart, requiredPathPart, requireEndPart) ->
        relativePath = calculateRelativePath(config.projectRoot, currentFile, requiredPathPart)
        return requireStartPart + relativePath + requireEndPart

    return line.replace config.requirePattern, myFunction

replaceInFile = Promise.coroutine (config, file) ->
    processedLines = []

    mode = fs.statSync(file).mode
    fileReader = yield FileReader.create file

    while fileReader.hasNextLine()
        line = yield fileReader.nextLine()
        line = replaceRequirePaths config, file, line
        processedLines.push (line + '\n')

    data = processedLines.join()
    fs.writeFileSync file, data, {mode}

module.exports = {
    replaceInFile
}