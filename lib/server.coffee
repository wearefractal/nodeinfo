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
                
      module.exports.sendSystem socket
      module.exports.sendHeartbeat socket
          
    if callback?
      callback server, io
        
  sendHeartbeat: (socket) ->
    out = {}
    out.system = {}

    # Once again, this is HILARIOUS
    system.getProcesses process.installPrefix, (results) -> 
      out.system.processes = results
      
      system.getDiskUsage (results) -> 
        out.system.diskUsage = results
        
        system.getMemoryUsage (results) ->
          out.system.memoryUsage = results
          
          system.getCPUUsage (results) ->
            out.system.cpuUsage = results
            socket.emit 'beat', out 
            update = () -> module.exports.sendHeartbeat(socket) 
            setTimeout(update, 2000)
                      
  sendSystem: (socket) ->
    out = {}
    out.npm = {}
    out.node = {}
    out.system = {}
    
    # I could have used something here but this was just way too funny
    npm.getVersion (results) -> 
      out.npm.version = results
      npm.getPackages (results) -> 
        out.npm.packages = results
        
        node.getVersion (results) -> 
          out.node.version = results
          
          node.getEnvironment (results) -> 
            out.node.environment = results
            
            node.getPrefix (results) -> 
              out.node.location = results
                
              system.getPlatform (results) -> 
                out.system.platform = results
                
                system.getRAM (results) -> 
                  out.system.ram = results
                  
                  system.getCPUs (results) -> 
                    out.system.cpu = results
                    
                    npm.getPackages (results) -> 
                      out.npm.packages = results  
                      socket.emit 'start', out
                      #update = () -> module.exports.sendSystem(socket) 
                      #setTimeout(update, 60000)
