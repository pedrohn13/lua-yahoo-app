
--- Change word
function replaceString(word)

    word = word:gsub("á", "a")
    word = word:gsub("é", "e")
    word = word:gsub("í", "i")
    word = word:gsub("õ", "o")
    word = word:gsub("ó", "o")
    word = word:gsub("ú", "u")
    word = word:gsub("ã", "a")
    word = word:gsub("¢", "c")
    word = word:gsub("ç", "c")
    word = word:gsub("â", "a")
    word = word:gsub("ê", "e")
    word = word:gsub("î", "i")
    word = word:gsub("ô", "o")
    word = word:gsub("û", "u")
    word = word:gsub("à", "a")
    word = word:gsub("É", "E")
    word = word:gsub("Í", "I")
    word = word:gsub("Ó", "O")
    word = word:gsub("Ú", "U")
    word = word:gsub("Â", "A")
    word = word:gsub("Ê", "E")
    word = word:gsub("Á", "A")
    word = word:gsub("Ô", "O")
    word = word:gsub("Û", "U")
    word = word:gsub("ñ", "n")
    word = word:gsub("Ñ", "N")
   
    return word
end

--- Compare word
function stringComparator(word1, word2)
    local comp1 = replaceString(word1)
    local comp2 = replaceString(word2)
       return comp1 <= comp2
end
