-- Nix LPeg lexer for vis 0.9+
local lexer = lexer
local P, S = lpeg.P, lpeg.S

local lex = lexer.new(...)

-- Whitespace
lex:add_rule('whitespace', lex:tag(lexer.WHITESPACE, lexer.space^1))

-- Keywords
lex:add_rule('keyword', lex:tag(lexer.KEYWORD, lex:word_match(lexer.KEYWORD)))

-- Constants & Booleans
lex:add_rule('constant', lex:tag(lexer.CONSTANT_BUILTIN, lex:word_match(lexer.CONSTANT_BUILTIN)))

-- Builtin Functions
lex:add_rule('function', lex:tag(lexer.FUNCTION_BUILTIN, lex:word_match(lexer.FUNCTION_BUILTIN)))

-- Identifiers
lex:add_rule('identifier', lex:tag(lexer.IDENTIFIER, (lexer.alpha + '_') * (lexer.alnum + S("_-'"))^0))

-- Strings ("..." and ''...'')
local dq_str = lexer.range('"', true)
local ind_str = lexer.range("''", "''", false)
lex:add_rule('string', lex:tag(lexer.STRING, dq_str + ind_str))

-- Comments (# single-line and /* ... */ multi-line)
local line_comment = lexer.to_eol('#')
local block_comment = lexer.range('/*', '*/')
lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment + block_comment))

-- Numbers
lex:add_rule('number', lex:tag(lexer.NUMBER, lexer.number))

-- Operators & Punctuation
lex:add_rule('operator', lex:tag(lexer.OPERATOR, S('+-*/=<>!&|?:;.,()[]{}@')))

-- Fold points
lex:add_fold_point(lexer.OPERATOR, '{', '}')
lex:add_fold_point(lexer.OPERATOR, '[', ']')
lex:add_fold_point(lexer.COMMENT, '/*', '*/')

-- Word lists
lex:set_word_list(lexer.KEYWORD, {
  'assert', 'else', 'if', 'import', 'in', 'inherit', 'let', 'or', 'rec', 'then', 'with'
})

lex:set_word_list(lexer.CONSTANT_BUILTIN, {
  'true', 'false', 'null'
})

lex:set_word_list(lexer.FUNCTION_BUILTIN, {
  'abort', 'baseNameOf', 'builtins', 'derivation', 'dirOf', 'fetchGit',
  'fetchTarball', 'fetchurl', 'import', 'isNull', 'map', 'removeAttrs',
  'throw', 'toString'
})

return lex
