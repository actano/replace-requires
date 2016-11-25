Promise = require 'bluebird'
fs = Promise.promisifyAll require('fs')
path = require 'path'

LineReader = require('line-by-line-promise')
{Queue} = require './queue'

class FileLister
    constructor: (@rootFolder, @excludePathRegex = /[]]/, @positiveFileFilter = /.+/, @negativeFileFilter = /[]]/) ->
        @queue = new Queue()
        @resultArray = []
#        @counter = 50

    listAllFilesInRootFolder: Promise.coroutine ->
        @queue.enqueue(@rootFolder)

        until @queue.isEmpty()
#            if @counter-- < 1
#                break

            file = @queue.dequeue()
            fileStatus = yield fs.statAsync(file)

            if fileStatus.isDirectory()
                yield @addDirectoryToQueue file
            else
                 @addFileToResult file

        return @resultArray

    addDirectoryToQueue: Promise.coroutine (directory) ->
        pathRelativeToRoot = @makeRelativeToRoot(directory)

        if @excludePathRegex.test pathRelativeToRoot
            console.log 'Rejected:', directory
        else
            yield @addChildrenToQueue directory

    addFileToResult: (file) ->
        fileRelativeToRoot = @makeRelativeToRoot(file)

        if @positiveFileFilter.test(fileRelativeToRoot) and not @negativeFileFilter.test(fileRelativeToRoot)
            @resultArray.push(file)

    addChildrenToQueue: Promise.coroutine (directory) ->
        files = yield fs.readdirAsync(directory)
        files = files.map (file) -> path.join(directory, file)

        @queue.enqueueMulti(files)

    makeRelativeToRoot: (absolutePath) ->
        return @makeRelativeTo(@rootFolder, absolutePath)

    makeRelativeTo: (directory, absolutePath) ->
        unless absolutePath.startsWith(directory)
            throw new Error("Corrupt path: Does not start with #{directory}")

        return absolutePath.substring(directory.length)

class FileReader
    constructor: (file) ->
        @lineReader = new LineReader file, {
                encoding: 'utf8'
                autoClose: true
            }

    initialize: Promise.coroutine ->
        @_nextLine = yield @lineReader.readLine()

    hasNextLine: ->
        return @_nextLine?

    nextLine: Promise.coroutine () ->
        nextLine = @_nextLine
        @_nextLine = yield @lineReader.readLine()

        return nextLine

    @create: Promise.coroutine (file) ->
        fileReader = new FileReader(file)
        yield fileReader.initialize()
        return fileReader

module.exports = {
    FileLister
    FileReader
}
