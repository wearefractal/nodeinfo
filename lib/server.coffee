fusker = require 'fusker'
path = require 'path'
logger = require './logger'
npm = require './info/npm'
node = require './info/node'
processes = require './info/process'
system = require './info/system'


module.exports = 
  broadcast: (port, callback) ->
    
    fusker.config.dir = path.normalize(__dirname + '/client/')
    logger.debug fusker.config.dir
    fusker.config.banLength = 0
    fusker.config.verbose = false
    fusker.config.silent = true
    
    server = fusker.http.createServer port
    io = fusker.socket.listen server
    
    io.sockets.on 'connection', (socket) ->
      fn = ->
        out = {}

        # Once again, this is HILARIOUS
        system.getProcesses process.installPrefix, (results) -> 
          out.system = {}
          out.system.processes = results
          
          system.getDiskUsage (results) -> 
            out.system.disk = results
            
            system.getMemoryUsage (results) ->
              out.system.usage = results
              socket.emit 'Heartbeat', out
                
      module.exports.sendSystem socket
      fn()
      setTimeout fn, 7000
      
    if callback?
      callback server, io
        
  sendSystem: (socket) ->
    out = {}

    # I could have used something here but this was just way too funny
    npm.getVersion (results) -> 
      out.npm = {}
      out.npm.version = results
      npm.getPackages (results) -> 
        out.npm.packages = results
        
        node.getVersion (results) -> 
          out.node = {}
          out.node.version = results
          
          node.getEnvironment (results) -> 
            out.node.environment = results
            
            node.getPrefix (results) -> 
              out.node.location = results
                
              system.getPlatform (results) -> 
                out.system = {}
                out.system.platform = results
                
                npm.getPackages (results) -> 
                  out.npm.packages = results  
                  socket.emit 'Start', out
                      
  sendHeartbeat: (socket) ->
    out = {}

    # Once again, this is HILARIOUS
    system.getProcesses process.installPrefix, (results) -> 
      out.system = {}
      out.system.processes = results
      
      system.getDiskUsage (results) -> 
        out.system.disk = results
        
        system.getMemoryUsage (results) ->
          out.system.usage = results
          socket.emit 'Heartbeat', out
