sys = require('sys')
exec = require('child_process').exec
fs = require 'fs'

module.exports = 
 
  # Thanks to eldios for some of the following code! - http://github.com/eldios
  getMemoryUsage: (callback) -> 
    exec "top -b -n 1 | awk '/Mem/ {print $2, $3, $4, $5, $6}'", (err, resp) ->
      if err?
        callback {error: err}
      else
        info = resp.split ','
        out = {}
        
        out.total = parseInt info[0].trim()
        out.used = parseInt info[1].trim()
        out.free = parseInt info[2].trim()
        
        out.freeRatio = Math.round out.free / out.total * 100
        out.usedRatio = Math.round out.used / out.total * 100
        
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
        out.used = parseInt(args[1].replace 'G', '')
        out.total = parseInt(args[2].replace 'G', '')
        out.free = Math.round(out.total - out.used)
        out.usedPercent = parseInt(args[3].replace '%', '')
        callback out
  
  getCPUs: (callback) ->
    exec "cat /proc/cpuinfo | grep 'model name'", (err, resp) ->
      if err?
        callback {error: err}
      else
        resp = resp.split '\n'
        callback {count: resp.length-2, name: resp[0].split(':')[1]}
        
  getCPUUsage: (callback) ->
    exec "top -b -n 1 | awk '/Cpu/ {print $2, $3}'", (err, resp) ->
      if err?
        callback {error: err}
      else
        percs = resp.split ' '
        userPerc = parseFloat percs[0]
        sysPerc = parseFloat percs[1]
        totalPerc = userPerc + sysPerc
        callback {usedRatio: totalPerc}       
          
  getRAM: (callback) ->
    exec "free -m | awk '{print $2}'", (err, resp) ->
      if err?
        callback {error: err}
      else
        resp = resp.split('\n')[1]
        size = Math.round(parseInt(resp) / 1000) + 'GB'
        callback size
          
  getProcesses: (grep, callback) ->
    exec "ps aux | grep " + grep + " | awk '/!grep/ {print $1,$2,$3,$4,$10,$11}'", (err, resp) ->
      if err?
        callback {error: err}
      else
        out = []
        resp = resp.split '\n'
        for proc in resp
          args = proc.split ' '
          if args.length isnt 6
            continue
          out.push [args[1], args[2], args[3], args[5], args[4], args[0]]
          ###
          obj = {}
          obj.user = args[0]
          obj.pid = args[1]
          obj.cpu = args[2]
          obj.memory = args[3]
          obj.uptime = args[4]
          obj.command = args[5]
          out.push obj
          ###
        callback out
          
  getPlatform: (callback) ->
    exec "uname -a", (err, resp) ->
      if err?
        callback {error: err}
      else
        callback resp
  
