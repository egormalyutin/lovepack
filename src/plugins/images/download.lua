local bin = require("tools.bin")
local jpegtranVersion = "3.2.0"
local gifsicleVersion = "3.0.4"
local optipngVersion = "4.0.0"
bin.download("jpegtran", {
  base = "https://raw.githubusercontent.com/imagemin/jpegtran-bin/v" .. jpegtranVersion .. "/vendor/",
  MacOS = {
    x64 = "macos/jpegtran"
  },
  Linux = {
    x86 = "linux/x86/jpegtran",
    x64 = "linux/x64/jpegtran"
  },
  Windows = {
    x86 = "win/x86/jpegtran.exe",
    x64 = "win/x64/jpegtran.exe"
  }
})
bin.download("gifsicle", {
  base = "https://raw.githubusercontent.com/imagemin/gifsicle-bin/v" .. gifsicleVersion .. "/vendor/",
  MacOS = {
    x64 = "macos/gifsicle"
  },
  Linux = {
    x86 = "linux/x86/gifsicle",
    x64 = "linux/x64/gifsicle"
  },
  Windows = {
    x86 = "win/x86/gifsicle.exe",
    x64 = "win/x64/gifsicle.exe"
  }
})
bin.download("optipng", {
  base = "https://raw.githubusercontent.com/imagemin/optipng-bin/v" .. optipngVersion .. "/vendor/",
  MacOS = {
    x64 = "macos/optipng"
  },
  Linux = {
    x86 = "linux/x86/optipng",
    x64 = "linux/x64/optipng"
  },
  Windows = {
    x86 = "win/x86/optipng.exe",
    x64 = "win/x64/optipng.exe"
  }
})
return print("Downloaded!")
