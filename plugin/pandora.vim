vim9script

if exists("g:PandoraLoaded")
    finish
endif
g:PandoraLoaded = 1

augroup PandoraInitAutocmds
    au!
    autocmd Filetype markdown call pandora#InitMarkdown()
augroup END

