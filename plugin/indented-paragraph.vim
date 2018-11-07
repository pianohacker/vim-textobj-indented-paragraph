call textobj#user#plugin('indentedparagraph', {
\   '-': {
\     'select-a-function': 'IndentedParagraphA',
\     'select-a': 'ar',
\     'select-i-function': 'IndentedParagraphI',
\     'select-i': 'ir',
\   },
\ })

function! IndentedParagraph(count, include_surrounding_whitespace)
	let base_line = line(".")

	if match(getline(base_line), "^\\s*\\S") == -1
		" Line is empty (aside for whitespace), do nothing
		return 0
	endif

	let base_indentation = matchstr(getline(base_line), "^\\s*")
	let indented_match = "^" . base_indentation . "\\s*\\S"
	let surrounding_match = "^\\s*$"

	let last_line = line("$")

	" First, expand from the start line to all lines in paragraph with matching indentation
	let start_line = s:get_last_line_matching(indented_match, base_line, 1, -1)
	let end_line = s:get_last_line_matching(indented_match, base_line, last_line, 1)

	" Then, for each repeat count past 1, expand through empty lines then lines with matching
	" indentation
	for i in range(a:count - 1)
		let end_line = s:get_last_line_matching(surrounding_match, end_line, last_line, 1)
		let end_line = s:get_last_line_matching(indented_match, end_line, last_line, 1)
	endfor

	if a:include_surrounding_whitespace
		let surrounding_start_line = s:get_last_line_matching(surrounding_match, start_line, 1, -1)
		let surrounding_end_line = s:get_last_line_matching(surrounding_match, end_line, last_line, 1)

		" Include EITHER the preceding or trailing empty lines, preferring the
		" latter.
		if surrounding_end_line == end_line
			let start_line = surrounding_start_line
		else
			let end_line = surrounding_end_line
		endif
	endif

	return ["V", [0, start_line, 0, 0], [0, end_line, 0, 0]]
endfunction

function! s:get_last_line_matching(pattern, start, limit, direction)
	let line = a:start

	while line != a:limit && match(getline(line + a:direction), a:pattern) != -1
		let line += a:direction
	endwhile

	return line
endfunction

function! IndentedParagraphI()
	return IndentedParagraph(v:count1, 0)
endfunction

function! IndentedParagraphA()
	return IndentedParagraph(v:count1, 1)
endfunction
