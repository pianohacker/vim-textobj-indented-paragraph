call textobj#user#plugin('indentedparagraph', {
\   '-': {
\     'select-a-function': 'IndentedParagraphA',
\     'select-a': 'az',
\     'select-i-function': 'IndentedParagraphI',
\     'select-i': 'iz',
\   },
\ })

function! IndentedParagraph(include_surrounding_whitespace)
	let l:base_line = line(".")

	if match(getline(l:base_line), "^\\s*\\S") == -1
		" Line is empty (aside for whitespace), do nothing
		return 0
	endif

	let l:base_indentation = matchstr(getline(l:base_line), "^\\s*")
	let l:indented_match = "^" . l:base_indentation . "\\s*\\S"
	let l:surrounding_match = "^\\(" . l:base_indentation . "\\)\\?$"

	let l:last_line = line("$")

	let l:start_line = s:get_last_line_matching(l:indented_match, l:base_line, 1, -1)
	let l:end_line = s:get_last_line_matching(l:indented_match, l:base_line, l:last_line, 1)

	if a:include_surrounding_whitespace
		let l:start_line = s:get_last_line_matching(l:surrounding_match, l:start_line, 1, -1)
		let l:end_line = s:get_last_line_matching(l:surrounding_match, l:end_line, l:last_line, 1)
	endif

	return ["V", [0, l:start_line, 0, 0], [0, l:end_line, 0, 0]]
endfunction

function! s:get_last_line_matching(pattern, start, limit, direction)
	let l:line = a:start

	while l:line != a:limit && match(getline(l:line + a:direction), a:pattern) != -1
		let l:line += a:direction
	endwhile

	return l:line
endfunction

function! IndentedParagraphI()
	return IndentedParagraph(0)
endfunction

function! IndentedParagraphA()
	return IndentedParagraph(1)
endfunction