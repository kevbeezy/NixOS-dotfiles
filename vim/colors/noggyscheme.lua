-- ~/.config/nvim/colors/noggyscheme.lua

-- Enable true color support
vim.opt.termguicolors = true

-- Reset any existing highlights
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "noggyscheme"

-- ==========================================
-- PALETTE (Extracted from image_2aaf84.jpg)
-- ==========================================
local colors = {
  foreground       = "#B0C4DE", -- Light dusty cyan/grey (Numbers, plain text)
  background       = "#161D27", -- Fallback dark bg (Will be overridden by your transparency script)

  subtle_base      = "#63778D", -- Comments (Grey/Blue)
  subtle_darker    = "#1E2732", -- Gutter/Line numbers background

  accent_base      = "#4DB6AC", -- Neon Teal (Properties, tags, active tab)
  accent_dark      = "#15485E", -- Deep Teal (Visual selection background)
  accent_darker    = "#0F3A4B",

  secondary_base   = "#F07178", -- Salmon Pink (!important, functions, interpolations)
  secondary_bright = "#F48FB1",
  secondary_dark   = "#3B131D", -- Deep Burgundy (Cursorline background on line 80)

  special_base     = "#FF5370", -- Bright Red/Pink for errors

  yellow_base      = "#FFCB6B", -- Warnings
  positive_bright  = "#C3E88D", -- Additions
}

-- Helper function to set highlights
local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ==========================================
-- SYNTAX & TREESITTER
-- ==========================================
hl("Normal", { fg = colors.foreground })
hl("Comment", { fg = colors.subtle_base, italic = true })

-- Neon Teal mappings (Properties, Identifiers, Tags)
hl("Identifier", { fg = colors.accent_base })
hl("Type", { fg = colors.accent_base })
hl("@property", { fg = colors.accent_base })
hl("@tag", { fg = colors.accent_base })
hl("@tag.attribute", { fg = colors.accent_base })
hl("@variable", { fg = colors.accent_base })

-- Salmon Pink mappings (Keywords, Functions, Operators)
hl("Keyword", { fg = colors.secondary_base, bold = true })
hl("Statement", { fg = colors.secondary_base })
hl("Operator", { fg = colors.secondary_base })
hl("Function", { fg = colors.secondary_base })
hl("@keyword", { fg = colors.secondary_base, bold = true })
hl("@keyword.modifier", { fg = colors.secondary_base, italic = true }) -- for things like !important
hl("@function", { fg = colors.secondary_base })
hl("@punctuation.special", { fg = colors.secondary_base }) -- for ${} interpolations

-- Plain Text / Values (Dusty Cyan/White)
hl("String", { fg = colors.foreground })
hl("Number", { fg = colors.foreground })
hl("Boolean", { fg = colors.secondary_base }) -- Booleans look good matching the pink keywords
hl("@string.escape", { fg = colors.special_base })

-- ==========================================
-- UI ELEMENTS
-- ==========================================
-- Top Tabline (Matches the 'userChrome.nix' tab in the top left)
hl("TabLineFill", { fg = colors.accent_base, bg = "NONE" })
hl("TabLine", { fg = colors.foreground, bg = colors.subtle_darker })
hl("TabLineSel", { fg = "#000000", bg = colors.accent_base, bold = true })

-- Editor UI
hl("Cursor", { fg = colors.background, bg = colors.foreground })
hl("CursorLine", { bg = colors.secondary_dark }) -- The dark red line 80 highlight
hl("MatchParen", { bg = colors.accent_darker, bold = true })

hl("SignColumn", { bg = "NONE" })
hl("LineNr", { fg = colors.subtle_base })
hl("CursorLineNr", { fg = colors.secondary_base, bold = true }) -- Pink line number for active line

hl("Visual", { bg = colors.accent_dark }) -- The deep teal selection block

-- Popups and Menus
hl("Pmenu", { fg = colors.foreground, bg = colors.subtle_darker })
hl("PmenuSbar", { bg = colors.background })
hl("PmenuSel", { fg = "#000000", bg = colors.accent_base })
hl("NormalFloat", { bg = colors.subtle_darker })
hl("FloatBorder", { fg = colors.accent_base, bg = colors.subtle_darker })

-- Diagnostics
hl("DiagnosticError", { fg = colors.special_base })
hl("DiagnosticWarn", { fg = colors.yellow_base })
hl("DiagnosticInfo", { fg = colors.accent_base })
hl("DiagnosticHint", { fg = colors.foreground })

hl("DiagnosticUnderlineError", { sp = colors.special_base, undercurl = true })
hl("DiagnosticUnderlineWarn", { sp = colors.yellow_base, undercurl = true })
hl("DiagnosticUnderlineInfo", { sp = colors.accent_base, undercurl = true })
hl("DiagnosticUnderlineHint", { sp = colors.foreground, undercurl = true })
