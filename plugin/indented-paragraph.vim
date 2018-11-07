call textobj#user#plugin('indentedparagraph', {
\   '-': {
\     'select-a-function': 'IndentedParagraphA',
\     'select-a': 'ar',
\     'select-i-function': 'IndentedParagraphI',
\     'select-i': 'ir',
\   },
\ })

function! IndentedParagraph(count, include_surrounding_whitespace)
	let base = line(".")

	if match(getline(base), "^\\s*\\S") == -1
		" Line is empty (aside for whitespace), do nothing
		return 0
	endif

	let base_indentation = matchstr(getline(base), "^\\s*")
	let indented_match = "^" . base_indentation . "\\s*\\S"
	let surrounding_match = "^\\s*$"

	let last = line("$")

	" First, expand from the start line to all lines in paragraph with matching indentation
	let start = s:last_matching(indented_match, base, 1, -1)
	let end = s:last_matching(indented_match, base, last, 1)

	" Then, for each repeat count past 1, expand through empty lines then lines with matching
	" indentation
	for i in range(a:count - 1)
		let end = s:last_matching(surrounding_match, end, last, 1)
		let end = s:last_matching(indented_match, end, last, 1)
	endfor

	if a:include_surrounding_whitespace
		let surrounding_start = s:last_matching(surrounding_match, start, 1, -1)
		let surrounding_end = s:last_matching(surrounding_match, end, last, 1)

		" Include EITHER the preceding or trailing empty lines, preferring the
		" latter.
		if surrounding_end == end
			let start = surrounding_start
		else
			let end = surrounding_end
		endif
	endif

	return ["V", [0, start, 0, 0], [0, end, 0, 0]]
endfunction

function! s:last_matching(pattern, start, limit, direction)
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
