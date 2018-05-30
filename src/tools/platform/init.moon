util = require "tools.util"

-- Get platform name.

local name, arch

if util.exists "/Applications"
	name = "MacOS"
	arch = "x64"

elseif util.exists "/home"
	name = "Linux"
	arch = util.run "uname -m"
	if (arch\find "x86_64") or (arch\find "x64")
		arch = "x64"
	else
		arch = "x86"

elseif util.exists "C:/Windows"
	name = "Windows"
	cmd = util.run "wmic os get osarchitecture"
	if cmd\find "64.*bit"
		arch = "x64"
	else
		arch = "x86"

else
	error "Cannot detect platform!"

return { :name, :arch }
