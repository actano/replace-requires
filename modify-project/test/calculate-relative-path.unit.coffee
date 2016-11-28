Promise = require 'bluebird'
chai = require 'chai'
chai.use require 'chai-as-promised'
{expect} = chai

fs = Promise.promisifyAll require('fs')
path = require 'path'

{getTopLevelFile, countTargets, indexOfFirstDifference, calculateRelativePathFromAbsolutePaths, calculateRelativePath} = require '../calculate-relative-path'

describe 'calculate-relative-path', ->
    testRoot = path.resolve('./test_data')

    describe 'getTopLevelFile', ->
        it 'should return the top level directory of a path', ->
            path = 'toplevel/level2/level3/level4'
            expect(getTopLevelFile(path)).equal 'toplevel'

        it 'should return the top level directory of a path without any slashes', ->
            path = 'toplevel'
            expect(getTopLevelFile(path)).equal 'toplevel'

    describe 'countTargets', ->
        it 'should return 1 for schedulemanager', ->
            expect(countTargets('schedulemanager')).to.equal 1

    describe 'indexOfFirstDifference', ->
        it 'should return the index of the first difference of two arrays', ->
            array1 = ['a', 'b', 'c', 'd', 'e']
            array2 = ['a', 'b', 'c', 'differs', 'e']
            expect(indexOfFirstDifference(array1, array2)).to.equal 3

    describe 'calculateRelativePathFromAbsolutePaths', ->
        it 'should calculate the relative path from two absolute paths', ->
            currentFile = '/Users/me/myProject/lib/module/subfolder/file.coffee'
            requiredPath = '/Users/me/myProject/lib/anotherModule/file'
            expect(calculateRelativePathFromAbsolutePaths(currentFile, requiredPath)).to.equal '../../anotherModule/file'

    describe 'calculateRelativePath', ->
        it 'should calculate the path to write back', ->
            projectRoot = '/Users/me/myProject'
            currentFile = '/Users/me/myProject/lib/module/subfolder/file.coffee'
            requiredPath = 'schedulemanager/subfolder/file'
            expect(calculateRelativePath(projectRoot, currentFile, requiredPath)).to.equal '../../schedulemanager/subfolder/file'
