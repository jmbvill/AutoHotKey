#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

;;;;toggle between 75% sensitivity and 100% sensitivity. use when switching mice
^!Numpad3::
^!+m::
    IniRead, mouseSensMC, F:\Users\Josh\Documents\Autohotkey\AutoHotkey.ini, Toggles, mouseSensMC ;;reads state of mouseSensMC from ini file
    send {ESC}{TAB 6}{SPACE}
    sleep 100
    send {TAB 6}{SPACE}
    sleep 100
    send {TAB}{SPACE}
    sleep 100
    send {TAB}
    sleep 100
    if mouseSensMC = low
    {
        mouseSensMC = high
        sleep 100
        send {RIGHT 36}

    }
    else if mouseSensMC = high
    {
        mouseSensMC = low
        sleep 100
        send {LEFT 36}
    }
    IniWrite, %mouseSensMC%, F:\Users\Josh\Documents\Autohotkey\AutoHotkey.ini, Toggles, mouseSensMC ;;changes mouseSensMC state on ini file

    sleep 1000
    send {ESC 3}

return

^!Numpad4::F6
return