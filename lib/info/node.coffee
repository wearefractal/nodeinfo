module.exports = 
  getVersion: (callback) -> callback process.version.replace 'v', ''
  getEnvironment: (callback) -> callback process.env.NODE_ENV || "None"
  getPrefix: (callback) -> callback process.installPrefix
