fusker = require 'fusker'
path = require 'path'
async = require 'async'
npm = require './info/npm'
node = require './info/node'
processes = require './info/process'
system = require './info/system'


module.exports =
  broadcast: (port, callback) ->
    fusker.config.dir = path.normalize(__dirname + '/client/')
    fusker.config.banLength = 0
    fusker.config.verbose = false
    fusker.config.silent = true

    server = fusker.http.createServer port
    io = fusker.socket.listen server

    io.sockets.on 'connection', (socket) ->
      beat = ->
        module.exports.sendHeartbeat  socket
        setTimeout beat, 1000

      sys = ->
        module.exports.sendSystem socket
        # setTimeout beat, 10000

      sys()
      beat()

    if callback?
      callback server, io

  sendHeartbeat: (socket) ->
    out = {}
    out.system = {}
    mem = (call) ->
      system.getMemoryUsage (results) ->
        out.system.memoryUsage = results
        call()
    cpu = (call) ->
      system.getCPUUsage (results) ->
          out.system.cpuUsage = results
          call()
    load = (call) ->
      system.getLoad (results) ->
            out.system.load = results
            call()
    async.parallel [mem, cpu, load], -> socket.emit 'beat', out

  sendSystem: (socket) ->
    out = {}
    out.npm = {}
    out.node = {}
    out.system = {}

    sysProc = (call) ->
      system.getProcesses process.installPrefix, (results) ->
        out.system.processes = results
        call()
    npmVer = (call) ->
      npm.getVersion (results) ->
        out.npm.version = results
        call()
    npmPacks = (call) ->
      npm.getPackages (results) ->
        out.npm.packages = results
        call()
    nodeVer = (call) ->
      node.getVersion (results) ->
        out.node.version = results
        call()
    nodeEnv = (call) ->
      node.getEnvironment (results) ->
        out.node.environment = results
        call()
    nodePre = (call) ->
      node.getPrefix (results) ->
        out.node.location = results
        call()
    sysPlatform = (call) ->
      system.getPlatform (results) ->
        out.system.platform = results
        call()
    sysRAM = (call) ->
      system.getRAM (results) ->
        out.system.ram = results
        call()
    sysCPU = (call) ->
      system.getCPUs (results) ->
        out.system.cpu = results
        call()
    sysDisk = (call) ->
      system.getDiskUsage (results) ->
        out.system.diskUsage = results
        call()
    sysUptime = (call) ->
      system.getUptime (results) ->
        out.system.uptime = results
        call()

    async.parallel [sysProc, sysCPU, sysRAM, sysUptime, sysDisk, nodePre, nodeEnv, nodeVer, npmPacks, npmVer, sysProc, sysPlatform], -> socket.emit 'start', out

