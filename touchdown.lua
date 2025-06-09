#!/usr/bin/env lua

require("lui")
require("libs.lui-keys.init")
require("libs.lui-themes.init")

local theme = lui.themes.new(require("modules.theme"))

local parser = require("modules.parser")

local View = require("modules.view")

local filename = "test.md"
local file = io.open(filename, "r")
local data

if file then
    data = file:read("*a")
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
    lui.graphics.draw(theme:apply("{{bottom_bar}}" .. view.progress .. "%"), lui.graphics.get_width() - #tostring(view.progress), lui.graphics.get_height())
end

lui.run()