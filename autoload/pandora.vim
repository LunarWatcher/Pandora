vim9script

if !exists('g:PandoraNoteLocations')
    g:PandoraNoteLocations = {
        'Notes': { 'location': $HOME .. '/.pandora-vim', 'hidden': 0 }
    }
endif

if !exists('g:PandoraAbsoluteRoot')
    g:PandoraAbsoluteRoot = ''
endif

if !exists('g:PandoraAskAboutURLIfUnsure')
    g:PandoraAskAboutURLIfUnsure = 1
endif

var targets: list<string> = []
def pandora#DisplayListCallback(id: number, result: number)
    echoerr result
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

# Takes care of opening markdown URLs
def pandora#FollowLink()
    var line = getline('.')

    # Force skip empty lines
    if line->substitute('\s+', '', 'g') == ''
        return
    endif

    var word: string = expand('<cWORD>')
    var url: string = ""
    var absUrl: number = 0

    if word =~ '\v\c\<(https?:)*//.*\>$'
        # We have an embedded URL
        url = word->substitute('\v\<|\>', '', 'g')
        absUrl = 1
    elseif word =~ '\v\c\]\((https?:)?/?/?.*\)?'
        # We have ](link
        # The last ) may be excluded if there's a space in the () for i.e. alt
        # text.
        url = word->substitute('\v(.{-}\]\(|\).*$)', '', 'g')
        if url =~ '\v^(https?:)?//'
            absUrl = 1
        endif
    elseif word =~ '\v^(https?:)?//.*$'
        # Inline URL or [key]: url
        # I think a space is required for the last one?
        url = word
        absUrl = 1
    endif

    if url != ''
        if absUrl == 1
            if has('linux')
                system('xdg-open ' .. url)
            elseif has('win32')
                # Should handle special characters (whatever that implies in
                # this context)
                system('start "" "' .. url .. '"')
            else
                echoerr 'Absolute URL provider not defined for your operating system'
            endif
        else
            if url =~ '^/'
                url = b:PandoraAbsoluteRoot .. (b:PandoraAbsoluteRoot == '' ? url[1 : ] : url)
            endif
            execute 'e ' .. url
        endif
    elseif b:PandoraAskAboutURLIfUnsure == 1
        echo 'Failed to find URL in current word. Open anyway? [y/N] '
        var input = nr2char(getchar())

        if input == 'y'
            execute 'edit ' .. word
        else
            # TODO: make this crap less awkward:
            echo 'Not opening'
        endif
    else
        echoerr 'Failed to find URL in current word'
    endif
enddef

def pandora#InitMarkdown()
    if !exists("b:PandoraAskAboutURLIfUnsure")
        b:PandoraAskAboutURLIfUnsure = g:PandoraAskAboutURLIfUnsure
    endif
    if !exists("b:PandoraAbsoluteRoot")
        b:PandoraAbsoluteRoot = g:PandoraAbsoluteRoot
    endif
    # Not sure if a prefix-based approach makes sense here.
    # Avoids conflicts at least, so that's a win
    nnoremap <silent> pdl :call pandora#FollowLink()<CR>
enddef

