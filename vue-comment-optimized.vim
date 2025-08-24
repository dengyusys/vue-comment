" Vue Smart Comment Plugin - Optimized Version
" Performance improvements for large files

if exists('g:loaded_vue_comment')
    finish
endif
let g:loaded_vue_comment = 1

" 缓存变量
let s:last_line = -1
let s:last_section = ''
let s:section_cache = {}

" 优化的区块检测函数
function! GetVueSection()
    let l:current_line = line('.')
    
    " 如果光标在同一行，直接返回缓存结果
    if l:current_line == s:last_line && s:last_section != ''
        return s:last_section
    endif
    
    " 限制搜索范围，避免大文件性能问题
    let l:search_start = max([1, l:current_line - 500])
    let l:search_end = min([line('$'), l:current_line + 500])
    
    " 在限定范围内搜索
    let l:save_pos = getpos('.')
    
    " 向上搜索最近的开始标签（限制范围）
    call cursor(l:current_line, 1)
    let l:template_start = search('<template', 'bnW', l:search_start)
    let l:script_start = search('<script', 'bnW', l:search_start)
    let l:style_start = search('<style', 'bnW', l:search_start)
    
    " 向下搜索对应的结束标签
    call cursor(l:current_line, 1)
    let l:template_end = search('</template>', 'nW', l:search_end)
    let l:script_end = search('</script>', 'nW', l:search_end)
    let l:style_end = search('</style>', 'nW', l:search_end)
    
    " 恢复光标位置
    call setpos('.', l:save_pos)
    
    " 判断当前光标位置
    let l:section = 'unknown'
    if l:template_start > 0 && l:current_line > l:template_start && 
        \ (l:template_end == 0 || l:current_line < l:template_end)
        let l:section = 'template'
    elseif l:script_start > 0 && l:current_line > l:script_start && 
        \ (l:script_end == 0 || l:current_line < l:script_end)
        let l:section = 'script'
    elseif l:style_start > 0 && l:current_line > l:style_start && 
        \ (l:style_end == 0 || l:current_line < l:style_end)
        let l:section = 'style'
    endif
    
    " 缓存结果
    let s:last_line = l:current_line
    let s:last_section = l:section
    
    return l:section
endfunction

" 优化的注释函数 - 减少重复操作
function! ToggleComment(comment_start, comment_end)
    let l:line = getline('.')
    let l:line_number = line('.')
    let l:indent = matchstr(l:line, '^\s*')
    let l:content = substitute(l:line, '^\s*', '', '')
    
    " 跳过空行
    if l:content =~ '^\s*$'
        return
    endif
    
    " 构建注释检测模式
    if a:comment_end == ''
        " 单行注释 (JS)
        let l:comment_pattern = '^\s*' . escape(a:comment_start, '/\*') . '\s*'
        if l:line =~ l:comment_pattern
            " 移除注释
            let l:new_content = substitute(l:content, '^' . escape(a:comment_start, '/\*') . '\s*', '', '')
            let l:new_line = l:indent . l:new_content
        else
            " 添加注释
            let l:new_line = l:indent . a:comment_start . ' ' . l:content
        endif
    else
        " 块注释 (HTML/CSS)
        let l:start_pattern = '^\s*' . escape(a:comment_start, '/\*') . '\s*'
        let l:end_pattern = '\s*' . escape(a:comment_end, '/\*') . '\s*$'
        if l:line =~ l:start_pattern . '.*' . l:end_pattern
            " 移除注释
            let l:temp = substitute(l:content, '^' . escape(a:comment_start, '/\*') . '\s*', '', '')
            let l:new_content = substitute(l:temp, '\s*' . escape(a:comment_end, '/\*') . '\s*$', '', '')
            let l:new_line = l:indent . l:new_content
        else
            " 添加注释
            let l:new_line = l:indent . a:comment_start . ' ' . l:content . ' ' . a:comment_end
        endif
    endif
    
    call setline(l:line_number, l:new_line)
endfunction

" 主要的智能注释函数
function! VueSmartComment()
    let l:section = GetVueSection()
    
    if l:section == 'template'
        call ToggleComment('<!--', '-->')
    elseif l:section == 'script'
        call ToggleComment('//', '')
    elseif l:section == 'style'
        call ToggleComment('/*', '*/')
    else
        echo "无法确定当前位置的Vue文件区块类型"
    endif
endfunction

" 清除缓存的函数（当文件内容改变时）
function! ClearVueSectionCache()
    let s:last_line = -1
    let s:last_section = ''
endfunction

" 创建命令
command! VueComment call VueSmartComment()

" 键盘映射 - 使用 gcc 来触发智能注释
autocmd FileType vue nnoremap <buffer> gcc :call VueSmartComment()<CR>
autocmd FileType vue vnoremap <buffer> gcc :call VueSmartComment()<CR>

" 当文件内容改变时清除缓存
autocmd FileType vue autocmd TextChanged,TextChangedI <buffer> call ClearVueSectionCache()

" Plugin loaded silently