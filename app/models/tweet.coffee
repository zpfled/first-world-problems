# Dependencies
_ = require('underscore')
BaseModel = require('./base_model')

class Tweet extends BaseModel
  @new: (args) ->
    args.user_id = args.user.id
    args.username = args.user.screen_name
    args.content = args.text
    args.longitude = args.coordinates.coordinates[0]
    args.latitude = args.coordinates.coordinates[1]
    args.twitter_id = args.id_str
    args.location = args.user.location
    args.stars = args.favorite_count or 0
    super(args)

  @attributes: [{name: 'username', dataType: 'character varying(255)'},
                {name: 'content', dataType: 'character varying(255)'},
                {name: 'longitude', dataType: 'decimal'},
                {name: 'latitude', dataType: 'decimal'},
                {name: 'twitter_id', dataType: 'character varying(255)'},
                {name: 'location', dataType: 'character varying(255)'},
                {name: 'stars', dataType: 'integer'}]

  @schema: ->
    schema = {name: 'tweets', columns: []}
    _.map(this.attributes, (attr) -> schema.columns.push(attr))
    super(schema)

# Tweet Model
module.exports = -> Tweet