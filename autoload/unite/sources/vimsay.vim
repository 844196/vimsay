" このスクリプトは@supermomonga氏のunite-sudden-deathの文字カウント処理をベースにしている
" 以下、オリジナルのライセンス表記
" sudden-death source for unite.vim
" Version:     0.0.1
" Last Change: 27 Dec 2012
" Author:      momonga
" Licence:     The MIT License {{{
"     Permission is hereby granted, free of charge, to any person obtaining a copy
"     of this software and associated documentation files (the "Software"), to deal
"     in the Software without restriction, including without limitation the rights
"     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
"     copies of the Software, and to permit persons to whom the Software is
"     furnished to do so, subject to the following conditions:
"
"     The above copyright notice and this permission notice shall be included in
"     all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
"     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
"     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
"     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
"     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
"     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
"     THE SOFTWARE.
" }}}

function! unite#sources#vimsay#define()
  return s:source
endfunction

let s:source = {"name" : "vimsay"}

function! s:str_to_mb_width(str)
  return strlen(substitute(substitute(a:str, "[ -~｡-ﾟ]", 's', 'g'), "[^s]", 'mm', 'g')) / 2
endfunction

function! s:get_cowfile(path)
    let s:tmp = readfile(a:path)

    let s:cowfile_start = match(s:tmp, '\$the_cow')
    let s:cowfile_end = match(s:tmp, '^EOC')

    let s:r = []
    for s:line in s:tmp[s:cowfile_start + 1 : s:cowfile_end - 1]
        call add(s:r, substitute(s:line, '\\\', '\\', 'g'))
    endfor

    return s:r
endfunction

function! s:set_balloon(cowfile)
    let s:r = []
    for s:line in a:cowfile
        call add(s:r, substitute(s:line, '\$thoughts', '\\', 'g'))
    endfor

    return s:r
endfunction

function! s:set_eyes(cowfile)
    let s:r = []
    for s:line in a:cowfile
        call add(s:r, substitute(s:line, '\$eyes', 'oo', 'g'))
    endfor

    return s:r
endfunction

function! s:set_tongue(cowfile)
    let s:r = []
    for s:line in a:cowfile
        call add(s:r, substitute(s:line, '\$tongue', '  ', 'g'))
    endfor

    return s:r
endfunction

function! s:vimsay(str, cowpath)
  let width = s:str_to_mb_width(a:str) + 2
  let top = ' ' . join(map(range(width), '"__"'),'')
  let content = '<  ' . a:str . '  >'
  let bottom = ' ' . join(map(range(width), '"--"'),'')

  let cow = join(s:set_tongue(s:set_eyes(s:set_balloon(s:get_cowfile(a:cowpath[0])))), "\n")

  return join([top, content, bottom, cow], "\n")
endfunction

function! s:source.change_candidates(args, context)
  let list = [{
        \"word" : s:vimsay(a:context.input, a:args),
        \"is_multiline" : 1,
        \"kind" : "word",
        \}]

  return list
endfunction
