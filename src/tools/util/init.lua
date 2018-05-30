local util
util = {
  exists = function(path)
    local ok, err, code = os.rename(path, path)
    if not ok and code == 13 then
      return true
    end
    return ok or false
  end,
  tmpFile = function(data)
    local path = os.tmpname()
    local file = assert(io.open(path, 'w'))
    file:write(data)
    file:close()
    return {
      path = path,
      remove = function()
        return os.remove(path)
      end
    }
  end,
  run = function(command)
    local file = assert(io.popen(command, 'r'))
    local output = file:read('*all')
    file:close()
    return output
  end,
  read = function(path)
    local file = assert(io.open(path, 'r'))
    local output = file:read('*all')
    file:close()
    return output
  end,
  write = function(path, data)
    local file = assert(io.open(path, 'w'))
    file:write(data)
    return file:close()
  end,
  split = function(input, sep)
    if sep == nil then
      sep = "%s"
    end
    local result = { }
    for str in string.gmatch(input, "([^" .. sep .. "]+)") do
      table.insert(result, str)
    end
    return result
  end,
  readdir = function(path)
    if util.exists("/Applications") or util.exists("/home") then
      local names = util.run("find '" .. path .. "' -type f")
      names = util.split(names, "\n")
      return util.normalize(names)
    else
      return error("no readdir on windows")
    end
  end,
  cwd = function()
    return util.normalize(os.getenv("CD") or os.getenv("PWD") or util.run("cd"))
  end,
  relative = function(fr, to)
    fr = util.normalize(fr)
    to = util.normalize(to)
    local frStr = fr
    fr = util.split(fr, "/")
    to = util.split(to, "/")
    local len = math.min(#fr, #to)
    local common = { }
    local level = 0
    local file = io.open(frStr)
    local isFile = false
    if file then
      local _, err
      _, _, err = file:read(0)
      if err == 21 then
        isFile = true
      end
    end
    for i = 1, len do
      if fr[i] == to[i] then
        table.insert(common, fr[i])
        level = level + 1
      else
        break
      end
    end
    for i = 1, level do
      table.remove(fr, 1)
      table.remove(to, 1)
    end
    for i = 1, #fr do
      table.insert(to, 1, "..")
    end
    return table.concat(to, "/")
  end,
  normalize = function(path)
    if type(path) == "string" then
      local result = path:gsub("\\", "/"):gsub("/$", "")
      return result
    elseif type(path) == "table" then
      local paths = path
      local result = { }
      for _index_0 = 1, #paths do
        local path = paths[_index_0]
        path = path:gsub("\\", "/"):gsub("/$", "")
        table.insert(result, path)
      end
      return result
    end
  end,
  map = function(arr, cb)
    local r = { }
    for num, item in ipairs(arr) do
      table.insert(r, cb(item, num))
    end
    return r
  end,
  moonscript = function(code)
    local parse = require("tools.moonscript.moonscript.parse")
    local compile = require("tools.moonscript.moonscript.compile")
    local tree, err = parse.string(code)
    if not (tree) then
      error("Error when parsing MoonScript code: " .. err)
    end
    local lc, pos
    lc, err, pos = compile.tree(tree)
    if not (lc) then
      error(compile.format_error(err, pos, code))
    end
    return print(lc)
  end,
  dirname = function(path)
    return path:match("(.*[/\\])"):gsub("/$", "")
  end,
  findUp = function(path, name)
    path = util.normalize(path):gsub("/$", "")
    local worker
    worker = function(path)
      local np = path .. "/" .. name
      if util.exists(np) then
        return np
      elseif #util.split(path, "/") == 1 then
        return 
      else
        return worker(util.dirname(path))
      end
    end
    return worker(path)
  end
}
return util
