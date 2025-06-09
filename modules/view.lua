local View = {}
View.__index = View
function View.new(x, y, w, h, text)
    local i = setmetatable({}, View)

    i.x, i.y = x, y
    i.w, i.h = w, h
    i.text = text
    i.scroll_x, i.scroll_y = 0, 0                                                          -- X and Y scrolls
    i.progress = 0

    return i
end

function View:update()
    if lui.keyboard.is_down(lui.keys["ARROW_DOWN"]) or lui.keyboard.is_down("k") then
        local i = 0
        for _ in (self.text .. "\n"):gmatch("(.-)\n") do
            i = i + 1
        end

        if self.scroll_y + self.h + 1 <= i then
            self.scroll_y = self.scroll_y + 1
            self:clear()
        end
    end
    if lui.keyboard.is_down(lui.keys["ARROW_UP"]) or lui.keyboard.is_down("j") then
        if self.scroll_y - 1 >= 0 then
            self.scroll_y = self.scroll_y - 1
            self:clear()
        end
    end
    -- if lui.keyboard.is_down(lui.keys["ARROW_RIGHT"]) or lui.keyboard.is_down("l") then
    --     self.scroll_x = self.scroll_x + 1
    --     self:clear()
    -- end
    -- if lui.keyboard.is_down(lui.keys["ARROW_LEFT"]) or lui.keyboard.is_down("h") then
    --     if self.scroll_x - 1 >= 0 then
    --         self.scroll_x = self.scroll_x - 1
    --     end
    --     self:clear()
    -- end
    if lui.keyboard.is_down(lui.keys["PAGE_DOWN"]) or lui.keyboard.is_down(lui.keys["CTRL_K"]) then
        local scroll_delta = self.h - 1
        self.scroll_y = self.scroll_y + scroll_delta
        self:clear()
    end
    if lui.keyboard.is_down(lui.keys["PAGE_UP"]) or lui.keyboard.is_down(lui.keys["CTRL_J"]) then
        local scroll_delta = self.h - 1
        if self.scroll_y - scroll_delta >= 0 then
            self.scroll_y = self.scroll_y - scroll_delta
        elseif self.scroll_y - scroll_delta < 0 then
            self.scroll_y = 0
        end
        self:clear()
    end

    local total_lines = 0
    for _ in (self.text .. "\n"):gmatch("(.-)\n") do
        total_lines = total_lines + 1
    end

    local scrollable_lines = math.max(total_lines - self.h, 1)
    self.progress = math.floor(math.min((self.scroll_y / scrollable_lines) * 100, 100))
end

function View:clear()
    for y = self.y, self.y + self.h do
        local replacement_string = string.rep(" ", self.w)
        lui.graphics.draw(replacement_string, self.x, y)
    end
end

function View:draw()
    local i = 0
    for line in (self.text .. "\n"):gmatch("(.-)\n") do
        local screen_y = i - self.scroll_y

        if screen_y >= 0 and screen_y < self.h then
            local scrolled_line = line:sub(self.scroll_x + 1)
            local truncated_line = scrolled_line:sub(1, self.w)
            lui.graphics.draw(truncated_line, self.x, self.y + screen_y)
        end

        i = i + 1
    end
end


return View