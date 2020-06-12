#!/usr/bin/env bash

Task::sudo_check() {

    sudo_on() {
    colorize red "*** Are you running this command $EPRIV? ***"
    colorize red "** You don't need to. Try again without it. **"
    sleep 5
    exit
    }

    OS=uname
    case "$OS" in
        windows*)      REG ADD HKLM /F>nul 2>&1
                        if %ERRORLEVEL%==0; then
                            EPRIV="as an administrator";
                            sudo_on;
                        fi
                    ;;
        *)    if [[ `whoami` = root ]]; then
                        EPRIV="as root";
                        sudo_on;
                    fi
                    ;;
    esac
}
