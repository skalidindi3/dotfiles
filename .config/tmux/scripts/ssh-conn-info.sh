#!/bin/zsh

# NOTE: keeping the below for bookkeeping purposes
# client_pid=$(tmux display-message -p '#{client_pid}')
# ssh_check=$(pstree -s $client_pid | grep sshd &> /dev/null)
# ssh_connected=$?

if [[ $(uname) == Linux ]]; then
    pty_strip=5  # NOTE: to remove "/dev/" prefix from linux
else
    pty_strip=8  # NOTE: to remove "/dev/tty" prefix from macOS
fi
client_pty=$(tmux display-message -p '#{client_tty}')
remote_controls_tmux_pty_check=$(w | grep ${client_pty:$pty_strip})
remote_controls_tmux_pty=$?

if (( remote_controls_tmux_pty == 0 )); then
    remote_ip=$(echo $remote_controls_tmux_pty_check | awk '{print $3}')
    remote_name_check=$(nslookup $remote_ip | grep --color=never name)
    remote_name_exists=$?

    echo -n "#[fg=#{@nordic_gray4},bg=#{@nordic_black0},nobold]$client_pty"
    if (( remote_name_exists == 0 )); then
        remote_name_full=$(echo $remote_name_check | sed 's/.*name = //')
        remote_name_base=$(echo $remote_name_full | sed 's/\..*//')

        if echo $remote_name_full | grep -E '\.lan|\.local' &>/dev/null; then
            # connected from LAN
            echo -n "#[fg=#{@host_color},bg=#{@nordic_black0},nobold] [lan] "
            echo "#[fg=#{@nordic_black0},bg=#{@host_color},bold] $remote_name_base "
        elif echo $remote_name_full | grep -E '\.ts\.' &>/dev/null; then
            # connected over tailscale
            echo -n "#[fg=#{@host_color},bg=#{@nordic_black0},nobold] [tailnet] "
            echo "#[fg=#{@nordic_black0},bg=#{@host_color},bold] $remote_name_base "
        else
            # WARN: unknown named connection
            echo -n "#[fg=#{@nordic_red_bright},bg=#{@nordic_black0},nobold] [???] "
            echo "#[fg=#{@nordic_black0},bg=#{@nordic_red_bright},bold] $remote_name_full "
        fi
    else
        # WARN: unknown IP connected
        echo -n "#[fg=#{@nordic_red_bright},bg=#{@nordic_black0},nobold] [nodns] "
        echo "#[fg=#{@nordic_black0},bg=#{@nordic_red_bright},bold] $remote_ip "
    fi
else
    (exit 1)
fi
