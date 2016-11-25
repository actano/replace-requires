Promise = require 'bluebird'
fs = Promise.promisifyAll require('fs')
path = require 'path'
{projectRoot} = require '../config'

listDirectories = Promise.coroutine (directory) ->
    directory = path.join projectRoot, directory
    files = yield fs.readdirAsync(directory)
    return files.map (file) -> path.join(directory, file)

listNodeModules = Promise.coroutine ->
    yield listDirectories 'node_modules'

listLib = Promise.coroutine ->
    yield listDirectories 'lib'

listSchedulemanager = Promise.coroutine ->
    yield listDirectories 'lib/schedulemanager'

module.exports = {
    listNodeModules
    listLib
    listSchedulemanager
}
