module.exports = {
	setup : function (express, app) {
	app.engine('html', require('ejs').renderFile); // Use ejs as a render engine
app.use(express.static(__dirname + '/..')) // Makes the static files available for get requests
	}
}