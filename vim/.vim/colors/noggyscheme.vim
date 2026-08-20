" ~/.vim/colors/noggyscheme.vim

" Enable true color support
set termguicolors

" Reset any existing highlights
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "noggyscheme"

" ==========================================
" PALETTE 
" ==========================================
" foreground       = "#B0C4DE"
" background       = "#161D27"
" subtle_base      = "#63778D"
" subtle_darker    = "#1E2732"
" accent_base      = "#4DB6AC"
" accent_dark      = "#15485E"
" accent_darker    = "#0F3A4B"
" secondary_base   = "#F07178"
" secondary_bright = "#F48FB1"
" secondary_dark   = "#3B131D"
" special_base     = "#FF5370"
" yellow_base      = "#FFCB6B"
" positive_bright  = "#C3E88D"

" ==========================================
" SYNTAX HIGHLIGHTS
" ==========================================
hi Normal guifg=#B0C4DE guibg=#161D27
hi Comment guifg=#63778D gui=italic

" Neon Teal mappings (Properties, Identifiers, Tags)
hi Identifier guifg=#4DB6AC
hi Type guifg=#4DB6AC

" Salmon Pink mappings (Keywords, Functions, Operators)
hi Keyword guifg=#F07178 gui=bold
hi Statement guifg=#F07178
hi Operator guifg=#F07178
hi Function guifg=#F07178

" Plain Text / Values (Dusty Cyan/White)
hi String guifg=#B0C4DE
hi Number guifg=#B0C4DE
hi Boolean guifg=#F07178

" ==========================================
" UI ELEMENTS
" ==========================================
" Top Tabline
hi TabLineFill guifg=#4DB6AC guibg=NONE
hi TabLine guifg=#B0C4DE guibg=#1E2732
hi TabLineSel guifg=#000000 guibg=#4DB6AC gui=bold

" Editor UI
hi Cursor guifg=#161D27 guibg=#B0C4DE
hi CursorLine guibg=#3B131D
hi MatchParen guibg=#0F3A4B gui=bold

hi SignColumn guibg=NONE
hi LineNr guifg=#63778D
hi CursorLineNr guifg=#F07178 gui=bold

hi Visual guibg=#15485E

" Popups and Menus
hi Pmenu guifg=#B0C4DE guibg=#1E2732
hi PmenuSbar guibg=#161D27
hi PmenuSel guifg=#000000 guibg=#4DB6AC
hi NormalFloat guibg=#1E2732
hi FloatBorder guifg=#4DB6AC guibg=#1E2732

" ==========================================
" TREE-SITTER SPECIFIC 
" ==========================================
"hi @property guifg=#4DB6AC
"hi @tag guifg=#4DB6AC
"hi @tag.attribute guifg=#4DB6AC
"hi @variable guifg=#4DB6AC
"
"hi @keyword guifg=#F07178 gui=bold
"hi @keyword.modifier guifg=#F07178 gui=italic
"hi @function guifg=#F07178
"hi @punctuation.special guifg=#F07178
"
"hi @string.escape guifg=#FF5370

" ==========================================
" DIAGNOSTICS
" ==========================================
hi DiagnosticError guifg=#FF5370
hi DiagnosticWarn guifg=#FFCB6B
hi DiagnosticInfo guifg=#4DB6AC
hi DiagnosticHint guifg=#B0C4DE

hi DiagnosticUnderlineError guisp=#FF5370 gui=undercurl
hi DiagnosticUnderlineWarn guisp=#FFCB6B gui=undercurl
hi DiagnosticUnderlineInfo guisp=#4DB6AC gui=undercurl
hi DiagnosticUnderlineHint guisp=#B0C4DE gui=undercurl
