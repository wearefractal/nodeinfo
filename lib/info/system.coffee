sys = require('sys')
exec = require('child_process').exec
fs = require 'fs'

module.exports = 
 
  # Thanks to eldios some of the following code! - http://github.com/eldios
  getMemoryUsage: (callback) -> 
    fs.readFile '/proc/meminfo', (err, data) ->
      if err?
        callback {error: err}
      else
        info = data.toString().split '\n'
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
    exec "df -h | awk '{print $1,$3,$4,$5}'", (err, resp) ->
      if err?
        callback {error: err}
      else
        out = {}
        resp = resp.split('\n')[1]
        args = resp.split ' '
        out.disk = args[0]
        out.used = args[1]
        out.total = args[2]
        out.usedPercent = args[3]
        callback out
  
  getProcesses: (grep, callback) ->
    exec "ps aux | grep " + grep + " | awk '{print $1,$2,$3,$4,$10,$11}'", (err, resp) ->
      if err?
        callback {error: err}
      else
        out = []
        resp = resp.split '\n'
        for proc in resp
          args = proc.split ' '
          obj = {}
          obj.user = args[0]
          obj.pid = args[1]
          obj.cpu = args[2]
          obj.memory = args[3]
          obj.uptime = args[4]
          obj.command = args[5]
          out.push obj
        callback out
          
  getPlatform: (callback) -> callback process.platform
  
