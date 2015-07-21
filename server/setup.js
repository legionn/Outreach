module.exports = {
	setup : function (express, app) {
		app.set('views',__dirname + '/../views') // Use the views folder to hold html
		app.engine('html', require('ejs').renderFile); // Use ejs as a render engine
		app.use(express.static('views')) // Makes the static files available for get requests
	}
}