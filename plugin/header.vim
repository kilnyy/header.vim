" Vim File
" AUTHOR:   Agapo (fpmarias@google.com)
" FILE:     /usr/share/vim/vim70/plugin/header.vim
" CREATED:  21:06:35 05/10/2004
" MODIFIED: 2014-03-11 13:12:09
" TITLE:    header.vim
" VERSION:  0.1.3
" SUMMARY:  When a new file is created a header is added on the top too.
"           If the file already exists, the pluging update the field 'date of
"           the last modification'.
" INSTALL:  Easy! Copy the file to vim's plugin directory (global or personal)
"           and run vim.


" FUNCTION:
" Detect filetype looking at its extension.
" VARIABLES:
" comment = Comment symbol associated with the filetype.
" type = Path to interpreter associated with file or a generic title
" when the file is not a script executable.


function s:filetype ()

  let s:file = expand("<afile>:t")
  let s:textfile = 0
  if match (s:file, "\.sh$") != -1
    let s:comment = "#"
    let s:type = [s:comment . "!/usr/bin/env bash", s:comment]
  elseif match (s:file, "\.py$") != -1
    let s:comment = "#"
    let s:type = [s:comment . "!/usr/bin/env python", s:comment . " -*- coding: utf-8 -*-"]
  elseif match (s:file, "\.vim$") != -1
    let s:comment = "\""
    let s:type = [s:comment . " Vim File", s:comment]
  else
    let s:textfile = 1
  endif
  unlet s:file

endfunction


" FUNCTION:
" Insert the header when we create a new file.
" VARIABLES:
" author = User who create the file.
" file = Path to the file.
" created = Date of the file creation.
" modified = Date of the last modification.

function s:insert ()

  call s:filetype ()

  if s:textfile == 1
    unlet s:textfile
    return
  endif 

  let s:author = s:comment . " AUTHOR:   " . "Xu Mingzhao"
  let s:created = s:comment . " CREATED:  " . strftime ("%Y-%m-%d %H:%M:%S")
  let s:modified = s:comment . " MODIFIED: " . strftime ("%Y-%m-%d %H:%M:%S")

  call append (0, s:type)
  call append (2, s:author)
  call append (3, s:created)
  call append (4, s:modified)

  unlet s:comment
  unlet s:type
  unlet s:author
  unlet s:created
  unlet s:modified

endfunction


" FUNCTION:
" Update the date of last modification.
" Check the line number 5 looking for the pattern.

function s:update ()

  call s:filetype ()
  if s:textfile == 1
    unlet s:textfile
    return
  endif

  let s:pattern = s:comment . " MODIFIED: [0-9]"
  let s:line = getline (5)

  if match (s:line, s:pattern) != -1
    let s:modified = s:comment . " MODIFIED: " . strftime ("%Y-%m-%d %H:%M:%S")
    call setline (5, s:modified)
    unlet s:modified
  endif
  
  unlet s:comment
  unlet s:pattern
  unlet s:line

endfunction


autocmd BufNewFile * call s:insert ()
autocmd BufWritePre * call s:update ()

