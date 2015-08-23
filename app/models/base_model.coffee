# Dependencies
_ = require('underscore')
db = require('../services/sql_query_service')
sql = require('sql')
q = require('q')

# Private Methods
frontend = -> Boolean(window)
backend = -> !frontend()

class BaseModel
  # Instance Methods
  constructor: (args) ->
    valid_keys = _.pluck(this.constructor.schema().columns, 'name')
    _.each(valid_keys, (key) => this[key] = args[key])

  save: ->
    sql_string = sql.define(this.constructor.schema()).insert(this).toQuery()
    this.constructor.getRecordPromise -> db.query(sql_string)

  # Class Methods
  @create: (args) -> this.new(args).save()

  @new: (args) ->
    instance = new this(args)
    return instance

  @getRecordPromise: (fn) ->
    constructor = this
    deferred = q.defer()
    success = (response) ->
      instance = constructor.new(response.data)
      deferred.resolve(instance)
    failure = (response) ->
      deferred.reject(response.data)
    fn().then(success, failure)
    deferred.promise

  @schema = (schema) ->
    schema.columns.push({name: 'id', dataType: 'serial'})
    schema.columns.push({name: 'created_at', dataType: 'character varying(255)'})
    schema.columns.push({name: 'updated_at', dataType: 'character varying(255)'})
    return schema

  @class_name: ->
    this.name ? /^function\s+([\w\$]+)\s*\(/.exec( this.toString() )[ 1 ]

  @type_single: -> this.class_name().toLowerCase()

  @type_plural: -> "#{this.type_single()}s"

# Base Model
module.exports = BaseModel
