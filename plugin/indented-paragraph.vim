call textobj#user#plugin('indentedparagraph', {
\   '-': {
\     'select-a-function': 'IndentedParagraphA',
\     'select-a': 'ar',
\     'select-i-function': 'IndentedParagraphI',
\     'select-i': 'ir',
\   },
\ })

function! IndentedParagraph(count, include_surrounding_whitespace)
	let l:base_line = line(".")

	if match(getline(l:base_line), "^\\s*\\S") == -1
		" Line is empty (aside for whitespace), do nothing
		return 0
	endif

	let l:base_indentation = matchstr(getline(l:base_line), "^\\s*")
	let l:indented_match = "^" . l:base_indentation . "\\s*\\S"
	let l:surrounding_match = "^\\s*$"

	let l:last_line = line("$")

	" First, expand from the start line to all lines in paragraph with matching indentation
	let l:start_line = s:get_last_line_matching(l:indented_match, l:base_line, 1, -1)
	let l:end_line = s:get_last_line_matching(l:indented_match, l:base_line, l:last_line, 1)

	" Then, for each repeat count past 1, expand through empty lines then lines with matching
	" indentation
	for i in range(a:count - 1)
		let l:end_line = s:get_last_line_matching(l:surrounding_match, l:end_line, l:last_line, 1)
		let l:end_line = s:get_last_line_matching(l:indented_match, l:end_line, l:last_line, 1)
	endfor

	if a:include_surrounding_whitespace
		let l:surrounding_start_line = s:get_last_line_matching(l:surrounding_match, l:start_line, 1, -1)
		let l:surrounding_end_line = s:get_last_line_matching(l:surrounding_match, l:end_line, l:last_line, 1)

		" Include EITHER the preceding or trailing empty lines, preferring the
		" latter.
		if l:surrounding_end_line == l:end_line
			let l:start_line = l:surrounding_start_line
		else
			let l:end_line = l:surrounding_end_line
		endif
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
	return IndentedParagraph(v:count1, 0)
endfunction

function! IndentedParagraphA()
	return IndentedParagraph(v:count1, 1)
endfunction
