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

replaceRequirePaths = (line) ->
    myFunction = (match, p1, p2, p3) ->
        p1 + calculateRelativePath(p2) + p3

    return line.replace requirePattern, myFunction

replaceInFile = Promise.coroutine (file) ->
    readLines = []

    mode = fs.statSync(file).mode
    fileReader = yield FileReader.create file

    while fileReader.hasNextLine()
        line = yield fileReader.nextLine()
        line = replaceRequirePaths line
        readLines.push (line + '\n')

    data = readLines.join()
    fs.writeFileSync file, data, {mode}

module.exports = {
    replaceInFile
}