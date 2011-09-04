sys = require 'sys'
exec = require('child_process').exec
fs = require 'fs'
os = require 'os'

module.exports = 
 
  getMemoryUsage: (callback) -> 
    out = {}
    out.total = os.totalmem()
    out.free = os.freemem()
    out.used = out.total - out.free
    
    out.freeRatio = Math.round((out.free / out.total) * 100)
    out.usedRatio = Math.round((out.used / out.total) * 100)
    
    callback out
      
  getUptime: (callback) ->
    callback os.uptime()
      
  getDiskUsage: (callback) ->
    exec "df -h | awk '{print $1,$3,$4,$5}'", (err, resp) ->
      if err?
        callback {error: err}
      else
        out = {}
        resp = resp.split('\n')[1]
        args = resp.split ' '
        out.disk = args[0]
        out.used = Math.round(args[1].replace 'G', '')
        out.total = Math.round(args[2].replace 'G', '')
        out.free = Math.round(out.total - out.used)
        out.usedPercent = Math.round(args[3].replace '%', '')
        callback out
  
  getCPUs: (callback) ->
    cpus = os.cpus()
    callback {count: cpus.length, name: cpus[0].model}
        
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
    size = Math.round(os.totalmem() / 1000000000) + 'GB'
    callback size
  
  getLoad: (callback) ->
    callback os.loadavg()[0]*100
              
  getProcesses: (grep, callback) ->
    # exec "ps aux | grep " + grep + " | awk '/!grep/ {print $1,$2,$3,$4,$10,$11}'", (err, resp) ->
    exec "ps aux | awk '!/PID/ {print $1,$2,$3,$4,$10,$11}'", (err, resp) ->
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
    callback os.type() + ' ' + os.release()
  
