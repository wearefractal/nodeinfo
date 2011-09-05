npm = require 'npm'
exec = require('child_process').exec

module.exports = 
  getVersion: (callback) -> callback npm.version
  getPackages: (callback) ->
    exec 'npm ls -g', (err, resp) ->
      if err?
        callback {error: err}
      else
        packs = []
        lines = resp.split '\n'
        for line in lines
          if !line.startsWith(' ') and !line.startsWith('│ ')
            pack = line.split(' ')[1]
            if pack?
              pack = pack.split '@'
              name = pack[0]
              version = pack[1]
              packs.push {label: name + ' - ' + version, value: 'http://search.npmjs.org/#/' + name}
        callback packs
