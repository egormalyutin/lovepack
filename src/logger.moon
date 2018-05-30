inspector = require "tools.inspect"

ch = string.char 27

colors =
	reset: ch .. "[" .. 0  .. "m"
	blue:  ch .. "[" .. 34 .. "m"
	red:   ch .. "[" .. 31 .. "m"

time = ->
	date = os.date "*t"
	return date.hour .. ":" .. date.min .. ":" .. date.sec

return  {
	log: (...) ->
		print colors.blue .. time() .. colors.reset .. " " .. ... .. colors.reset

	inspect: (...) ->
		str = ""
		data = {...}
		for i, v in ipairs data
			if i == 1
				str ..= inspector v
			else
				str ..= ", " .. inspector v

		print colors.blue .. time() .. colors.reset .. " " .. str .. colors.reset

	error: (...) ->
		io.stderr\write colors.red .. time() .. colors.reset .. " " .. ... .. colors.reset .. "\n"
}
