vim9script

def UnicodeLength(str: string): number
    # This should be fine
    return len(split(str, '\zs'))
enddef

def GetUnicodeCharAt(str: string, position: number): string
    if str == ""
        return ""
    endif
    let nr = strgetchar(str, position)
    if l:nr == -1
        return ""
    else
        return nr2char(nr)
    endif
enddef

