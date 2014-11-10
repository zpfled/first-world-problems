// cookieParser = require('cookie-parser');

// export config object
module.exports = {
	modules: {
		express: require('express'),
		path: require('path'),
		logger: require('morgan'),
		bodyParser: require('body-parser'),
		pg: require('pg')
	},
	constants: {
		delay: require('./app/modules/constants/delay'),
		hashtag: require('./app/modules/constants/hashtag'),
		now: require('./app/modules/constants/now'),
		port: process.env.PORT || 3888,
		tweetShelfLife: require('./app/modules/constants/tweetShelfLife')
	},
	controllers: {
		db: require('./app/controllers/dbController'),
		stream: require('./app/controllers/streamController'),
		routes: require('./app/controllers/routesController')
	},
	services: {
		messenger: require('./app/services/messenger'),
		streamTweetsToClient: require('./app/services/streamTweetsToClient')
	}
};