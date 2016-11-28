Promise = require 'bluebird'
chai = require 'chai'
chai.use require 'chai-as-promised'
{expect} = chai

fs = require 'fs'
path = require 'path'
{replaceInFile} = require '../replace-in-file'

describe 'replace-in-files', ->
    testRoot = path.resolve('./test_data')
    testFile = path.join testRoot, 'MyTestFile.txt'

    before ->
        fs.writeFileSync testFile, '{function} = require \'schedulemanager/module/file\'\nsome code\n'


    describe 'replaceInFile', ->
        it.only 'should replace', Promise.coroutine ->
            yield replaceInFile testRoot, testFile
            expect(true).to.be.true
