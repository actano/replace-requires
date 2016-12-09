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

### Create functions to ... -> DONE
* Connect require of absolute path with target in folder
* Calculate relative path
* Write changed file

## Tasks

Use absolute paths for node modules only -> DONE
* Do nothing

Use relative paths for everything else -> DONE
* Change absolute to relative requires for all file paths
* get rid of `lib` entry point for webpack
* get rid of `lib/schedulemanager` entry point for webpack

Explicitly name all filenames but 'index' -> DONE
* Explicitly name 'client' file in require,
* get rid of the default `client` entry point for webpack

Don't use file extensions for .coffee and .js files -> DONE
* Find requires with file extension .js / .coffee
* Remove file extensions .js and .coffee

Use file extensions for all other types (needed by webpack) -> DONE
* Connect files with target
* Print all targets that are not of type '.coffee' / '.js'
* Manually repair

Only use 'client' if there is also an 'index' file in the folder -> DONE
* Check if there are folders with file client.coffee/js but without index.coffee/js
* In this case: Rename client files to index files
* Adjust requires

Do not use dynamic require paths -> DONE
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
* [x] lib/di-container/index.coffee               Dynamic require
* [x] lib/migration/MigrationRuleManager.coffee   Dynamic require
* [x] lib/page-auth/client.coffee                 Parameter passed
* [x] lib/page-login-signup/client.coffee         Parameter passed
* [x] lib/translation-map/index.coffee            Dynamic require
* [x] login/test/browser.client.coffee            require('inject!login/view.coffee')
* [x] page-login-signup/test/index.client.coffee  Parameter passed
* [x] signup/test/browser.client.coffee           require('inject!signup')


## Further cleanup
* Convert lib/webapp/webapp.coffee into ES6 and remove the webapp.js
* Remove lib/styleguide and references in lib/icon

## Prevention

* Convert this project into a tool that can be integrated in the Jenkins build
* and/or convert this tool into a linter
* test unresolved or unclear (!= 1) require targets
* test requires with .coffee or .js
* test requires with explicit index
* (?) test requires on path without index file

## Clarify
* lib/gantt-tree/test/performance/*.client are not executed, clarify with leonardo
* lib/planning-object/action/translations is never used
