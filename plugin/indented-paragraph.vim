call textobj#user#plugin('indentedparagraph', {
\   '-': {
\     'select-a-function': 'IndentedParagraphA',
\     'select-a': 'az',
\     'select-i-function': 'IndentedParagraphI',
\     'select-i': 'iz',
\   },
\ })

function! IndentedParagraphI()
	return ["V", [0, 1, 0, 0], [0, 2, 0, 0]]
endf
