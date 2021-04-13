vim9script

if !exists('g:PandoraNoteLocations')
    g:PandoraNoteLocations = {
        'Notes': { 'location': $HOME .. '/.pandora-vim', 'hidden': 0 }
    }
endif

def pandora#GenericStart()
    var queryString = ""
    var counter = 1
    for [name, data] in items(g:PandoraNoteLocations)
        if data['hidden'] == 0
            queryString ..= counter .. ". " .. name .. "(" .. data['location'] .. ")"
        endif
        counter += 1
    endfor

    # TODO: popup dialog along the lines of NERDTree.
    # Might need to use a list instead of a string though. iDunno.
    # Figure it out

enddef

def pandora#FollowLink()
    # TODO: follow links
enddef

def pandora#InitMarkdown()
    nnoremap pdfl :call pandora#FollowLink()<CR>
enddef


