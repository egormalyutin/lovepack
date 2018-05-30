platform  = require "tools.platform"
dataDir   = require "tools.data"
request   = require "tools.request"
util      = require "tools.util"

-- helpers

files = data .. "/bin"

unless util.exists files
	os.execute "mkdir '" .. files .. "'"

download = (exe, links) ->
	path = files .. "/" .. exe
	if util.exists path
		return path

	-- links
	links.base or= ""

	arches = links[platform.name]
	unless arches
		error "Not found link to download " + exe + " for " + platform.name

	link = arches[platform.arch]
	unless link
		error "Not found link to download " + exe + " for arch " + platform.arch

	link = links.base .. link

	-- download
	print "Downloading " .. exe .. "..."

	data = request link

	-- write
	util.write path, data

	if platform.name == "Linux"
		os.execute "chmod +x " .. path

	return path

return { :download }
