-- Load standard vis module providing the Lua API
require("vis")

-- 1. Extend Lua package.path so all plugin folder structures resolve cleanly
local config_dir = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
local vis_dir = config_dir .. "/vis"
package.path = vis_dir
	.. "/?.lua;"
	.. vis_dir
	.. "/?/init.lua;"
	.. vis_dir
	.. "/plugins/?.lua;"
	.. vis_dir
	.. "/plugins/?/init.lua;"
	.. vis_dir
	.. "/plugins/?/?.lua;"
	.. package.path

-- Helper to load plugins whether they use init.lua, vis-<name>.lua, or <name>.lua
local function load_plugin(repo_name)
	local short_name = repo_name:gsub("^vis%-", "")
	local with_prefix = "vis-" .. short_name

	-- Add the plugin's own directory to package.path for any internal require() calls
	for _, dir_name in ipairs({ repo_name, short_name, with_prefix }) do
		local pdir = vis_dir .. "/plugins/" .. dir_name
		package.path = pdir .. "/?.lua;" .. pdir .. "/?/init.lua;" .. package.path
	end

	local candidates = {
		repo_name,
		short_name,
		with_prefix,
		"plugins/" .. repo_name,
		"plugins/" .. repo_name .. "/init",
		"plugins/" .. repo_name .. "/" .. repo_name,
		"plugins/" .. repo_name .. "/" .. short_name,
		"plugins/" .. with_prefix .. "/init",
		"plugins/" .. with_prefix .. "/" .. short_name,
	}

	local last_err = ""
	for _, mod in ipairs(candidates) do
		local ok, res = pcall(require, mod)
		if ok then
			return res
		end
		if not tostring(res):match("not found:") then
			last_err = tostring(res)
		end
	end

	-- Direct fallback: run init.lua via dofile if present in either folder name
	for _, dir_name in ipairs({ repo_name, short_name, with_prefix }) do
		local init_file = vis_dir .. "/plugins/" .. dir_name .. "/init.lua"
		local f = io.open(init_file, "r")
		if f then
			f:close()
			local ok, res = pcall(dofile, init_file)
			if ok then
				return res
			end
			last_err = tostring(res)
		end
	end

	vis:info("Failed to load plugin: " .. repo_name .. (last_err ~= "" and (" (" .. last_err .. ")") or ""))
	return nil
end

-- 2. Register .nix filetype detection (ensures LSP and formatters recognize Nix files)
if vis.ftdetect and vis.ftdetect.filetypes then
	vis.ftdetect.filetypes.nix = {
		ext = { "%.nix$" },
	}
end

-- 3. Load UI & Navigation Plugins
--local modal = load_plugin("vis-modal")
local fzf_open = load_plugin("vis-fzf-open")
local goto_file = load_plugin("goto-file")
local vis_cmd = load_plugin("vis-command")
local autoclose = load_plugin("vis-autoclose")
local jump = load_plugin("vis-jump")
local colorizer = load_plugin("vis-colorizer")

--if fzf_open then
--  fzf_open.command = "find ~ -maxdepth 6 -not -path '*/.*' -type f"
--end

if colorizer then
	colorizer.three = false
	colorizer.six = true
end

--local mil_lexers = _G.lexers or require("lexer")
--if mil_lexers and type(mil_lexers.lexer) == "table" then
--    mil_lexers.lexer.style_define = mil_lexers.lexer.style_define or function() end
--end

-- 4. Configure LSP Support (vis-lspc)
local lspc_loaded = load_plugin("vis-lspc")
local lspc = (type(lspc_loaded) == "table" and lspc_loaded) or vis.lspc or _G.lspc

if type(lspc) == "table" then
	lspc.logging = false
	lspc.highlight_diagnostics = true
	lspc.ls_map = lspc.ls_map or {}

	-- C and C++ (vis uses 'ansi_c' for C and 'cpp' for C++)
	lspc.ls_map["ansi_c"] = { name = "clangd", cmd = "clangd" }
	lspc.ls_map["cpp"] = { name = "clangd", cmd = "clangd" }

	-- Python
	lspc.ls_map["python"] = { name = "pylsp", cmd = "pylsp" }

	-- Lua
	lspc.ls_map["lua"] = { name = "lua-language-server", cmd = "lua-language-server" }

	-- Bash / Shell
	lspc.ls_map["bash"] = { name = "bash-ls", cmd = "bash-language-server start" }

	-- Nix
	lspc.ls_map["nix"] = { name = "nil", cmd = "nil" }
