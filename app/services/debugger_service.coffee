# Dependencies
Environment = require('./environment_service')

# Debugger Service
module.exports = ->
  # Private Methods
  should_print = -> Environment.dev() || window.debugMode
  # Public Methods
  log: (data...) -> if should_print() then console.log(data...) else null
  warn: (data...) -> if should_print() then console.warn(data...) else null
  error: (data...) -> if should_print() then console.error(data...) else null

  return this