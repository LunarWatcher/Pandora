vim9script

if !exists('g:PandoraNoteLocations')
    g:PandoraNoteLocations = {
        'Notes': { 'location': $HOME .. '/.pandora-vim', 'hidden': 0 }
    }
endif

if !exists('g:PandoraOpenAbsoluteRoot')
    g:PandoraOpenAbsoluteRoot = ''
endif

if !exists('g:PandoraAskAboutURLIfUnsure')
    g:PandoraAskAboutURLIfUnsure = 1
endif

var targets: list<string> = []
def pandora#DisplayListCallback(id: number, result: number)
    if targets->len() == 0
        # Fail silently
        return
    endif

enddef

def pandora#DisplayList()
    var query: list<string> = []
    var counter = 1
    for [name, data] in g:PandoraNoteLocations->items()
        if data['hidden'] == 0
            query->add(counter .. ". " .. name .. " (" .. data['location'] .. ")")
        endif
        counter += 1
    endfor

    if (query->len() == 0)
        popup_notification(["There's no (visible) note locations.", "Add some with g:PandoraNoteLocations to use this menu"], {'pos': 'center'})
        return
    endif
    # A NERDTree-style popup requires an obnoxious amount of code.
    # We're already requiring a recent version of Vim, so let's use popups
    # instead.
    query->popup_menu({
        'pos': 'center',
        'zindex': 200, 
        'drag': 0,
        'callback': 'pandora#DisplayListCallback',
        'border': [], 'highlight': 'Statement',
        'close': 'click', 'padding': [1, 1, 1, 1]
    })

enddef

def pandora#FollowLink()
    var line = getline('.')

    # Force skip emplty lines
    if line->substitute('\s+', '', 'g') == ''
        return
    endif

    var word: string = expand('<cWORD>')
    
    if word =~ '\v\c\<(https?:)*//.*\>$'
        # We have an embedded URL
        word = word->substitute('\v\<|\>', '', 'g')
    elseif word =~ '\v\c\]\((https?:)?/?/?.*\)?'
        # We have ](link
        # The last ) may be excluded if there's a space in the () for i.e. alt
        # text.
        word = word->substitute('\v(.{-}\]\(|\).*$)', '', 'g')
    endif
    echoerr word
enddef

def pandora#InitMarkdown()
    # Not sure if a prefix-based approach makes sense here.
    # Avoids conflicts at least, so that's a win
    nnoremap <silent> pdfl :call pandora#FollowLink()<CR>
enddef


