sys = require 'sys'
exec = require('child_process').exec
fs = require 'fs'
os = require 'os'

module.exports = 
 
  getMemoryUsage: (callback) -> 
    memPerc = 100 - ((os.freemem() / os.totalmem()) * 100)
    callback {usedRatio: memPerc}
      
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
    total = 0;
    idle = 0;
    for t in os.cpus()
      total += t.times.user + t.times.nice + t.times.sys + t.times.idle
      idle += t.times.idle
    total = total / os.cpus().length  
    idle = idle / os.cpus().length 
    
    cpuPerc = 100 - ((idle / total) * 100)
    
    callback {usedRatio: cpuPerc}       
          
  getRAM: (callback) ->
    size = Math.round(os.totalmem() / 1000000000) + 'GB'
    callback size
  
  getLoad: (callback) ->
    load = os.loadavg()[0]*100
    if load > 100
      load = load / 10
    callback load
              
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
        callback out
          
  getPlatform: (callback) ->
    callback os.type() + ' ' + os.release()
  
