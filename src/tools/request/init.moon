-- HTTP Get request.

return (url) ->
	print "Using cURL..."
	file = assert io.popen "curl " .. url, 'r'
	output = file\read '*all'
	file\close!
	return output
