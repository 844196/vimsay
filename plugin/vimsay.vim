function! s:cmdline_completion(A, L, P)
    let s:list = map(globpath(g:vimsay_cowpath, '*', 0, 1), 'fnamemodify(v:val, ":t")')

    let s:r = []
    for s:file in s:list
        if s:file =~? '^' . a:A
            call add(s:r, s:file)
        endif
    endfor

    return s:r
endfunction

function! s:vimsay_exec(...)
    if a:0 >= 1
        let s:cowfile = a:1
    else
        let s:cowfile = 'default.cow'
    endif

    let s:path = g:vimsay_cowpath . '/' . s:cowfile
    execute 'Unite' 'vimsay:' . s:path '-max-multi-lines=100'
endfunction

command! -nargs=* -complete=customlist,s:cmdline_completion Vimsay call s:vimsay_exec(<f-args>)
