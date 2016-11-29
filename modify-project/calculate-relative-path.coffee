path = require 'path'
{listNodeModules, listLib, listSchedulemanager} = require './find-require-targets'

# TODO: This is really eval for tests
NODE_MODULES = listNodeModules()
LIB = listLib()
SCHEDULEMANAGER = listSchedulemanager()

getTopLevelFile = (requiredPath) ->
    slashIndex = requiredPath.indexOf '/'
    if slashIndex < 0
        return requiredPath

    return requiredPath.substring 0, slashIndex

countTargets = (topLevelFile) ->
    counter = 0

    if NODE_MODULES.includes topLevelFile
        counter++
    if LIB.includes topLevelFile
        counter++
    if SCHEDULEMANAGER.includes topLevelFile
        counter++

    return counter

indexOfFirstDifference = (directories1, directories2) ->
    for directory, index in directories1
        if directory isnt directories2[index]
            return index

    throw new Error 'Requiring myself, this should never happen'

calculateRelativePathFromAbsolutePaths = (currentFile, requiredPath) ->
    currentFileDirectories = currentFile.split '/'
    requiredDirectories = requiredPath.split '/'

    index = indexOfFirstDifference(currentFileDirectories, requiredDirectories)
    requiredDirectories = requiredDirectories.slice index

    res = currentFileDirectories
        .slice index, currentFileDirectories.length - 1
        .map -> '..'
        .concat requiredDirectories
        .join '/'

    unless res.startsWith '..'
        res = './' + res

    return res

calculateRelativePath = (projectRoot, currentFile, requiredPath) ->
    topLevelFile = getTopLevelFile requiredPath
    numberOfTargets = countTargets(topLevelFile)

    if (numberOfTargets isnt 1)
        throw Error('Ínvalid number of targets (expected 1): ' + numberOfTargets)

    if NODE_MODULES.includes topLevelFile
        return requiredPath

    if LIB.includes topLevelFile
        file = 'lib'

    if SCHEDULEMANAGER.includes topLevelFile
        file = 'lib/schedulemanager'

    absoluteRequiredPath = path.join projectRoot, file, requiredPath

    return calculateRelativePathFromAbsolutePaths currentFile, absoluteRequiredPath

module.exports = {
    getTopLevelFile
    countTargets
    indexOfFirstDifference
    calculateRelativePathFromAbsolutePaths
    calculateRelativePath
}
