require 'protege'
nodeinfo = require '../lib/main'
log = nodeinfo.log

test = (caller, results) ->
  log.info caller.green + ': ' + results.stringify()

log.info 'Starting INFO tests'
  
nodeinfo.npm.getVersion (results) -> test 'npm.getVersion()', results
nodeinfo.npm.getPackages (results) -> test 'npm.getPackages()', results
  
nodeinfo.node.getVersion (results) -> test 'node.getVersion()', results
nodeinfo.node.getEnvironment (results) -> test 'node.getEnvironment()', results
nodeinfo.node.getPrefix (results) -> test 'node.getPrefix()', results
  
nodeinfo.system.getMemoryUsage (results) -> test 'system.getMemoryUsage()', results
nodeinfo.system.getDiskUsage (results) -> test 'system.getDiskUsage()', results
nodeinfo.system.getPlatform (results) -> test 'system.getPlatform()', results
nodeinfo.system.getProcesses process.installPrefix, (results) -> test 'system.getProcesses()', results
