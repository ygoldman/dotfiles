Why?
---- 
Because Nonrational (https://github.com/nonrational) showed me the way... and because storing cross-machine config is cumbersome. Installing Git is &mdash; for the most part &mdash; easy.

Making it Work
--------
Getting Started:

    git clone https://github.com/nonrational/dotfiles ~/.dotfiles && cd ~/.dotfiles
    ./pu.sh
    
Alternatively (requires wget but not git):

    wget https://github.com/ygolmdan/dotfiles/archive/master.zip && unzip master && rm master
    mv dotfiles-master .dotfiles && cd .dotfiles
    ./pu.sh
    
Arguments to pu.sh:
* -f : Delete all files WITHOUT ASKING YOU before symlinking in the new ones.
* -r : Apply root@host rules. Don't do this on shared systems unless you can beat up everyone else in `finger`

