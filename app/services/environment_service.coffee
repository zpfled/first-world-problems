# Dependencies
app = new(require('express'))

# Environment Service
module.exports = ->
  # Public Methods
  dev: -> app.get('env') == 'development'
  prod: -> app.get('env') == 'production'

  return this