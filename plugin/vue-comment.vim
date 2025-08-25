" Vue Smart Comment Plugin
" Description: A vim plugin to intelligently comment Vue.js files based on cursor position
" Author: Your Name
" Version: 1.0

if exists('g:loaded_vue_comment')
    finish
endif
let g:loaded_vue_comment = 1

" 检测当前光标所在的Vue文件区块类型
function! GetVueSection()
    let l:current_line = line('.')
    let l:total_lines = line('$')
    
    " 查找光标前最近的开始标签
    let l:template_start = search('<template', 'bnW')
    let l:script_start = search('<script', 'bnW')
    let l:style_start = search('<style', 'bnW')
    
    " 查找对应的结束标签
    let l:template_end = search('</template>', 'nW')
    let l:script_end = search('</script>', 'nW')
    let l:style_end = search('</style>', 'nW')
    
    " 判断当前光标位置
    if l:template_start > 0 && l:current_line > l:template_start && l:current_line < l:template_end
        return 'template'
    elseif l:script_start > 0 && l:current_line > l:script_start && l:current_line < l:script_end
        return 'script'
    elseif l:style_start > 0 && l:current_line > l:style_start && l:current_line < l:style_end
        return 'style'
    else
        return 'unknown'
    endif
endfunction

" HTML注释函数（用于template部分）
function! ToggleHtmlComment()
    let l:line = getline('.')
    let l:line_number = line('.')
    
    " 检查是否已经被注释
    if l:line =~ '^\s*<!--.*-->\s*$'
        " 移除注释，保持原始缩进
        let l:indent = matchstr(l:line, '^\s*')
        let l:content = substitute(l:line, '^\s*<!--\s*', '', '')
        let l:content = substitute(l:content, '\s*-->\s*$', '', '')
        let l:new_line = l:indent . l:content
        call setline(l:line_number, l:new_line)
    else
        " 添加注释
        let l:indent = matchstr(l:line, '^\s*')
        let l:content = substitute(l:line, '^\s*', '', '')
        if l:content !~ '^\s*$'
            let l:new_line = l:indent . '<!-- ' . l:content . ' -->'
            call setline(l:line_number, l:new_line)
        endif
    endif
endfunction

" JavaScript注释函数（用于script部分）
function! ToggleJsComment()
    let l:line = getline('.')
    let l:line_number = line('.')
    
    " 检查是否已经被注释
    if l:line =~ '^\s*//\s*'
        " 移除注释，保持原始缩进
        let l:indent = matchstr(l:line, '^\s*')
        let l:content = substitute(l:line, '^\s*//\s*', '', '')
        let l:new_line = l:indent . l:content
        call setline(l:line_number, l:new_line)
    else
        " 添加注释
        let l:indent = matchstr(l:line, '^\s*')
        let l:content = substitute(l:line, '^\s*', '', '')
        if l:content !~ '^\s*$'
            let l:new_line = l:indent . '// ' . l:content
            call setline(l:line_number, l:new_line)
        endif
    endif
endfunction

" CSS注释函数（用于style部分）
function! ToggleCssComment()
    let l:line = getline('.')
    let l:line_number = line('.')
    
    " 检查是否已经被注释
    if l:line =~ '^\s*/\*.*\*/\s*$'
        " 移除注释，保持原始缩进
        let l:indent = matchstr(l:line, '^\s*')
        let l:content = substitute(l:line, '^\s*/\*\s*', '', '')
        let l:content = substitute(l:content, '\s*\*/\s*$', '', '')
        let l:new_line = l:indent . l:content
        call setline(l:line_number, l:new_line)
    else
        " 添加注释
        let l:indent = matchstr(l:line, '^\s*')
        let l:content = substitute(l:line, '^\s*', '', '')
        if l:content !~ '^\s*$'
            let l:new_line = l:indent . '/* ' . l:content . ' */'
            call setline(l:line_number, l:new_line)
        endif
    endif
endfunction

" 主要的智能注释函数
function! VueSmartComment()
    let l:section = GetVueSection()
    
    if l:section == 'template'
        call ToggleHtmlComment()
    elseif l:section == 'script'
        call ToggleJsComment()
    elseif l:section == 'style'
        call ToggleCssComment()
    else
        echo "无法确定当前位置的Vue文件区块类型"
    endif
endfunction

" 创建命令
command! VueComment call VueSmartComment()

" 键盘映射 - 使用 gcc 来触发智能注释
autocmd FileType vue nnoremap <buffer> gcc :call VueSmartComment()<CR>
autocmd FileType vue vnoremap <buffer> gcc :call VueSmartComment()<CR>

" Plugin loaded silently