end

-- 5. Configure Auto-Formatting on Save (vis-format)
local vis_format = load_plugin("vis-format")

-- Define external CLI commands that read from stdin and write formatted code to stdout
local format_cmds = {
	ansi_c = "clang-format",
	cpp = "clang-format",
	python = "ruff format -",
	lua = "stylua -",
	bash = "shfmt",
	nix = "nixfmt",
}

if vis_format and vis_format.stdio_formatter and vis_format.formatters then
	-- Register with milhnl/vis-format if its stdio_formatter API is present
	for lang, cmd in pairs(format_cmds) do
		vis_format.formatters[lang] = vis_format.stdio_formatter(cmd)
	end
else
	-- Direct fallback hook on FILE_SAVE_PRE using vis:pipe
	vis.events.subscribe(vis.events.FILE_SAVE_PRE, function(file, path)
		local win = vis.win
		if not win or win.file ~= file then
			return true
		end
		local cmd = format_cmds[win.syntax]
		if not cmd then
			return true
		end

		local pos = win.selection.pos
		local status, out, err = vis:pipe(file, { start = 0, finish = file.size }, cmd)
		if status == 0 and out then
			file:delete(0, file.size)
			file:insert(0, out)
			win.selection.pos = math.min(pos or 0, file.size)
		elseif err then
			vis:info("Format error (" .. cmd .. "): " .. err)
		end
		return true
	end)
end

-- 6. Editor & Keybinding Configuration
vis.events.subscribe(vis.events.INIT, function()
	-- Map Space+f to open files via vis-fzf-open (notice the literal space inside " f")
	vis:map(vis.modes.NORMAL, " f", function()
		vis:command("fzf")
	end, "Fuzzy find files")

	-- Map Space+lf to manually format the current buffer using your format_cmds table
	vis:map(vis.modes.NORMAL, " lf", function()
		local win = vis.win
		if not win or not win.file then
			vis:info("No active file to format")
			return
		end

		local syntax = win.syntax
		local cmd = format_cmds[syntax]

		if not cmd then
			vis:info("No formatter configured for filetype: " .. tostring(syntax))
			return
		end

		local file = win.file
		local pos = win.selection.pos
		local status, out, err = vis:pipe(file, { start = 0, finish = file.size }, cmd)

		if status == 0 and out then
			file:delete(0, file.size)
			file:insert(0, out)
			win.selection.pos = math.min(pos or 0, file.size)
			vis:info("Formatted with " .. cmd)
		else
			vis:info("Format error (" .. cmd .. "): " .. (err or "unknown error"))
		end
	end, "Format buffer manually")

    -- File Explorer
	vis:map(vis.modes.NORMAL, " e", function()
		vis:command("open .")
		vis:feedkeys("<C-w>k")
		vis:command("wq!")
	end, "")
    vis:map(vis.modes.VISUAL, " y", function()
        vis:feedkeys('"+y')
    end, "Yank to clipboard")

    -- Map 'jk' in insert mode to switch back to normal mode
    vis:map(vis.modes.INSERT, "jk", function()
        vis:feedkeys("<Escape>")
    end, "Exit Insert Mode with jk")
	vis:map(vis.modes.NORMAL, " vf", function()
		vis:command("open ~/.dotfiles/vis/visrc.lua")
		vis:feedkeys("<C-w>k")
		vis:command("wq!")
	end, "")

    -- Paste below from system clipboard
    vis:map(vis.modes.NORMAL, " p", function()
        vis:feedkeys('"+p')
    end, "Paste below from clipboard")

    -- Paste above from system clipboard
    vis:map(vis.modes.NORMAL, " P", function()
        vis:feedkeys('"+P')
    end, "Paste above from clipboard")
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command("set numbers on")
	vis:command("set autoindent on")
	vis:command("set tabwidth 2")
	vis:command("set expandtab on")
end)
