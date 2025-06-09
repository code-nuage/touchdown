local themes = {}
themes.__index = themes

function themes.new(theme)
    local i = setmetatable({}, themes)

    i.colors = {
        reset = "\27[0m"
    }

    for color, value in pairs(theme) do
        local fr, fg, fb
        local br, bg, bb
        local fc, bc, bold, italic, underlined, dashed = "", "", "", "", "", ""

        if value.foreground then
            if value.foreground:match("^#(%x%x%x%x%x%x)$") then
                fr, fg, fb = value.foreground:match("^#(%x%x)(%x%x)(%x%x)$")
                fr, fg, fb = tonumber(fr, 16), tonumber(fg, 16), tonumber(fb, 16)
                fc = string.format("\27[38;2;%d;%d;%dm", fr, fg, fb)
            end
        end
        if value.background then
            if value.background:match("^#(%x%x%x%x%x%x)$") then
                br, bg, bb = value.background:match("^#(%x%x)(%x%x)(%x%x)$")
                br, bg, bb = tonumber(br, 16), tonumber(bg, 16), tonumber(bb, 16)
                bc = string.format("\27[48;2;%d;%d;%dm", br, bg, bb)
            end
        end
        if value.bold then
            bold = "\27[1m"
        end
        if value.italic then
            italic = "\27[3m"
        end
        if value.underlined then
            underlined = "\27[4m"
        end
        if value.dashed then
            dashed = "\27[9m"
        end

        i.colors[color] = fc .. bc .. bold .. italic .. underlined .. dashed
    end

    return i
end

function themes:apply(text)
    text = text .. "{{reset}}"
    return text:gsub("{{(.-)}}", function(key)
        return self.colors[key] or ""
    end)
end

lui.themes = themes

return themes
