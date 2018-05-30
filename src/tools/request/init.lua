return function(url)
  print("Using cURL...")
  local file = assert(io.popen("curl " .. url, 'r'))
  local output = file:read('*all')
  file:close()
  return output
end
