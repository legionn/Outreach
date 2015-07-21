module.exports = {
	onGetRequest : function (app) {
		// On GET request of new elmsim
		app.get('/elmsim', function (req, res) {
			console.log('GET request for a new elmsim: ' + req.path)
			// Get a random directory name
			getRandomDirName(new Tutorial(false, ''), res)
		})
		app.get(/\/tutorials\/.{1,}/g, function (req, res) {
			// Get a random directory name
			getRandomDirName(new Tutorial(true, req.path), res)
		})
	}
}

function getRandomDirName (tutorial, res) {
	// Get a random name for the folder
	var foldername = Math.random().toString(36).substring(7)
	console.log('Got random dir name: ' + foldername)
	// Create the directory
	createDir(tutorial, foldername, res)
}

function createDir (tutorial, foldername, res) {
	var fs = require('fs')
	// Get the full directory to make the folder
	var compilepath = __dirname + '/../views/compile/' + foldername
	// Make the new folder
	fs.mkdir(compilepath, function (e) {
		if (e) {
			console.log(e)
		}
		else {
			console.log('Created directory: ' + __dirname + '/views/compile/' + foldername)
			// Create default files (input.elm, elmsim.html, output.html)
			moveDefaultFiles(tutorial, foldername, res)
		}
	})
}

function moveDefaultFiles (tutorial, foldername, res) {
	var ncp = require('ncp')
		defaultpath = ''
	// Copy all of the contents in default to the new folder
	ncp.limit = 16
	if (tutorial.enabled) {
		defaultpath = 'views' + tutorial.name.substring(0, tutorial.name.length - 1)
	}
	else {
		defaultpath = 'views/compile/default'
	}
	ncp(defaultpath, 'views/compile/' + foldername, function (e) {
		if (e) {
			console.log(e)
		}
		console.log('Moved files to: ' + 'views/compile/' + foldername)
		// Send get response
		sendGetResponse(foldername, res)
	})
	
}

function sendGetResponse (foldername, res) {
	// Render compile/foldername/elmsim.html
	console.log('\n' + foldername + '\n')
	res.redirect('/../../compile/' + foldername + '/elmsim.html')
}

function Tutorial (enabled, name) {
	this.enabled = enabled
	this.name = name
}