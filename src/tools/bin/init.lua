local platform = require("tools.platform")
local dataDir = require("tools.data")
local request = require("tools.request")
local util = require("tools.util")
local files = data .. "/bin"
if not (util.exists(files)) then
  os.execute("mkdir '" .. files .. "'")
end
local download
download = function(exe, links)
  local path = files .. "/" .. exe
  if util.exists(path) then
    return path
  end
  links.base = links.base or ""
  local arches = links[platform.name]
  if not (arches) then
    error("Not found link to download " + exe + " for " + platform.name)
  end
  local link = arches[platform.arch]
  if not (link) then
    error("Not found link to download " + exe + " for arch " + platform.arch)
  end
  link = links.base .. link
  print("Downloading " .. exe .. "...")
  local data = request(link)
  util.write(path, data)
  if platform.name == "Linux" then
    os.execute("chmod +x " .. path)
  end
  return path
end
return {
  download = download
}
