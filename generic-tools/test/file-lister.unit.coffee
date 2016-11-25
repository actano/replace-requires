Promise = require 'bluebird'
chai = require 'chai'
chai.use require 'chai-as-promised'
{expect} = chai

fs = Promise.promisifyAll require('fs')
path = require 'path'

{FileLister} = require '../file-lister'

describe 'file-manipulation', ->
    testRoot = path.resolve('./test_data')

    describe 'FileLister', ->
        before 'Create test folder', ->
            unless fs.existsSync testRoot
                subfolder1 = path.join(testRoot, 'subfolder_1')
                subfolder2 = path.join(testRoot, 'subfolder_2')

                fs.mkdirSync(testRoot)
                fs.writeFileSync(path.join(testRoot, 'file_1'), 'Content')
                fs.writeFileSync(path.join(testRoot, 'file_2'), 'Content')

                fs.mkdirSync(subfolder1)
                fs.writeFileSync(path.join(subfolder1, 'file_1'), 'Content')
                fs.writeFileSync(path.join(subfolder1, 'file_2'), 'Content')

                fs.mkdirSync(subfolder2)
                fs.writeFileSync(path.join(subfolder2, 'file_1'), 'Content')
                fs.writeFileSync(path.join(subfolder2, 'file_2'), 'Content')

        describe 'list all files', ->
            it 'should list 6 files', Promise.coroutine ->
                fileLister = new FileLister(testRoot)
                resultArray = yield fileLister.listAllFilesInRootFolder()

                expect(resultArray).to.have.lengthOf 6

        describe 'reject folders by folder pattern', ->
            it 'should list 4 files for folder pattern */subfolder_1', Promise.coroutine ->
                fileLister = new FileLister(testRoot, /subfolder_1/)
                resultArray = yield fileLister.listAllFilesInRootFolder()

                expect(resultArray).to.have.lengthOf 4

        describe 'filter files by file pattern', ->
            it 'should list 3 files for filter pattern */file_1', Promise.coroutine ->
                fileLister = new FileLister(testRoot, undefined, /.+file_1/)

                resultArray = yield fileLister.listAllFilesInRootFolder()
                expect(resultArray).to.have.lengthOf 3

    describe 'test regex', ->
        it 'should find matches', ->
            regex = /test/g
            input = 'this is a test to test my tests'

            res = input.match regex
            console.log 'res', res
            expect(res ).to.have.lengthOf 3

        it 'should replace matches', ->
            regex = /test/g
            input = 'this is a test to test my tests'

            input = input.replace regex, 'TEST'
            console.log 'res', input
            expect(input).to.equal 'this is a TEST to TEST my TESTs'
