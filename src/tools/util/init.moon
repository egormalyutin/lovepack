local util
util = {
	exists: (path) ->
		ok, err, code = os.rename path, path

		if not ok and code == 13
			return true

		return ok or false

	tmpFile: (data) ->
		path = os.tmpname!
		file = assert io.open path, 'w'
		file\write data
		file\close!
		return {
			:path
			remove: ->
				os.remove path
		}

	run: (command) ->
		file = assert io.popen command, 'r'
		output = file\read '*all'
		file\close!
		return output

	read: (path) ->
		file = assert io.open path, 'r'
		output = file\read '*all'
		file\close!
		return output

	write: (path, data) ->
		file = assert io.open path, 'w'
		file\write data
		file\close!

	split: (input, sep) ->
		if sep == nil
			sep = "%s"

		result = {}
		for str in string.gmatch(input, "([^"..sep.."]+)") do
			table.insert result, str

		return result

	readdir: (path) ->
		if util.exists("/Applications") or util.exists("/home")
			names = util.run "find '" .. path .. "' -type f"
			names = util.split names, "\n"
			return util.normalize names
		else
			-- fix
			error "no readdir on windows"

	cwd: ->
		return util.normalize(os.getenv("CD") or os.getenv("PWD") or util.run("cd"))

	relative: (fr, to) ->
		fr = util.normalize fr
		to = util.normalize to

		frStr = fr
		fr = util.split fr, "/"
		to = util.split to, "/"

		len = math.min #fr, #to

		common = {}
		level = 0

		file = io.open(frStr)
		isFile = false
		if file
			_, _, err = file\read 0
			if err == 21
				isFile = true

		for i = 1, len
			if fr[i] == to[i]
				table.insert common, fr[i]
				level += 1
			else
				break

		for i = 1, level
			table.remove fr, 1
			table.remove to, 1

		for i = 1, #fr
			table.insert to, 1, ".."

		return table.concat to, "/"

	normalize: (path) ->
		if type(path) == "string"
			result = path\gsub("\\", "/")\gsub("/$", "")
			return result

		elseif type(path) == "table"
			paths = path
			result = {}
			for path in *paths
				path = path\gsub("\\", "/")\gsub("/$", "")
				table.insert result, path
			return result

	map: (arr, cb) ->
		r = {}
		for num, item in ipairs arr
			table.insert r, cb(item, num)
		return r

	moonscript: (code) ->
		parse   = require "tools.moonscript.moonscript.parse"
		compile = require "tools.moonscript.moonscript.compile"

		tree, err = parse.string code
		unless tree
			error "Error when parsing MoonScript code: " .. err

		lc, err, pos = compile.tree tree
		unless lc
			error compile.format_error err, pos, code

		-- our code is ready
		print lc

	dirname: (path) ->
		return path\match("(.*[/\\])")\gsub("/$", "")

	findUp: (path, name) ->
		path = util.normalize(path)\gsub("/$", "")

		worker = (path) ->
			np = path .. "/" .. name
			if util.exists np
				return np
			elseif #util.split(path, "/") == 1
				return
			else
				return worker util.dirname path

		return worker path

}

return util
