local util = require("tools.util")
local name, arch
if util.exists("/Applications") then
  name = "MacOS"
  arch = "x64"
elseif util.exists("/home") then
  name = "Linux"
  arch = util.run("uname -m")
  if (arch:find("x86_64")) or (arch:find("x64")) then
    arch = "x64"
  else
    arch = "x86"
  end
elseif util.exists("C:/Windows") then
  name = "Windows"
  local cmd = util.run("wmic os get osarchitecture")
  if cmd:find("64.*bit") then
    arch = "x64"
  else
    arch = "x86"
  end
else
  error("Cannot detect platform!")
end
return {
  name = name,
  arch = arch
}
