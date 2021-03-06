#!/bin/bash

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# ABS_SCRIPT_PATH="$(dirname "$(readlink --canonicalize "${BASH_SOURCE[0]}")" )"
[[ $1 = "-D" ]] && shift && set -x

function is_known_command {
    KNOWN_CMD=("msg" "fwd" "fwd_media" "send_audio" "send_document" "send_file" "send_photo" "send_text" "send_video")
    for c in "${KNOWN_CMD[@]}" ; do 
        [[ $1 == "$c" ]] && return 0
    done 
    return 1
}

if is_known_command "$1" ; then
    TELE_CMD=$1 && \
    shift
elif [[ ( -z $TELE_CMD ) && ( $# -eq 1 ) && ( -r $1 ) ]] ; then
    TELE_CMD="send_file"
else
    TELE_CMD="msg"
fi

[[ -f ${HERE}/teleself.config.ini ]] && SELF_ID=$(cat "${HERE}/teleself.config.ini")
[[ -z ${SELF_ID} ]] && read -r -p "Your Telegram User id#:" SELF_ID

telegram-cli -W -e "${TELE_CMD} user#${SELF_ID} $*"