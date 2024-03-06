case $OSTYPE in
darwin*)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ;;
linux*)
    if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
        exec sway
    fi
    ;;
esac
