function! indented_paragraph#SelectI()
	return indented_paragraph#Select(v:count1, 0)
endfunction

function! indented_paragraph#SelectA()
	return indented_paragraph#Select(v:count1, 1)
endfunction

function! indented_paragraph#Select(count, include_surrounding_whitespace)
	let base = line(".")

	if match(getline(base), "^\\s*\\S") == -1
		" Line is empty (aside for whitespace), do nothing
		return 0
	endif

	let base_indentation = matchstr(getline(base), "^\\s*")
	let indented_match = "^" . base_indentation . "\\s*\\S"
	let surrounding_match = "^\\s*$"

	" First, expand from the start line to all lines in paragraph with matching indentation
	let start = s:last_matching(indented_match, base, -1)
	let end = s:last_matching(indented_match, base, 1)

	" Then, for each repeat count past 1, expand through empty lines then lines with matching
	" indentation
	for i in range(a:count - 1)
		let end = s:last_matching(surrounding_match, end, 1)
		let end = s:last_matching(indented_match, end, 1)
	endfor

	if a:include_surrounding_whitespace
		let surrounding_start = s:last_matching(surrounding_match, start, -1)
		let surrounding_end = s:last_matching(surrounding_match, end, 1)

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

function! s:limit(direction)
	if a:direction == -1
		return 1
	else
		return line("$")
	endif
endfunction

function! s:last_matching(pattern, start, direction)
	let line = a:start
	let limit = s:limit(a:direction)

	while line != limit && match(getline(line + a:direction), a:pattern) != -1
		let line += a:direction
	endwhile

	return line
endfunction

function! indented_paragraph#MoveN()
	return indented_paragraph#Move(1)
endfunction

function! indented_paragraph#MoveP()
	return indented_paragraph#Move(-1)
endfunction

function! indented_paragraph#Move(direction)
	let base = line('.')
	let limit = s:limit(a:direction)

	let paragraph_boundary = s:paragraph_boundary(base, a:direction)

	" If going backwards, attept to move to top of paragraph.
	if a:direction == -1 && paragraph_boundary != base
		return s:line_start(paragraph_boundary)
	endif

	let [base_indentation, found] = s:line_indentation(base)
	let surrounding_match = "^\\s*$"
	if found != -1
		let surrounding_match .= "\\|^" . base_indentation . "\\s\\+\\S"
	endif
	let surrounding_boundary = s:last_matching(surrounding_match, paragraph_boundary, a:direction)

	if surrounding_boundary == limit
		return s:line_start(surrounding_boundary)
	endif

	if a:direction == -1
		return s:line_start(s:paragraph_boundary(surrounding_boundary - 1, -1))
	else
		return s:line_start(surrounding_boundary + 1)
	endif
endfunction

function! s:line_start(dest)
	let contents = getline(a:dest)
	let start = match(contents, "\\S")

	if start == -1
		let start = len(contents) - 1
	endif

	return ["v", [0, a:dest, start + 1, 0], [0, a:dest, start + 1, 0]]
endfunction

function! s:line_indentation(line)
	let [indentation, found, _] = matchstrpos(getline(a:line), "^\\s*\\ze\\S")

	return [indentation, found]
endfunction

function! s:paragraph_boundary(base, direction)
	let line = a:base
	let [base_indentation, found] = s:line_indentation(a:base)

	while found == -1
		let line += a:direction
		let [base_indentation, found] = s:line_indentation(line)
	endwhile

	let same_indented_match = "^" . base_indentation . "\\S"

	return s:last_matching(same_indented_match, line, a:direction)
endfunction
