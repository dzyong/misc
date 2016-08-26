PS1="\[\e[31;49m\]\u@\h:\w\$\[\e[0m\]"

SSH_AGENT=$HOME/.myssh-agent
SSH_AGENT_START=0
if [ -z "`ps|grep /usr/bin/ssh-agent`" ];then
    ssh-agent -s > $SSH_AGENT
    SSH_AGENT_START=1
fi
source $SSH_AGENT > /dev/null
if [ $SSH_AGENT_START -eq 1 ];then
    ssh-add $HOME/.ssh/id_rsa
    ssh-add $HOME/.ssh/id_rsa_github
fi

alias vi=vim
alias ll="ls -l"
alias la="ls -a"
