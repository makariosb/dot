" Load manpage plugin and open manpages to separate tabs
runtime ftplugin/man.vim
let g:ft_man_open_mode = 'tab'

" Set the filetype based on the file's extension, overriding any
" 'filetype' that has already been set
au BufRead,BufNewFile *.pp set filetype=python


" Options
set hlsearch
set t_Co=256
set background=light
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set cindent
set cinkeys-=0#
set indentkeys-=0#

"colorscheme elflord

" Python-jedi plugin options
let g:jedi#rename_command = "<leader>R"
let g:jedi#rename_command_keep_name = ""
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#show_call_signatures = "1"
let g:jedi#popup_on_dot = 0

" Colorscheme
if (has("termguicolors"))
  set termguicolors
endif
let g:gruvbox_contrast_light = 'medium'
"let g:gruvbox_termcolors=16
autocmd vimenter * ++nested colorscheme gruvbox
set background=light

" fzf
" Initialize configuration dictionary
"let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
"let g:fzf_layout = { 'down': '80%', 'up': '100%', 'left': '50%', 'right': '50%' }
let g:fzf_layout = { 'up': '80%'}



" Mappings
map <leader>f :GFiles<CR>
map <leader>F :Files<CR>
map <leader>r :Rg!<CR>

if executable("clip.exe")
    map <leader>c :w !clip.exe<CR><CR>
endif
