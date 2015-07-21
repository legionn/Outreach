module.exports = {
	decodeWithPlus : function (str) {
		// Create array seperated by +
		var splittedstr = str.split('%2B')

		// Decode each array element and add to output string seperated by '+'
		var outs = ''
		var first = true
		splittedstr.forEach(function (element) {
			if (first) {
				outs += replaceAll('+', ' ', decodeURIComponent(element))
				first = false
			}
			else {
				outs += '+' + replaceAll('+', ' ', decodeURIComponent(element))
			}
		})
		return outs
	}
}

function replaceAll (find, replace, str) {
	var outs = ''
	for (i = 0; i < str.length; i++) {
		if (str[i] === find) {
			outs += replace
		}
		else {
			outs += str[i]
		}
	}
	return outs
}
