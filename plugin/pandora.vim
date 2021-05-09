vim9script

if exists("g:PandoraLoaded")
    finish
endif
g:PandoraLoaded = 1

augroup PandoraInitAutocmds
    au!
    autocmd Filetype markdown call pandora#InitMarkdown()
augroup END

command! -nargs=0 PandoraList call pandora#DisplayList()

command! -nargs=? -complete=dir PandoraDirList call fzf#run(fzf#wrap({
            \ 'source': 'ag --hidden --ignore .git -g "\.md|\.markdown"',
            \ 'options': ['--layout=reverse'],
            \ 'window': {
                \ 'width': 0.7, 'height': 0.7,
                \ 'highlight': 'Expression',
                \ 'border': 'rounded'
            \ }
            \ }))

# Global mappings
nnoremap <leader>pdo :call pandora#DisplayList()<CR>

nnoremap <leader>pdd :call PandoraDirList<CR>

