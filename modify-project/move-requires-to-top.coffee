Promise = require 'bluebird'
{FileReader, createFileLister} = require '../generic-tools/file-lister'
fs = require 'fs'
_ = require 'lodash'


requireRegex = ///
    (
        (
            \{\s*
            ([A-Za-z0-9_/\-\.]+\s*,)*
            [A-Za-z0-9_/\-\.]+
            \s*\}
        |
            [A-Za-z0-9_/\-\.]+
        )
        \s+=\s+
        require \s* \(?
        ['"]
        [A-Za-z0-9_/\-\.]+
        ['"]
        \)?
    )
///

moveRequiresToTop = Promise.coroutine (config) ->
    fileLister = createFileLister config
    files = yield fileLister.listAllFilesInRootFolder()

    for file in files
        yield processSingleFile file

processSingleFile = Promise.coroutine (file) ->
    linesWithRequires = yield findRequires(file)
    console.log 'linesWithRequires\n', linesWithRequires
    variableRegex = getVariablesFromRequires linesWithRequires
    yield moveRequires file, linesWithRequires, variableRegex

findRequires = Promise.coroutine (file) ->
    fileReader = yield FileReader.create file
    lines = []

    while fileReader.hasNextLine()
        line = yield fileReader.nextLine()
        trimmedLine = line.trim()

        if hasRequire(trimmedLine)
            lines.push (trimmedLine + '\n')

    return lines

hasRequire = (line) ->
    line.match requireRegex

getVariablesFromRequires = (linesWithRequires) ->
    variables = []
    for line in linesWithRequires
        if line.includes '{'
            getDestructuredVariables line, variables
        else
            getVariable line, variables

    res =  '(' + _.uniq(variables).join('|') + ')\\s*='
    return res

getDestructuredVariables = (line, resultSet) ->
    res = line.match(/\{\s*(([A-Za-z0-9_/\-.]+\s*,\s*)*[A-Za-z0-9_/\-.]+)\s*}\s*=/)
    if res?
        res[1].replace(' ', '').split('|').forEach (item) ->
            resultSet.push item

getVariable = (line, resultSet) ->
    res = line.match(/([A-Za-z0-9_/\-.]+)\s*=/)
    if res?
        resultSet.push res[1]

moveRequires = Promise.coroutine (file, linesWithRequires, variableRegex) ->
    mode = fs.statSync(file).mode
    fileReader = yield FileReader.create file
    processedLines = linesWithRequires
    processedLines.push '\n' unless fileReader.previewNextLine().trim() is ''

    while fileReader.hasNextLine()
        line = yield fileReader.nextLine()
        if hasRequire line
            continue

        console.log variableRegex
        if line.match variableRegex
            continue

        processedLines.push (line + '\n')

    data = processedLines.join('')
    fs.writeFileSync file, data, {mode}

module.exports = {
    moveRequiresToTop
    processSingleFile
}