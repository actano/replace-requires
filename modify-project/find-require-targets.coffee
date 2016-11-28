fs = require('fs')
path = require 'path'
{projectRoot} = require '../config'

listDirectories = (directory) ->
    directory = path.join projectRoot, directory
    return fs.readdirSync(directory)

listNodeModules = ->
    listDirectories 'node_modules'

listLib = ->
    listDirectories 'lib'

listSchedulemanager = ->
    listDirectories 'lib/schedulemanager'

module.exports = {
    listNodeModules
    listLib
    listSchedulemanager
}
