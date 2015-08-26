# Edit commonly accessed but annoying to type files
alias h="vim /etc/hosts"
alias vimrc="vim ~/.vimrc"
alias vimal="vim ~/.bash_aliases"
alias sal="source ~/.bash_aliases"

# Shortcuts for damn DS_Store files
alias rmdss="find . -name '*.DS_Store' -type f -delete"

# Shortcuts for listing
alias l='ls -lahrSAG'
alias la='ls -laG'

# Git shortcuts outside of gitsh
alias gits="git status"
alias gitlog="git --no-pager  console.log -n 20 --pretty=format:%h%x09%an%x09%ad%x09%s --date=short --no-merges"

# Misc aliases
alias connecto="nc -vz" # host port
alias difftwodirs="find dir1 dir2 -type f -exec md5 {} \; | awk '{print $4}' | uniq -u"
alias en="vim /usr/local/etc/nginx/nginx.conf"
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say cache flushed"
alias getactiveinterface="ifconfig | grep \": active\" -B10 | grep \"en\d: flags\" | grep \"en\d\" -o"
alias fixtunnelblick="activeinterface=`getactiveinterface`; sudo ifconfig \$activeinterface down; flushdns; sudo ifconfig \$activeinterface up"
alias getports="sudo lsof -i -n -P | grep TCP"
alias listlocalservers="lsof -Pni4 | grep LISTEN | grep php"
alias m="meteor"
alias madd="meteor add"
alias mr="clear;meteor reset; meteor"
alias mrm="meteor remove"
alias mver="meteor --verbose"
alias rgo="rails s -d"
alias rn="sudo nginx -s reload"
alias rstop="kill -INT \$(cat tmp/pids/server.pid)"
alias rsync="/usr/local/bin/rsync"
alias sc="vim ~/.ssh/config"
alias search="grep . * -rsl | grep "
alias searchd="ls -laR | grep "
alias tl="tail -f /var/log/nginx/*"
alias tle="tail -f /var/log/nginx/*error*"
alias v="vagrant"
alias vs="v ssh"
