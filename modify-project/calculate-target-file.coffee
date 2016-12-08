fs = require 'fs'
path = require 'path'

handleDirectory = (currentFile, directory, requirePath) ->
    children = fs.readdirSync(directory)
    found = 0
    newPath = requirePath

    if (children.includes 'index.js')
        found++
    if (children.includes 'index.coffee')
        found++
    if (children.includes 'client.js')
        found++
        newPath = path.join newPath, 'client'
    if (children.includes 'client.coffee')
        found++
        newPath = path.join newPath, 'client'

    if found is 0
        console.error 'File:', currentFile, ', Unresolvable folder found: ', directory
        return requirePath

    if found is 1
        unless newPath.startsWith '.'
            return './' + newPath

        return newPath

    if found > 1
        console.error 'File:', currentFile, ', client and index file found: ', directory
        return requirePath

handleFile = (currentFile, requirePath) ->
    if requirePath.endsWith 'index.js'
        return requirePath.substring 0, (requirePath.length - '/index.js'.length)
    if requirePath.endsWith 'index.coffee'
        return requirePath.substring 0, (requirePath.length - '/index.coffee'.length)
    if requirePath.endsWith '.js'
        return requirePath.substring 0, (requirePath.length - '.js'.length)
    if requirePath.endsWith '.coffee'
        return requirePath.substring 0, (requirePath.length - '.coffee'.length)
    else
        return requirePath

handleNonExistingFile = (currentFile, target, requirePath) ->
    if fs.existsSync(target + '.js')
        return requirePath
    if fs.existsSync(target + '.coffee')
        return requirePath
    else
        console.error 'File:', currentFile, ', Unresolvable file found: ', target
        return requirePath

calculateTargetFile = (currentFile, requirePath) ->
    # case absolute require
    unless requirePath.startsWith '.'
        # target = path.join projectRoot, requiredPath
        return requirePath

    # case relative require
    target = path.normalize path.join(currentFile, '..', requirePath)

    if fs.existsSync target
        fileStatus = fs.statSync(target)
        if fileStatus.isDirectory()
            handleDirectory(currentFile, target, requirePath)
        else
            handleFile(currentFile, requirePath)
    else
        handleNonExistingFile(currentFile, target, requirePath)

module.exports = {
    calculateTargetFile
}
