Promise = require 'bluebird'
chai = require 'chai'
chai.use require 'chai-as-promised'
{expect} = chai

fs = require 'fs'
path = require 'path'
{replaceInFile} = require '../replace-in-file'

describe 'replace-in-files', ->
    testRoot = path.resolve('./test_data')

    describe 'replaceInFile', ->
        it.only 'should replace', Promise.coroutine ->
            testFile = path.join testRoot, 'MyTestFile.txt'
            yield replaceInFile testFile
            expect(true).to.be.true
