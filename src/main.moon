-- päck

-- init
pack = 
	File: class File
		new: (@path, @data) =>

-- load modules
pack.logger = require "logger"
pack.util   = require "tools.util"
argparse    = require "tools.args"

pack.logger.log "Init..."

-- simple config loader
configLoader = (code) ->
	code = "
	local app  = 'app';
	local dist = 'dist';
	" .. code .. "
	return { app = app, dist = dist }
	"
	config = loadstring(code)()

	return config

loadConfig = (path) ->
	loader = configLoader
	config = loader pack.util.read path
	return config

-- build processor
process = (filenames) ->

-- start build
run = (path) ->
	pack.workdir = pack.util.cwd()

	filenames = pack.util.readdir pack.workdir
	filenames = pack.util.map filenames, (filename) ->
		return pack.util.relative pack.workdir, filename

	-- find config
	configNames = {"lovepack.lua", "lovepack.config.lua", "pack.config.lua"}
	local configPath
	for configName in *configNames
		p = pack.util.findUp pack.workdir, configName
		if p
			configPath = p
			break

	if configPath
		pack.logger.log "Using config at " .. configPath
	else
		pack.logger.error "Not found config!"

	config = loadConfig configPath
	print config.app

	process filenames

run()
