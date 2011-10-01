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
            package = packageName[2].split '@'
            packages.push {label: package[0], version: package[1], value: 'http://search.npmjs.org/#/' + package[0]}
        callback packages

