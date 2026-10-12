#!/bin/zsh

# NOTE: keeping the below for bookkeeping purposes
# client_pid=$(tmux display-message -p '#{client_pid}')
# ssh_check=$(pstree -s $client_pid | grep sshd &> /dev/null)
# ssh_connected=$?

# get tty of the current tmux client (not pane)
client_pty=$(tmux display-message -p '#{client_tty}')
# strip "/dev/" prefix
stripped_pty=${client_pty:5}
# check who is controlling the tty
who_pty=$(who | grep $stripped_pty)
# grab remote ip in brackets
remote_ip=$(echo $who_pty| awk -F'[()]' '{print $2}')

if [[ -n $remote_ip ]]; then
    echo -n "#[fg=#{@nordic_gray4},bg=#{@nordic_black0},nobold]$client_pty"
    case $remote_ip in
        192.168.86.1)
            # WARN: edge case for connecting via router forwarded port while using local exit node
            echo -n "#[fg=#{@nordic_yellow},bg=#{@nordic_black0},nobold] [tailnet] "
            echo "#[fg=#{@nordic_black0},bg=#{@nordic_yellow},bold] Google WiFi "
            ;;
        # connected over LAN
        192.168.86.*)
            # query mDNS for IP
            remote_name=$(dig +short -x $remote_ip @224.0.0.251 -p 5353)
            remote_name_base=${remote_name%%.*}
            echo -n "#[fg=#{@host_color},bg=#{@nordic_black0},nobold] [lan] "
            echo "#[fg=#{@nordic_black0},bg=#{@host_color},bold] $remote_name_base "
            ;;
        # connected over tailscale
        100.64.0.*|fd7a:115c:a1e0::*)
            remote_name=$(tailscale whois --json $remote_ip | jq -r .Node.Name)
            remote_name_base=${remote_name%%.*}
            echo -n "#[fg=#{@host_color},bg=#{@nordic_black0},nobold] [tailnet] "
            echo "#[fg=#{@nordic_black0},bg=#{@host_color},bold] $remote_name_base "
            ;;
        *)
            # WARN: unknown connection
            echo -n "#[fg=#{@nordic_red_bright},bg=#{@nordic_black0},nobold] [nodns] "
            echo "#[fg=#{@nordic_black0},bg=#{@nordic_red_bright},bold] $remote_ip "
            ;;
    esac
else
    (exit 1)
fi
