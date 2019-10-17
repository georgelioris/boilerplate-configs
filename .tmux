#!/bin/sh
SESSION="$USER"
set -e

if tmux has-session -t $SESSION 2> /dev/null; then
  tmux attach -t $SESSION
  exit
fi

tmux -f $HOME/.config/tmux/.tmux.conf new-session -d -s $SESSION -n vim

# 1. Main Window
tmux send-keys -t $SESSION:vim "vim src/" Enter

# 1. Git - Node server - Tests
tmux new-window -t $SESSION -n node
tmux split-window -t $SESSION:node -h
tmux split-window -t $SESSION:node.right -v
tmux send-keys -t $SESSION:node.left "git status" Enter
tmux send-keys -t $SESSION:node.right "yarn start"
tmux send-key -t $SESSION:node.bottom-right "yarn test" Enter

# 3. Single window
tmux new-window -t $SESSION -n zsh

# Set default window
tmux select-window -t $SESSION:1

#Attach to Session
tmux attach -t $SESSION:vim.left
