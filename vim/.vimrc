set rtp+=~/.vim/my-plugins/fzf.vim

" Load manpage plugin and open manpages to separate tabs
runtime ftplugin/man.vim
let g:ft_man_open_mode = 'tab'

" Set the filetype based on the file's extension, overriding any
" 'filetype' that has already been set
au BufRead,BufNewFile *.pp set filetype=python


" Options
set hlsearch
colorscheme elflord
