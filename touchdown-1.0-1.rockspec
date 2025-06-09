package = "touchdown"
version = "1.0-1"

source = {
    url = "file://."
}

description = {
    summary = "A Markdown reader",
    detailed = "A very basic markdown reader, written with lui",
    license = "MIT"
}

dependencies = {
    "lua >= 5.1",
    "lui"
}

build = {
    type = "builtin",

    -- ici, tu dois **déclarer explicitement** tes modules Lua si tu veux qu'ils soient installés
    modules = {
        ["modules.parser"] = "./modules/parser.lua",
        ["modules.theme"] = "./modules/theme.lua",
        ["modules.view"] = "./modules/view.lua",
        ["libs.lui-keys.init"] = "./libs/lui-keys/init.lua",
        ["libs.lui-themes.init"] = "./libs/lui-themes/init.lua",
    },

    -- ici, on dit à LuaRocks que `touchdown.lua` est un script CLI
    install = {
        bin = {
            ["touchdown"] = "touchdown.lua"
        }
    }
}
