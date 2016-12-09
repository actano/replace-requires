/**
 * Created by christianbunse on 14/11/2016.
 */

import Promise from 'bluebird'
import _fs from 'fs'
import path from 'path'
import Queue from '../queue'

const fs = Promise.promisifyAll(_fs)

const RPLAN_ROOT = '/Users/christianbunse/Projects/rplan'

class FileLister {
  constructor(rootFolder, filterFunction) {
    this.queue = new Queue()
    this.resultArray = []
    this.rootFolder = rootFolder
    this.filterFunction = filterFunction
  }

  async listAllFilesInRootFolder() {
    this.queue.enqueue(this.rootFolder)
    while (!this.queue.isEmpty()) {
      const file = this.queue.dequeue()
      const isDirectory = (await fs.statAsync(file)).isDirectory()

      if (isDirectory) {
        await this.addChildrenToQueue(file)
      } else {
        this.resultArray.push(file)
      }
    }

    return this.resultArray
  }

  async addChildrenToQueue(directory) {
    let files = await fs.readdirAsync(directory)

    const numberOfFiles = files.length

    files = files.filter(file =>
      file !== '.' && file !== '..'
    )

    if (numberOfFiles > files.length) {
      console.log('Custom filter was applied!')
    }

    files = files.map(file =>
      path.join(directory, file)
    )

    files = this.filterFunction(files)
    this.queue.enqueueMulti(files)
  }

  static makeRelativeTo(directory, absolutePath) {
    if (!absolutePath.startsWith(directory)) {
      throw new Error(`Corrupt path: Does not start with ${directory}`)
    }
    return absolutePath.substring(directory.length)
  }

  makeRelativeToRoot(absolutePath) {
    return this.makeRelativeTo(this.rootFolder, absolutePath)
  }
}

function doFilter(array) {
  array.filter(file =>
    file !== ''
  )
}
const fileLister = new FileLister(RPLAN_ROOT, doFilter)

fileLister.listAllFilesInRootFolder().then(
  () => console.log('done'),
).catch(
  error => console.error(error)
)

