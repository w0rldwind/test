#!/bin/bash
n=$2

ACTION="${1:-init}"
DATA=/root/bees/bee$n/clef/data

init() {
    parse_json() { echo $1|sed -e 's/[{}]/''/g'|sed -e 's/", "/'\",\"'/g'|sed -e 's/" ,"/'\",\"'/g'|sed -e 's/" , "/'\",\"'/g'|sed -e 's/","/'\"---SEPERATOR---\"'/g'|awk -F=':' -v RS='---SEPERATOR---' "\$1~/\"$2\"/ {print}"|sed -e "s/\"$2\"://"|tr -d "\n\t"|sed -e 's/\\"/"/g'|sed -e 's/\\\\/\\/g'|sed -e 's/^[ \t]*//g'|sed -e 's/^"//' -e 's/"$//' ; }
    if [ ! -f "$DATA"/password ]; then
        < /dev/urandom tr -dc _A-Z-a-z-0-9 2> /dev/null | head -c32 > "$DATA"/password
    fi
    SECRET=$(cat "$DATA"/password)
    /root/bees/bee$n/clef/bee-clef --configdir "$DATA" --stdio-ui init >/dev/null 2>&1 << EOF
$SECRET
$SECRET
EOF
    if [ "$(ls -A "$DATA"/keystore 2> /dev/null)" = "" ]; then
        /root/bees/bee$n/clef/bee-clef --keystore "$DATA"/keystore --stdio-ui newaccount --lightkdf >/dev/null 2>&1 << EOF
$SECRET
EOF
    fi
    /root/bees/bee$n/clef/bee-clef --keystore "$DATA"/keystore --configdir "$DATA" --stdio-ui setpw 0x"$(parse_json "$(cat "$DATA"/keystore/*)" address)" >/dev/null 2>&1 << EOF
$SECRET
$SECRET
$SECRET
EOF
    /root/bees/bee$n/clef/bee-clef --keystore "$DATA"/keystore --configdir "$DATA" --stdio-ui attest "$(sha256sum /root/bees/bee$n/clef/cfg/rules.js | cut -d' ' -f1 | tr -d '\n')" >/dev/null 2>&1 << EOF
$SECRET
EOF
}

$ACTION
