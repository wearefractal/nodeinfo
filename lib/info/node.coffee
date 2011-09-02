module.exports = 
  getVersion: (callback) -> callback process.version
  getEnvironment: (callback) -> callback process.env
  getPrefix: (callback) -> callback process.installPrefix
