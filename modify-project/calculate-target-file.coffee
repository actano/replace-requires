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
    if (children.includes 'index.jsx')
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
#        if currentFile.indexOf('alien/api-actions.coffee') > 0
#            newPath = path.join requirePath, 'client'
#
#            unless newPath.startsWith '.'
#                return './' + newPath
#
#            return newPath

        ignoredPaths = [
            '/rxf/'
            '/planning-objects/',
            '/server.coffee',
            '/planning-object-persistence/',
            '/forgot-password/rest-api/',
            '/rest-endpoints/',
            '.rest-api.coffee',
            '.unit.coffee',
            'user-service/index.coffee',
            'payments/server/notification-auth-middleware.coffee',
            '/lib/migration/',
            '/webapp/webapp.coffee',
            '/memcached-session/index.coffee',
            'middleware/requestEnrichments.coffee',
            'payments/tools/configNotification.coffee',
            'orphaned-trashed-documents/cli/main.coffee',
            'usermanagement/test/helper.coffee',
            'cypher/cypher.coffee'
        ]

        unless findStringInPath(currentFile, ignoredPaths)
            console.error 'client and index:', currentFile.substring('/Users/christianbunse/Projects/rplan/lib/'.length), ', ', directory
        return requirePath

findStringInPath = (_path, _strings) ->
    for _string in _strings
        if _path.indexOf(_string) > 0
            return true

    return false

handleFile = (currentFile, requirePath) ->
    if requirePath.endsWith 'index.js'
        return requirePath.substring 0, (requirePath.length - '/index.js'.length)
    if requirePath.endsWith 'index.coffee'
        return requirePath.substring 0, (requirePath.length - '/index.coffee'.length)
    if requirePath.endsWith 'index.jsx'
        return requirePath.substring 0, (requirePath.length - '/index.jsx'.length)
    if requirePath.endsWith '.js'
        return requirePath.substring 0, (requirePath.length - '.js'.length)
    if requirePath.endsWith '.coffee'
        return requirePath.substring 0, (requirePath.length - '.coffee'.length)
    if requirePath.endsWith '.jsx'
        return requirePath.substring 0, (requirePath.length - '.jsx'.length)
    else
        return requirePath

handleNonExistingFile = (currentFile, target, requirePath) ->
    if fs.existsSync(target + '.js')
        return requirePath
    if fs.existsSync(target + '.coffee')
        return requirePath
    if fs.existsSync(target + '.jsx')
        return requirePath
#    if fs.existsSync(target + '.jade')
#        return requirePath + '.jade'
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
