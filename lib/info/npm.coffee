npm = require 'npm'
exec = require('child_process').exec

module.exports = 
  getVersion: (callback) -> callback npm.version
  getPackages: (callback) ->
    npm.load {}, (err) ->
      if err?
        callback {error: err}
      else
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
                  packs.push {name: pack[0], version: pack[1]}
            callback packs
