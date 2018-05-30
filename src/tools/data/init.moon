platform = require "tools.platform"
util     = require "tools.util"

homedir = os.getenv "HOME"

name = "lovepack"

local path

if platform.name == "MacOS"
	path = homedir .. "/Library/Application Support/" .. name

elseif platform.name == "Linux"
	path = (os.getenv("XDG_DATA_HOME") or (homedir .. '/.local/share/')) .. name

elseif platform.name == "Windows"
	path = (os.getenv("env.LOCALAPPDATA") or (homedir .. '/AppData/Local/')) .. "/" .. name .. "/Data"

unless util.exists path
	os.execute "mkdir '" .. path .. "'"

return path
