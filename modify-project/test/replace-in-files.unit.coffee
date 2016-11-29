Promise = require 'bluebird'
chai = require 'chai'
chai.use require 'chai-as-promised'
{expect} = chai

fs = require 'fs'
path = require 'path'
{replaceInFile} = require '../replace-in-file'

describe 'replace-in-files', ->
    testRoot = path.resolve('./test_data')
    testFile = path.join testRoot, 'my-test-file.txt'

    before ->
        fs.writeFileSync testFile, '{function} = require \'schedulemanager/module/file\'\nsome code\nsome more code\n'

    describe 'replaceInFile', ->
        it 'should replace', Promise.coroutine ->
            requirePattern = ///
                (require\s['])
                ([A-Za-z0-9_/\-][A-Za-z0-9_/\-\.]*)
                (['])
            ///g
            yield replaceInFile {projectRoot: testRoot, requirePattern: requirePattern}, testFile
            expect(true).to.be.true
