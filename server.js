// Import and start express
var express = require('express')
	app = express()


// Setup express
require('./server/setup.js').setup(express, app)


// Start listening on port 3000
var server = app.listen(3000, function () {
	console.log('Listening on port 3000')
})


// Allow get and post requests
require('./server/post.js').onPostRequest(app)
require('./server/get.js').onGetRequest(app)


/*
	PROGRAM STRUCTURE (ARROWS REPRESENT CALLBACKS):

	POST:
	(compile/xxx/elmsim.html)
										   	(good)	   ^ sendPostResponse
		onPostRequest -> writeToFile -> compileFile -> | 
											(error)	   v makeErrorHtml -> sendPostResponse
	
	GET:
	(compile/xxx/elmsim.html):

		node statically serves the html	

	(tutorials/xxx): or (/elmsim):

		onGetRequest -> getRandomDirName -> createDir -> moveDefaultFiles -> sendGetResponse

*/