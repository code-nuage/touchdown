#!/usr/bin/env lua

require("lui")
require("libs.lui-keys.init")
require("libs.lui-themes.init")

local theme = lui.themes.new(require("modules.theme"))

local parser = require("modules.parser")

local View = require("modules.view")

if not arg[1] then
    print("Usage: touchdown <markdown_file>")
    os.exit(1)
end

if not arg[1]:match("(.-).md") then
    print("Error: " .. arg[1] .. " is not a markdown file")
    os.exit(1)
end

local filename = arg[1]
local file = io.open(filename, "r")
local data

if file then
    data = file:read("*a")
else
    print("Error: " .. arg[1] .. " doesn't exists")
    os.exit(1)
end

local raw_text = parser(data)
local pretty_text = theme:apply(raw_text)

local view = View.new(3, 2, lui.graphics.get_width() - 6, lui.graphics.get_height() - 3, pretty_text)

function lui.load()
    lui.graphics.clear()
end

function lui.update()
    if lui.keyboard.is_down("q") then
        lui.exit()
    end
    view:update()
end

function lui.draw()
    view:draw()
    local bottom_bar = string.rep(" ", lui.graphics.get_width())
    lui.graphics.draw(theme:apply("{{bottom_bar}}" .. bottom_bar), 1, lui.graphics.get_height())
    lui.graphics.draw(theme:apply("{{title}} Touchdown "), 1, lui.graphics.get_height())
    lui.graphics.draw(theme:apply("{{bottom_bar}}" .. filename), 13, lui.graphics.get_height())
    lui.graphics.draw(theme:apply("{{bottom_bar}}" .. view.progress .. "%"), lui.graphics.get_width() - #tostring(view.progress), lui.graphics.get_height())
end

lui.run()