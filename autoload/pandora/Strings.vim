vim9script

def pandora#Strings#unicodeLength(str: string): number
    # This should be fine
    return len(split(str, '\zs'))
enddef

def pandora#Strings#getUnicodeCharAt(str: string, position: number): string
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

