local platform = require("tools.platform")
local util = require("tools.util")
local homedir = os.getenv("HOME")
local name = "lovepack"
local path
if platform.name == "MacOS" then
  path = homedir .. "/Library/Application Support/" .. name
elseif platform.name == "Linux" then
  path = (os.getenv("XDG_DATA_HOME") or (homedir .. '/.local/share/')) .. name
elseif platform.name == "Windows" then
  path = (os.getenv("env.LOCALAPPDATA") or (homedir .. '/AppData/Local/')) .. "/" .. name .. "/Data"
end
if not (util.exists(path)) then
  os.execute("mkdir '" .. path .. "'")
end
return path
