" Adding .pbxproj syntax detection
augroup filetype
  au! BufRead,BufNewFile *.pbxproj setfiletype pbxproj
augroup end

