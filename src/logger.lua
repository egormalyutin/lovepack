local inspector = require("tools.inspect")
local ch = string.char(27)
local colors = {
  reset = ch .. "[" .. 0 .. "m",
  blue = ch .. "[" .. 34 .. "m",
  red = ch .. "[" .. 31 .. "m"
}
local time
time = function()
  local date = os.date("*t")
  return date.hour .. ":" .. date.min .. ":" .. date.sec
end
return {
  log = function(...)
    return print(colors.blue .. time() .. colors.reset .. " " .. ... .. colors.reset)
  end,
  inspect = function(...)
    local str = ""
    local data = {
      ...
    }
    for i, v in ipairs(data) do
      if i == 1 then
        str = str .. inspector(v)
      else
        str = str .. (", " .. inspector(v))
      end
    end
    return print(colors.blue .. time() .. colors.reset .. " " .. str .. colors.reset)
  end,
  error = function(...)
    return io.stderr:write(colors.red .. time() .. colors.reset .. " " .. ... .. colors.reset .. "\n")
  end
}
