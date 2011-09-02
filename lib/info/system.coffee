sys = require('sys')
exec = require('child_process').exec

module.exports = 
 
  # Thanks to eldios some of the following code! - http://github.com/eldios
  getMemoryUsage: (callback) -> 
    fs.readFile '/proc/meminfo', (err, data) ->
      if err?
        callback {error: err}
      else
        info = data.split '\n'
        out = {}
        
        out.total = parseInt info[0].replace(/\D+/g, '')
        out.free = parseInt info[1].replace(/\D+/g, '')
        out.cached = parseInt info[3].replace(/\D+/g, '')
        out.used = out.total - out.free
        
        out.freeRatio = Math.round out.free / out.total * 100
        out.usedRatio = Math.round out.used / out.total * 100
        out.cachedRatio = Math.round out.cached / out.total * 100
        
        callback out
  
  getDiskUsage: (callback) ->
    exec 'df -h', (err, resp) ->
      if err?
        callback {error: err}
      else
        out = {}
        callback resp
  
  
  getPlatform: (callback) -> callback process.platform
  
