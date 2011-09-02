module.exports = 
  getUptime: (callback) -> callback process.uptime()
  getUser: (callback) -> callback process.getuid()
  getMemoryUsage: (callback) -> callback process.memoryUsage()
  getPid: (callback) -> callback process.pid
  getTitle: (callback) -> callback process.title
  getPermissions: (callback) -> callback.umask()
