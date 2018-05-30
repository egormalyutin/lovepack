local pack = {
  File = (function()
    local File
    do
      local _class_0
      local _base_0 = { }
      _base_0.__index = _base_0
      _class_0 = setmetatable({
        __init = function(self, path, data)
          self.path, self.data = path, data
        end,
        __base = _base_0,
        __name = "File"
      }, {
        __index = _base_0,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      File = _class_0
      return _class_0
    end
  end)()
}
pack.logger = require("logger")
pack.util = require("tools.util")
local argparse = require("tools.args")
pack.logger.log("Init...")
local configLoader
configLoader = function(code)
  code = "\n	local app  = 'app';\n	local dist = 'dist';\n	" .. code .. "\n	return { app = app, dist = dist }\n	"
  local config = loadstring(code)()
  return config
end
local loadConfig
loadConfig = function(path)
  local loader = configLoader
  local config = loader(pack.util.read(path))
  return config
end
local process
process = function(filenames) end
local run
run = function(path)
  pack.workdir = pack.util.cwd()
  local filenames = pack.util.readdir(pack.workdir)
  filenames = pack.util.map(filenames, function(filename)
    return pack.util.relative(pack.workdir, filename)
  end)
  local configNames = {
    "lovepack.lua",
    "lovepack.config.lua",
    "pack.config.lua"
  }
  local configPath
  for _index_0 = 1, #configNames do
    local configName = configNames[_index_0]
    local p = pack.util.findUp(pack.workdir, configName)
    if p then
      configPath = p
      break
    end
  end
  if configPath then
    pack.logger.log("Using config at " .. configPath)
  else
    pack.logger.error("Not found config!")
  end
  local config = loadConfig(configPath)
  print(config.app)
  return process(filenames)
end
return run()
