Promise = require 'bluebird'
fs = require 'fs'
{FileReader, createFileLister} = require '../generic-tools/file-lister'
{calculateRelativePath} = require './calculate-relative-path'
{calculateTargetFile} = require './calculate-target-file'

replaceRequirePaths = (config, currentFile, line) ->
    replacementFunction = (match, requireStartPart, requiredPathPart, requireEndPart) ->
        # console.log 'match', match
        # relativePath = calculateRelativePath(config.projectRoot, currentFile, requiredPathPart)
        relativePath = calculateTargetFile(currentFile, requiredPathPart)
        return requireStartPart + relativePath + requireEndPart

    return line.replace config.requirePattern, replacementFunction

replaceInFile = Promise.coroutine (config, file) ->
    #console.log 'file', file
    processedLines = []

    mode = fs.statSync(file).mode
    fileReader = yield FileReader.create file

    while fileReader.hasNextLine()
        line = yield fileReader.nextLine()
        line = replaceRequirePaths config, file, line
        processedLines.push (line + '\n')

    data = processedLines.join('')
    fs.writeFileSync file, data, {mode}

replaceInFiles = Promise.coroutine (config) ->
    fileLister = createFileLister config
    files = yield fileLister.listAllFilesInRootFolder()
    # counter = 0

    for file in files
        # console.log file, ++counter
        yield replaceInFile config, file

module.exports = {
    replaceInFile
    replaceInFiles
}