# TODO list

## Preconditions

### List all requires -> DONE
* Compare them with outcome of
* (require '[A-Za-z0-9_-]+'|require\('[A-Za-z0-9_-]+'\))
* Take actions?
* Now we are sure to find all requires

### List of files/folders in -> DONE
* lib
* node_modules
* lib/schedulemanager

### Create functions to ...
* Connect require of absolute path with target in folder
* Calculate relative path
* Write changed file

## Tasks

Use absolute paths for node modules only
* Do nothing

Use relative paths for everything else
* Change absolute to relative requires for all file paths
* get rid of `lib` entry point for webpack
* get rid of `lib/schedulemanager` entry point for webpack

Explicitly all filenames but 'index'
* Explicitly name 'client' file in require,
* get rid of the default `client` entry point for webpack

Only use 'client' if there is also an 'index' file in the folder
* Check if there are folders with file client.coffee/js but without index.coffee/js
* In this case: Rename client files to index files
* Adjust requires

Don't use file extensions for .coffee and .js files
* Find requires with file extension .js / .coffee
* Remove file extensions .js and .coffee

Use file extensions for all other types (needed by webpack)
* Connect files with target
* Print all targets that are not of type '.coffee' / '.js'
* Manually repair

Do not use dynamic require paths
* Check if dynamic require path are used
* manually repair if necessary

Define requires at top level of the file if possible
* check if it makes sense now to automatically move requires to top level or rather do it after transition to ES6
* Handle patterns like
* {expect} = require('chai').use require 'chai-immutable'


## Pay attention to the following files:

### JS
* [x] rplan/index.js
* [x] test/webpack-client-tests.js
* [x] rplan/tools/karma-ie-polyfill.js
* [x] rplan/lib/main/import-users.js              Dynamic require

### Coffee
* [ ] lib/di-container/index.coffee               Dynamic require
* [ ] lib/migration/MigrationRuleManager.coffee   Dynamic require
* [ ] lib/page-auth/client.coffee                 If statement as string to be evaluated later?????????
* [ ] lib/page-login-signup/client.coffee         If statement as string to be evaluated later?????????
* [ ] lib/translation-map/index.coffee            Dynamic require
* [ ] login/test/browser.client.coffee            require('inject!login/view.coffee')
* [ ] page-login-signup/test/index.client.coffee  If statement as string to be evaluated later?????????
* [ ] signup/test/browser.client.coffee           require('inject!signup')
