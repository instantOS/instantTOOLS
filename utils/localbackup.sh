#!/bin/bash

# doc: create a local backup of all instantOS repos

if iconf backuplocation; then
    BTARGET="$(iconf backuplocation)"
else
    BTARGET="$HOME/instantosbackup"
fi

if ! [ -e "$BTARGET" ]; then
    echo "creating new backup target"
    mkdir "$BTARGET"
    cd "$BTARGET" || exit 1
    echo 'This is a static backup of the instantOS source code, please do not touch' >README.txt
else
    cd "$BTARGET" || exit 1
fi

REPOLIST="$(
    curl -s "https://api.github.com/users/instantOS/repos?per_page=100" | grep -o 'git@github.com:instantOS.*' |
        sed 's/",$//g' | sed 's/^.*://g' | sed 's/.git$//g' | grep -o '[^/]*$'
)"

REPOCOUNT="$(echo "$REPOLIST" | wc -l)"

if ! [ "$REPOCOUNT" -gt 20 ]; then
    echo "there's something wrong with github, couldn't get all repos"
    exit 1
fi

echo "Backing up repos:
$REPOLIST"

ERRORNAME="$(date).txt"

export ERRORNAME
repoerror() {
    echo "$p" >>../error/"$ERRORNAME"
    echo "error while processing $p"
    exit 1
}

while read -r p; do
    echo "processing repo $p"
    {
        if [ -e "./$p" ]; then
            echo "updating repo $p"
            if [ -e ./error/"$ERRORNAME" ]; then
                echo "detected error"
                cat ./error/"$ERRORNAME"
                exit 1
            fi
            cd "$p" || repoerror
            git fetch --all || repoerror
            git pull --all || repoerror
            cd .. || repoerror
        else
            git clone https://github.com/instantOS/"$p" || exit 1
        fi
    } &
done <<<"$REPOLIST"

echo "finished instantOS local backup of $REPOCOUNT repos"

while pgrep git &> /dev/null
do
    sleep 1
done

if [ -e error.txt ]; then
    echo "errors: "
    cat error.txt
fi
