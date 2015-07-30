var fs = require('fs')

module.exports = {
	onPostRequest : function (app) {
		// When there is a POST request
		app.post(/\/compile\/.{1,}\/elmsim.html/g, function (req, res) {
			console.log('POST request received from elmsim: ' + req.path)
			req.setEncoding('ascii')
			var chunks = ''
			req.on('data', function (chunk) {
				chunks += chunk
			})
			req.on('end', function () {
				data = chunks
				console.log('data is : \n' + data + '\n')
				// Write the data to the input.elm file
				writeToFile(data, req.path.split('/')[2], res)
			})
		})
	}
}

function writeToFile (data, foldername, res) {
	var pathname = __dirname + '/../compile/' + foldername
	// Decode input and write to file
	var newdata = require('./helper.js').decodeWithPlus(data.substring(8))
	fs.writeFile(pathname + '/input.elm', newdata, function (e){
		if (e) {
			console.log(e)
		}
	    else {
	    	console.log('Input data was written to: ' + pathname)
			// Compile
			concatFiles(pathname, res)
		}
	})
}

function concatFiles (pathname, res) {
	// These are the two files to concat
	var inputdir = pathname + '/input.elm'
		concatdir = pathname + '/concat.elm'
		concatcontent = ''
		inputcontent = ''
		outputdir = pathname + '/input1.elm'

	// Read the content from input.elm
	fs.readFile(concatdir, function (e, data) {
		if (e) {
			console.log(e)
		}
		else {
			concatcontent = data

			// Read the content from input.elm
			fs.readFile(inputdir, function (e, data) {
				if (e) {
					console.log(e)
				}
				else {
					inputcontent = data

					// Concat the two strings and write to input1.elm
					fs.writeFile(outputdir, concatcontent + inputcontent, function (e) {
						if (e) {
							console.log(e)
						}
						else {
							console.log('Concat success!')
							// Compile the file
							compileFile(pathname, res)
						}
					})
				}
			})
		}
	})
}

function compileFile (pathname, res) {
	// Set up shell and create string with command
	var exec = require('child_process').exec, child;
	var inputdir = pathname + '/input1.elm'
	var outputdir = pathname + '/output.html'
	var errordir  = pathname + '/error.txt'

	var commandToRun = 'elm-make ' + inputdir + ' --output=' + outputdir + '&> ' + errordir
	// Compile file
	child = exec(commandToRun, function (error, stdout, stderr) {
        if (error !== null) {
             console.log('exec error: ' + error);
        }
        // If there was an error in compilation
        fs.readFile(errordir, function (e, data) {
        	if (e) {
        		console.log(e)
        	}
        	else {
        		if (data.toString('utf8').substring(0,8) != 'Compiled') {
        			// There was an error
        			makeErrorHtml(data.toString('utf8'), outputdir, pathname, res) 
        		}
        		else {
        			// There was no error
        			console.log('The file was compiled!')
        			// Render
        			sendPostResponse(pathname, res)
        		}
        	}
        })
    })

}

function makeErrorHtml (error, outputdir, pathname, res) {
	// Read the code to combine
	fs.readFile(pathname + '/error.elm', function (e, data) {
		if (e) {
			console.log(e)
		}
		else {
			// Combine the code and write to error1.elm
			fs.writeFile(pathname + '/error1.elm', data + '"""' + error + '"""', function (err) {
				// Compile the error file as the new output
				var exec = require('child_process').exec, child;
				var commandToRun = 'elm-make ' + pathname + '/error1.elm' + ' --output=' + outputdir
				// Compile file
				child = exec(commandToRun, function (e, stdout, stderr) {
				console.log('The error file has been compiled')
				// Render
				sendPostResponse(pathname, res)
				})
			})
			
		}
	})
}

function sendPostResponse (pathname, res) {
	// Send response with newly rendered html
	console.log('pathname is ' + pathname)
	res.render(pathname + '/elmsim.html')
}
