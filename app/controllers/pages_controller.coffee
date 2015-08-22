# Dependencies
RouteController = require('express').Router()

# Controller Methods
root = (request, response) ->
  response.render('index', title: '#firstWorldProblems')

# Config
RouteController.get('/', root)
module.exports = RouteController