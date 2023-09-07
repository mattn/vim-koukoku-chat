scriptencoding utf-8

function! s:get_channel() abort
  if !exists('s:job') || job_status(s:job) !=# 'run'
    let s:job = job_start('koukoku-chat', {'noblock': 1})
    let s:ch = job_getchannel(s:job)
    call ch_setoptions(s:ch, {'out_cb': function('s:koukokuchat_cb_out'), 'err_cb': function('s:koukokuchat_cb_err')})
  endif
  return s:ch
endfunction

function! s:koukokuchat_cb_out(ch, msg) abort
  let l:winid = bufwinid('__電子公告チャット__')
  if l:winid ==# -1
    silent noautocmd split __電子公告チャット__
    setlocal buftype=nofile bufhidden=wipe noswapfile
    setlocal wrap nonumber signcolumn=no filetype=markdown
    wincmd p
    let l:winid = bufwinid('__電子公告チャット__')
  endif
  call win_execute(l:winid, 'setlocal modifiable', 1)
  call win_execute(l:winid, 'normal! G', 1)
  call win_execute(l:winid, 'call append(line("$"), a:msg)', 1)
  call win_execute(l:winid, 'setlocal nomodifiable nomodified', 1)
endfunction

function! s:koukokuchat_cb_err(ch, msg) abort
  echohl ErrorMsg | echom '[koukokuchat] ' .. a:msg | echohl None
endfunction

function! koukokuchat#show(text) abort
  let l:ch = s:get_channel()
  if len(a:text) > 0
    call ch_sendraw(l:ch, a:text .. "\n")
  endif
endfunction
