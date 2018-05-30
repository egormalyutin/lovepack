dataDir = require "tools.data"
util    = require "tools.util"

paths = dataDir .. "/bin"

pickExisting = (bin) ->
	if util.exists paths .. "/" .. bin
		return paths .. "/" .. bin
	elseif util.exists paths .. "/" .. bin .. ".exe"
		return paths .. "/" .. bin .. ".exe"
	else
		return nil

runJpegtran = (->
	program = pickExisting "jpegtran"
	return unless program

	return (data) ->
		input = util.tmpFile data
		output = util.tmpFile ""
		util.run program .. " -outfile '" .. output.path .. "' '" .. input.path .. "'"
		input.remove!
		result = util.read output.path
		output.remove!
		return result
)!

runGifsicle = (->
	program = pickExisting "gifsicle"
	return unless program

	return (data) ->
		input = util.tmpFile data
		output = util.tmpFile ""
		util.run program .. " -o '" .. output.path .. "' '" .. input.path .. "'"	
		input.remove!
		result = util.read output.path
		output.remove!
		return result
)!

runOptipng = (->
	program = pickExisting "optipng"
	return unless program

	return (data) ->
		input = util.tmpFile data
		output = os.tmpname()
		os.remove output
		util.run program .. " -out '" .. output .. "' '" .. input.path .. "'"
		input.remove!
		result = util.read output
		os.remove output
		return result
)!

util.write "test2.png", optipng util.read "test.png"
