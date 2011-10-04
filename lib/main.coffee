require('coffee-script');
require('node-log').setName 'nodeinfo'

module.exports =
  broadcast: require('./server').broadcast
  npm: require './info/npm'
  node: require './info/node'
  my: require './info/process'
  system: require './info/system'

