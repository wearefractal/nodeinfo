exec = require('child_process').exec

module.exports =
  getVersion: (callback) ->
    exec 'npm -v', (err, resp) ->
        if err?
          callback {error: err}
        else
          callback resp

  getPackages: (callback) ->
    exec 'npm ls -g', (err, resp) ->
      if err?
        callback {error: err}
      else
        packages = []
        lines = resp.split '\n'
        for line in lines
          packageName = line.match /^(├──|├─┬|└─┬|└──) (.+)$/
          if packageName and packageName[2]
            pkg = packageName[2].split '@'
            packages.push {label: pkg[0], version: pkg[1], value: 'http://search.npmjs.org/#/' + pkg[0]}
        callback packages

