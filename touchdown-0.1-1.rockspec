package = "touchdown"
version = "0.1-1"

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

    modules = {
        ["modules.parser"] = "./modules/parser.lua",
        ["modules.theme"] = "./modules/theme.lua",
        ["modules.view"] = "./modules/view.lua",
        ["libs.lui-keys.init"] = "./libs/lui-keys/init.lua",
        ["libs.lui-themes.init"] = "./libs/lui-themes/init.lua",
    },

    install = {
        bin = {
            ["touchdown"] = "touchdown.lua"
        }
    }
}
