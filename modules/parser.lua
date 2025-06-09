return function(text)
    local replacements = {
        reset = "{{reset}}",
        header_1 = "{{header_1}}", header_2 = "{{header_2}}", header_3 = "{{header_3}}", header_4 = "{{header_4}}",
        bold = "{{bold}}", italic = "{{italic}}", underlined = "{{underlined}}", dashed = "{{dashed}}",
        inline_code = "{{inline_code}}", block_code = "{{block_code}}",
        quote = "{{quote}}",
        bullet = "{{bullet}}", list = "{{list}}", todo_task = "{{todo}}", done_task = "{{done}}"
    }

    -- Set placeholder to protect block of code
    local blocks = {}
    text = text:gsub("```(.-)```", function(code)
        local placeholder = "§§BLOCK_" .. #blocks + 1 .. "§§"
        table.insert(blocks, code)
        return placeholder
    end)

    local lines = {}
    for line in (text .. "\n"):gmatch("(.-)\n") do
        -- Headers
        if line:match("^#### ") then
            line = line:gsub("^#### (.+)", replacements.header_4 .. "#### %1" .. replacements.reset)
        elseif line:match("^### ") then
            line = line:gsub("^### (.+)", replacements.header_3 .. "### %1" .. replacements.reset)
        elseif line:match("^## ") then
            line = line:gsub("^## (.+)", replacements.header_2 .. "## %1" .. replacements.reset)
        elseif line:match("^# ") then
            line = line:gsub("^# (.+)", replacements.header_1 .. " %1 " .. replacements.reset)
        end

        -- Task list
        line = line:gsub("^%- %[x%] (.-)", "  [" .. replacements.done_task .. "✓" .. replacements.reset .. "] %1")
        line = line:gsub("^%- %[ %] (.-)", "  [" .. replacements.todo_task .. "×" .. replacements.reset .. "] %1")

        -- Ordered list
        line = line:gsub("^(%d+)%. (.+)", "  " .. replacements.list .. "%1." .. replacements.reset .. " %2")

        -- Bullet list
        line = line:gsub("^%- (.+)", "  " .. replacements.bullet .. "•" .. replacements.reset .. " %1")


        -- Blockquote
        line = line:gsub("^> (.+)", "  " .. replacements.quote .. "|" .. replacements.reset .. " %1")

        table.insert(lines, line)
    end

    text = table.concat(lines, "\n")

    -- Inline code
    text = text:gsub("`(.-)`", replacements.inline_code .. " %1 " .. replacements.reset)

    -- Bold & Italic & Underlined & Dashed
    text = text:gsub("%*%*(.-)%*%*", replacements.bold .. "%1" .. replacements.reset)
    text = text:gsub("%*(.-)%*", replacements.italic .. "%1" .. replacements.reset)
    text = text:gsub("++(.-)++", replacements.underlined .. "%1" .. replacements.reset)
    text = text:gsub("%~%~(.-)%~%~", replacements.dashed .. "%1" .. replacements.reset)

    -- Replace placeholder with aligned background and reset
    text = text:gsub("§§BLOCK_(%d+)§§", function(i)
        local code = blocks[tonumber(i)]
        local lines = {}
        local max_len = 0

        -- Split code block into lines and compute max length
        for line in (code .. "\n"):gmatch("(.-)\n") do
            table.insert(lines, line)
            if #line > max_len then
                max_len = #line
            end
        end

        -- Apply background color and align reset
        for idx, line in ipairs(lines) do
            local padding = string.rep(" ", max_len - #line)
            lines[idx] = replacements.block_code .. line .. padding .. replacements.reset
        end

        return table.concat(lines, "\n")
    end)


    return text
end
