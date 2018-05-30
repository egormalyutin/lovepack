local dataDir = require("tools.data")
local util = require("tools.util")
local paths = dataDir .. "/bin"
local pickExisting
pickExisting = function(bin)
  if util.exists(paths .. "/" .. bin) then
    return paths .. "/" .. bin
  elseif util.exists(paths .. "/" .. bin .. ".exe") then
    return paths .. "/" .. bin .. ".exe"
  else
    return nil
  end
end
local runJpegtran = (function()
  local program = pickExisting("jpegtran")
  if not (program) then
    return 
  end
  return function(data)
    local input = util.tmpFile(data)
    local output = util.tmpFile("")
    util.run(program .. " -outfile '" .. output.path .. "' '" .. input.path .. "'")
    input.remove()
    local result = util.read(output.path)
    output.remove()
    return result
  end
end)()
local runGifsicle = (function()
  local program = pickExisting("gifsicle")
  if not (program) then
    return 
  end
  return function(data)
    local input = util.tmpFile(data)
    local output = util.tmpFile("")
    util.run(program .. " -o '" .. output.path .. "' '" .. input.path .. "'")
    input.remove()
    local result = util.read(output.path)
    output.remove()
    return result
  end
end)()
local runOptipng = (function()
  local program = pickExisting("optipng")
  if not (program) then
    return 
  end
  return function(data)
    local input = util.tmpFile(data)
    local output = os.tmpname()
    os.remove(output)
    util.run(program .. " -out '" .. output .. "' '" .. input.path .. "'")
    input.remove()
    local result = util.read(output)
    os.remove(output)
    return result
  end
end)()
return util.write("test2.png", optipng(util.read("test.png")))
