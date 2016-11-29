Promise = require 'bluebird'
{createFileLister, FileReader} = require './../generic-tools/file-lister'

checkIfRegexExistsInFile = Promise.coroutine (file, regex) ->
    fileReader = yield FileReader.create file

    result = false

    while (fileReader.hasNextLine())
        line = yield fileReader.nextLine()

        if line.match regex
            result = true

    return result

findRegexInFiles = Promise.coroutine (config) ->
    resultSet = new Set()
    fileLister = createFileLister(config)
    files = yield fileLister.listAllFilesInRootFolder()
    counter = 0

    for file in files
        # console.log file, ++counter
        regexFound = yield checkIfRegexExistsInFile file, config.requirePattern
        if regexFound
            resultSet.add file

    return resultSet

module.exports = {
    findRegexInFiles
}
