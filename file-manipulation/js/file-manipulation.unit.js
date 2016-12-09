/**
 * Created by christianbunse on 23/11/2016.
 */
/* eslint-disable no-unused-expressions */

import chai, { expect } from 'chai'
import chaiAsPromised from 'chai-as-promised'
import Promise from 'bluebird'
import fs from 'fs'
import path from 'path'
import execSync from 'exec'

chai.use(chaiAsPromised)

describe('file-manipulation', () => {
  const testRoot = '/Users/christianbunse/Projects/rplan/tools/file-manipulation/test/test_folder'

  beforeEach('Create test folder', () => {
    const subfolder1 = path.join(testRoot, 'subfolder_1')
    const subfolder2 = path.join(testRoot, 'subfolder_2')

    fs.mkdirSync(testRoot)
    fs.writeFileSync(path.join(testRoot, 'file_1'), 'Content')
    fs.writeFileSync(path.join(testRoot, 'file_2'), 'Content')

    fs.mkdirSync(subfolder1)
    fs.writeFileSync(path.join(subfolder1, 'file_1'), 'Content')
    fs.writeFileSync(path.join(subfolder1, 'file_2'), 'Content')

    fs.mkdirSync(subfolder2)
    fs.writeFileSync(path.join(subfolder2, 'file_1'), 'Content')
    fs.writeFileSync(path.join(subfolder2, 'file_2'), 'Content')
  })

  afterEach('Remove test folder', () => {
    execSync(`rm -r ${testRoot}`)
  })

  it('should list all files in folder', async () => {
    signupService.signup.resolves(getUser())

    const user = await getCreateUserPromise()
    for (const k of ['getId', 'getCleartextPassword', 'getRootPlanningObjectId']) {
      expect(user).to.respondTo(k)
    }
  })

  it('should return and resolve a promise with auth-data for user', async () => {
    signupService.signup.resolves(getUser())

    const user = await getCreateUserPromise()

    for (const k of ['getId', 'getCleartextPassword', 'getRootPlanningObjectId']) {
      expect(user).to.respondTo(k)
    }
  })

  it('should handle an error if signup() fails', () => {
    signupService.signup.rejects(new Error('test error'))

    expect(getCreateUserPromise()).to.be.rejected
  })

  it('should not delete user if no user was created', async () => {
    try {
      await loginProvider.cleanup()
    } finally {
      expect(userService.deleteUser).not.to.have.been.called
      expect(userHome.deleteUserHome).not.to.have.been.called
    }
  })

  it('should return and resolve a promise in cleanup()', async () => {
    const user = getUser()
    signupService.signup.resolves(user)
    userService.getUserById.resolves(user)
    userService.deleteUser.resolves()
    userHome.deleteUserHome.resolves()

    await getCreateUserPromise()

    try {
      await loginProvider.cleanup()
    } catch (error) {
      expect(error.stack)
        .to.not.exist
    } finally {
      expect(userHome.deleteUserHome).to.have.been.called
      expect(userService.deleteUser).to.have.been.called
    }
  })

  it('should return and resolve a mpromise in cleanup() for multiple users', async () => {
    const user = getUser()
    signupService.signup.resolves(user)
    userService.getUserById.resolves(user)
    userService.deleteUser.resolves()
    userHome.deleteUserHome.resolves()

    await Promise.all([
      getCreateUserPromise('1_'),
      getCreateUserPromise('2_'),
    ])

    try {
      await loginProvider.cleanup()
    } finally {
      expect(userService.deleteUser).to.have.been.calledTwice
      expect(userHome.deleteUserHome).to.have.been.calledTwice
    }
  })

  it('should find a user', async () => {
    const user = getUser()
    userService.findUserByEmail.resolves(user)

    const foundUser = await loginProvider.findUser(getUserId())
    expect(foundUser).to.equal(user)
  })
})
