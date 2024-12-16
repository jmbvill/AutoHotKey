/*---INFO-------------------------------------------------------------------------------------------------------------------------------------------------
	AutoHotKey.ahk: My main hotkey script. Stays on during normal computer use and listens to hotkeys

	Author: jmbvill
	Date Modified: 2024.12.16
	Version Number: 2.0.0
	Changelog:
		Updated to AHK V2
		Added Functionality to move windows to different virtual desktops using external library VD
*/

;---SETTINGS-----------------------------------------------------------------------------------------------------------------------------------------------
#Requires Autohotkey v2.0
;#Warn  ;Enable warnings to assist with detecting common errors.
InstallKeybdHook ;monitors keystrokes that are not supported by RegisterHotkey. Also supports the Input command.
SendMode("Input") ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir) ;Ensures a consistent starting directory.
SetTitleMatchMode(2)

;set some initial settings from the .ini file
dblclkToggle := IniRead("AutoHotkey.ini", "Toggles", "dblclkToggle")
testBench := IniRead("AutoHotkey.ini", "Toggles", "testBench")

;The following settings are disabled because this script sets them during normal operation.
;SetTitleMatchMode, 1 ;The window's title can contain WinTitle anywhere inside it to be a match.
;DetectHiddenWindows, On ;Allows the script to find windows that live on different desktops.

;Startup sound using a windows system sound that never gets used. This makes it easier to tell when the script starts up with windows
;and when it successfully reloads
SoundPlay("C:\WINDOWS\Media\Speech On.wav")

;---INCLUDED FILES-----------------------------------------------------------------------------------------------------------------------------------------
#Include "%A_ScriptDir%\lib\FocusWindow.ahk"
#Include "%A_ScriptDir%\external-lib\WinClip.ahk"
#Include "%A_ScriptDir%\external-lib\WinClipAPI.ahk"
#Include "%A_ScriptDir%\lib\ahk-util.ahk"
#Include "%A_ScriptDir%\external-lib\VD.ahk"

;---CONTENT-AWARE INCLUDES----------------------------------------------------------------------------------------------------------------------------------
;===Facebook Messenger======================================
#HotIf WinActive("ahk_class MessengerDesktop0",)
#Include "%A_ScriptDir%\lib\FacebookMessenger.ahk"
#HotIf

;===Blue Bubbles============================================
#HotIf WinActive("ahk_class FLUTTER_RUNNER_WIN32_WINDOW",)
#Include "%A_ScriptDir%\lib\BlueBubbles.ahk"
#HotIf

;===Discord=================================================
#HotIf WinActive("ahk_exe Discord.exe",)
#Include "%A_ScriptDir%\lib\Discord.ahk"
#HotIf

;===Civilization VI=========================================
#HotIf WinActive("ahk_exe CivilizationVI_DX12.exe",)
#Include "%A_ScriptDir%\lib\CivilizationVI.ahk"
#HotIf

;---FUNCTIONS----------------------------------------------------------------------------------------------------------------------------------------------
;closeWorkWindows										#F01

/*======closeWorkWindows================================#F01
	Summary: Closes windows based on window titles from a user-defined array

	Parameters:
		workWindows: An array of window titles

	Return:
		Nothing
*/
closeWindows(windowsToClose) {
    for _, window in windowsToClose ;for each window specified in windowsToClose, extract the winColor and the winTitle
    {
        winColor := window["winColor"]
        winTitle := window["winTitle"]
        if winColor ;if the window has a winColor specified, add it to a group and cycle through them to check if the winColor matches
        {
            GroupAdd("windowGroup", winTitle)
            GroupActivate("windowGroup")
            first_ID := WinGetID("A")
            loop {
                GroupActivate("windowGroup")
                active_ID := WinGetID("A")
                Sleep(100)
                pixColor := PixelGetColor(1700, 20)
                if (pixColor = winColor) ; only close windows in this group that have a matching color
                {
                    WinClose("A")
                }
                if (active_ID = first_ID) ;when we get back to the first window, break out of loop.
                {
                    break
                }
            }
        }
        else {
            WinClose(winTitle)
        }
    }
    return
}

;---MAIN---------------------------------------------------------------------------------------------------------------------------------------------------
;NAME												HOTKEY						INDEX
;Save and Reload									MEH + R						#HK01
;Edit Default Script								MEH + Delete				#HK02
;Audio Switcher										MEH + Backspace				#HK03
;Calculator											MEH + =						#HK04
;Shutdown											MEH + X						#HK05
;Choose Focused Window								ALT + WIN + SHIFT + MINUS	#HK06.1
;Focus on Window									MEH + MINUS					#HK06.2
;Instant Window Attributes							MEH + RMB					#HK07
;Instant Mouse Position								MEH + LMB					#HK08
;Mouse Switch Screen								MEH + F12					#HK09
;Move Windows to Start Position						MEH + N						#HK10
;StreamDeck_Hold to Shutdown Instructions			ALT + WIN + SHIFT + X		#HK11
;StreamDeck_Open Stream Deck Config					ALT + WIN + SHIFT + R		#HK12
;StreamDeck_Reset Stream Deck						ALT + WIN + SHIFT + Q		#HK13
;StreamDeck_Close Work Windows						ALT + WIN + SHIFT + C		#HK14
;StreamDeck_Send All Windows to the Right Screen	ALT + WIN + SHIFT + G		#HK15

;Test Bench Toggle									MEH + B						#HK99

;TEST BENCH
;NAME												HOTKEY						INDEX
;Radial Menu										MEH + F24					#TB01
;Round Calculator Result							CTRL + C					#TB02

/*======Save and Reload=========================================================#HK01
	Summary: Save and reload this script.

	Hotkey: MEH + R
*/
$^+!r::
{
    global ; V1toV2: Made function global
    SetTitleMatchMode(2)
    WinActivate(".ahk")
    Send("^s")
    Sleep(1500)
    Reload()
    return
}

/*======Edit Default Script=====================================================#HK02
	Summary: Open and Edit this script in VS Code

	Hotkey: MEH + Delete
*/
$^+!Del::
{
    global ; V1toV2: Made function global
    ToolTip("Opening script in VSCode...")
    SetTitleMatchMode(2)
    DetectHiddenWindows(true)
    ;for some reason the run function doesn't like it when you feed it the VS Code filepath directly. This gets around the issue by constructing and storing the filepath in a separate variable
    vscodepath := StrReplace(A_AppData, "Roaming", "Local\Programs\Microsoft VS Code\Code.exe")

    Run(vscodepath)

    SetTimer(RemoveToolTip, 3000)
    return
}

/*======Audio Switcher==========================================================#HK03
	Summary: Switch between speaker and headphones and the default playback device
	Hotkey: MEH + Backspace
*/
$^+!Backspace::
{
    global ; V1toV2: Made function global
    soundToggle := IniRead("F:\Users\Josh\Documents\Autohotkey\AutoHotkey.ini", "Toggles", "soundToggle") ;reads state of default output
    Run("mmsys.cpl")
    ErrorLevel := !WinWait("Sound") ;Waits for Sound window to open
    if (soundToggle = "Speakers") ;Speakers to Headset
    {
        ControlSend("{Down 5}", "SysListView321") ; This number selects the matching audio device in the list, change it accordingly
        Sleep(300)
        ControlClick("&Set Default") ; Change "&Set Default" to the name of the button in your local language
        Sleep(250)
        ControlClick("OK")
        IniWrite("Headset", "F:\Users\Josh\Documents\Autohotkey\AutoHotkey.ini", "Toggles", "soundToggle") ;changes state of default output on ini file
        TrayTip("Audio Switcher", "Headset")
    }
    if (soundToggle = "Headset") ;Headset to Speakers
    {
        ControlSend("{Down 6}", "SysListView321") ; This number selects the matching audio device in the list, change it accordingly
        Sleep(350)
        ControlClick("&Set Default") ; Change "&Set Default" to the name of the button in your local language
        Sleep(350)
        ControlClick("OK")
        IniWrite("Speakers", "F:\Users\Josh\Documents\Autohotkey\AutoHotkey.ini", "Toggles", "soundToggle") ;changes state of default output on ini file
        TrayTip("Audio Switcher", "Speakers")
    }
    return
}

/*======Calculator=============================================================#HK04
	Summary: Opens Windows Calculator

	Hotkey: MEH + =
*/

$^+!=::
{
    global ; V1toV2: Made function global
    DetectHiddenWindows(false)
    startingWindow := WinGetTitle("A")

    if (WinExist("Calculator ahk_class CalcFrame") || WinExist("Calculator ahk_class ApplicationFrameWindow"))
        if (WinActive("Calculator ahk_class CalcFrame") || WinActive("Calculator ahk_class ApplicationFrameWindow")) {
            Send("!{Esc}")
            WinMinimize()
        }
        else {
            Sleep(50)
            WinRestore()
            WinActivate()

        }
    else
        Run("calc.exe")
    return
}

/*======Shutdown===============================================================#HK05
	Summary: Closes all windows and shuts down the computer

	Hotkey: MEH + X
*/
;Give the user a chance to change their mind
$^+!x::
{
    global ; V1toV2: Made function global
    msgResult := MsgBox("This system is shutting down in 5 seconds. Continue?", "", "257 T5")
    if (msgResult = "Cancel") {
        MsgBox("shutdown cancelled")
        return
    }
    oWinList := WinGetList(, , "Program Manager",)
    aWinList := Array()
    WinList := oWinList.Length
    for v in oWinList {
        aWinList.Push(v)
    }

    loop 2 ;go to the first desktop
    {
        Send("#^{Left}")
    }
    loop aWinList.Length {
        CurrentWin := aWinList[A_Index]
        CurrentTitle := WinGetTitle("ahk_id " CurrentWin)
        if (CurrentTitle != "" and CurrentTitle != "Backup and Sync") {
            WinClose("ahk_ID " CurrentWin)
            Sleep(100)
        }
    }

    Send("#^{Right}") ;go to the next desktop
    Sleep(1000)
    oWinList := WinGetList(, , "Program Manager",)
    aWinList := Array()
    WinList := oWinList.Length
    for v in oWinList {
        aWinList.Push(v)
    }
    loop aWinList.Length {
        CurrentWin := aWinList[A_Index]
        CurrentTitle := WinGetTitle("ahk_id " CurrentWin)
        if (CurrentTitle != "" and CurrentTitle != "Backup and Sync") {
            WinClose("ahk_ID " CurrentWin)
            Sleep(100)
        }
    }

    Sleep(3000)
    Shutdown(1)
    return
}

/*======Choose Focused Window==================================================#HK06.1
	Summary: Bring the designated window from the above hotkey to the front

	Hotkey: ALT + WIN + SHIFT + MINUS
*/
$#+!-::
{
    global ; V1toV2: Made function global
    focus_ID := WinGetID("A")
    focus_title := WinGetTitle("A")
    ToolTip("Focusing on `"" focus_title "`"")
    SetTimer(RemoveToolTip, 2000)
    return
}

/*======Focus on Chosen Window=================================================#HK06.2
	Summary: Bring the designated window from the above hotkey to the front

	Hotkey: MEH + MINUS
*/
$^+!-::
{
    global ; V1toV2: Made function global
    DetectHiddenWindows(true)
    if (focus_ID) {
        focusID := "ahk_id " focus_ID
        if (WinActive(focusID)) {
            ToolTip("Unfocused on `"" focus_title "`"")
        }
        else {
            ToolTip("Focused on `"" focus_title "`"")
        }
        FocusWindow(focusID, , , false)
        SetTimer(RemoveToolTip, 2000)
    }
    else {
        ToolTip("Hold the Streamdeck button`nor press `"Win + Shift + Alt + Minus`"`nto choose a window to focus on.")
        SetTimer(RemoveToolTip, 2000)
    }
    return
}

/*======Instant Window Attributes==============================================#HK07
	Summary: Hover the mouse over a window and press the hotkeys. A tooltip will appear with the Title, ahk_ID, ahk_class, ahk_exe, size, and position of the window as long as the right mouse button is held.

	Hotkey: MEH + RMB
*/

$^+!RButton::
{
    global ; V1toV2: Made function global
    MouseGetPos(, , &WindowID)
    WinGetPos(&X, &Y, &W, &H, "ahk_id " WindowID)
    WindowTitle := WinGetTitle("ahk_id " WindowID)
    WindowClass := WinGetClass("ahk_id " WindowID)
    WindowProcess := WinGetProcessName("ahk_id " WindowID)
    ToolTip(WindowTitle "`nahk_id = " WindowID "`nahk_class = " WindowClass "`nahk_exe = " WindowProcess "`nx = " X ", y = " Y ", w = " W ", h = " H
    )
    while GetKeyState("RButton", "P") {
        Sleep(20)
    }
    ToolTip()
    return
}

/*======Instant Mouse Position=================================================#HK08
	Summary: Press the hotkeys and a tooltip will appear with the coordinates of the mouse and the color of the pixel underneath as long as the left mouse button is held.

	Hotkey: MEH + LMB
*/

$^+!LButton::
{
    global ; V1toV2: Made function global
    CoordMode("Mouse", "Screen")
    CoordMode("Pixel", "Screen")
    MouseGetPos(&X, &Y)
    pixColor := PixelGetColor(X, Y)
    ToolTip("mousepos: x=" X " y=" Y "`ncolor=" pixColor)
    while GetKeyState("LButton", "P") {
        Sleep(20)
    }
    ToolTip()
    return
}

/*======Mouse Switch Screen====================================================#HK09
	Summary: Moves the mouse to the monitor that it's not currently on. A tooltip will appear to help with visibility.

	Hotkey: MEH + F12
*/

^+!F12::
{
    global ; V1toV2: Made function global
    CoordMode("Mouse", "Screen")
    MouseGetPos(&X, &Y)
    if (X < 1920) {
        xNew := X + 1920
    }
    else {
        xNew := X - 1920
    }
    MouseMove(xNew, Y)
    ToolTip("I'm here!")
    SetTimer(RemoveToolTip, 500)
    return
}

/*======Move Windows to Start Position=========================================#HK10
	Summary: Moves all windows to my preferred locations on my preferred desktop. For use when the computer first starts up.

	Hotkey: MEH + N
*/

$^!+n::
{
    global ; V1toV2: Made function global
    CoordMode("Mouse", "Screen")
    CoordMode("Pixel", "Window")
    SetTitleMatchMode(2)
    ;get ID of first Window
    ToolTip("working...")
    WinActivate("Discord")
    first_ID := WinGetID("A") ;start with the discord window. get its ID.
    ;We do this instead of just starting with a random first window to avoid infinite loops
    ;if the first window goes to the second desktop then the program can no longer find it

    ;Cycle through windows
    loop {
        Send("{Alt down}{Shift down}{Tab}")
        Sleep(100)
        Send("{Shift up}{Alt up}") ;Cycle thru remaining windows
        Sleep(100)
        active_ID := WinGetID("A") ;get their IDs
        title := WinGetTitle("A")
        ;if Window is Discord, Obsidian, BlueBubbles, Messenger get its position and put it on the right monitor
        if (InStr(title, "Discord") || InStr(title, "Obsidian") || InStr(title, "BlueBubbles") || InStr(title,
            "Messenger")) {
            WinGetPos(&xpos, &ypos, , , "A")
            Sleep(100)
            if (xpos < 1911) {
                Send("^#+{right}")
                Sleep(100)
            }
        }
        ;if Window is Spark, Slack, Outlook get its position and put it on the right monitor then switch its desktop
        if (InStr(title, "Spark") || InStr(title, "Slack") || InStr(title, "Outlook")) {
            WinGetPos(&xpos, &ypos, , , "A")
            Sleep(100)
            if (xpos < 1911) {
                Send("^#+{right}")
                Sleep(100)
            }
            Send("^#!{right}")
            Sleep(100)
        }
        ;if window is Internet Browser, get its position and put it on the left monitor then get its Color
        if (InStr(title, "Brave")) {
            WinGetPos(&xpos, &ypos, , , "A")
            Sleep(100)
            if (xpos > 1911) {
                Send("^#+{right}")
                Sleep(100)
            }
            pixColor := PixelGetColor(1700, 20)
            ;if the browser window is for work, switch its desktop, else do nothing
            if (pixColor = 0xCDA398) {
                Send("^#!{right}")
                Sleep(100)
            }
        }
        ;else do nothing
        else {
            Sleep(100)

        }

        if (active_ID = first_ID) ;when we get back to the first window, break out of loop.
        {
            break
        }

    }
    ToolTip("finished moving windows!")
    SetTimer(RemoveToolTip, 1500)
    return
}

/*======StreamDeck_Hold to Shutdown Instructions===============================#HK11
	Summary: For use with the Stream Deck.
	This triggers when the user fails to hold the shutdown button to trigger the shutdown hotkey. This opens a traytip with instructions on how to shut down the computer from the Stream Deck

	Hotkey: ALT + WIN + SHIFT + X
*/

!#+x::
{
    global ; V1toV2: Made function global
    TrayTip("Shutdown Failed", "Hold for 1 second to shut down", 2)
    return
}

/*======StreamDeck_Open Stream Deck Config=====================================#HK12
	Summary: For use with the Stream Deck.
	Opens the Stream Deck Configuration Software.

	Hotkey: ALT + WIN + SHIFT + R
*/

!#+r:: ;open stream deck software
{
    global ; V1toV2: Made function global
    Run("`"F:\Program Files\Elgato\StreamDeck\StreamDeck.exe`"")
    return
}

/*=====StreamDeck_Reset Stream Deck===========================================#HK13
	Summary: For use with the Stream Deck.
	Resets the Stream Deck Software

	Hotkey: ALT + WIN + SHIFT + Q
*/

!#+q:: ;reset stream deck
;This uses the process function to close the Stream Deck software from the system tray
{
    global ; V1toV2: Made function global
    ToolTip("Resetting Stream Deck...")
    ErrorLevel := ProcessClose("StreamDeck.exe")
    ErrorLevel := ProcessWaitClose("StreamDeck.exe")
    Sleep(1000)
    Run("`"F:\Program Files\Elgato\StreamDeck\StreamDeck.exe`"")
    ErrorLevel := ProcessWait("StreamDeck.exe")
    ToolTip("Stream Deck Reset!")
    SetTimer(RemoveToolTip, 2000)

    return
}

/*======StreamDeck_Close Work Windows==========================================#HK14
	Summary: For use with the Stream Deck.
	Closes work windows on all virtual desktops

	Hotkey: ALT + WIN + SHIFT + C
*/

!#+c::
;;define work windows here
;you can define a specific window color for each browser by typing "?" and then the pixel color of the window in RGB
{
    global ; V1toV2: Made function global
    workWindows := ["Slack", "Edge ? 0xD8B2AD"]

    ToolTip("Closing Work Windows...")
    BlockInput("On")
    CoordMode("Pixel", "Window")
    SetTitleMatchMode(2)
    first_ID := "0"
    active_ID := "1"

    windowsToClose := [] ;initialize array

    ;extract winTitle and winColor
    for _, winTitle in workWindows {
        if questionPos := InStr(winTitle, "?") {
            winColor := Trim(SubStr(winTitle, (questionPos + 1) < 1 ? (questionPos + 1) - 1 : (questionPos + 1)))
            winTitle := Trim(SubStr(winTitle, 1, questionPos - 1))
            dict := createDictionary("winTitle:" winTitle "|winColor:" winColor)
        }
        else {

            dict := createDictionary("winTitle:" winTitle)
        }
        windowsToClose.Push(dict)
    }
    Send("#^{Left}")
    Sleep(500)
    closeWindows(windowsToClose)
    Send("#^{Right}") ;go to the next desktop
    Sleep(1000)
    closeWindows(windowsToClose)

    ToolTip("Successfully Closed Work Windows")
    BlockInput("Off")
    SetTimer(RemoveToolTip, 2000)

    return
}

/*======StreamDeck_Send All Windows to the Right Screen=========================#HK15
	Summary: For use with the Stream Deck.
	Sends all open windows to the right screen. For use when starting up a gaming session where you want only the game window on the left monitor

	Hotkey: ALT + WIN + SHIFT + G
*/

#+!g:: ;send all windows to the right screen
{
    global ; V1toV2: Made function global
    ToolTip("Moving all windows to the right screen")
    CoordMode("Mouse", "Screen")
    ;GroupAdd, AllWindows
    first_ID := WinGetID("A")
    loop {
        ;GroupActivate, AllWindows
        Send("{Alt down}{Shift down}{Tab}")
        Sleep(100)
        Send("{Shift up}{Alt up}") ;Cycle thru remaining windows
        Sleep(100)
        active_ID := WinGetID("A")
        WinGetPos(&xpos, &ypos, , , "A")
        Sleep(10)
        if (xpos < 1911) {
            Send("^#+{right}")
            Sleep(100)
        }
        if (active_ID = first_ID) ;when we get back to the first window, break out of loop.
        {
            break
        }
    }
    ToolTip("done")
    SetTimer(RemoveToolTip, 1000)
    return
}

/*======StreamDeck_Send All Windows to the Right Screen=========================#HK15
	Summary: For use with the Stream Deck.
	Sends all open windows to the right screen. For use when starting up a gaming session where you want only the game window on the left monitor

	Hotkey: CTRL + WIN + SHIFT + Left, CTRL + WIN + SHIFT + Left
*/

^#+Left::
{
    n := VD.getCurrentDesktopNum()
    if n = 1 {
        return
    }
    n -= 1
    VD.MoveWindowToDesktopNum("A", n)
    return
}

^#+Right::
{
    n := VD.getCurrentDesktopNum()
    MsgBox("VD.getCount = " VD.getCount())
    if n = VD.getCount() {
        return
    }
    n += 1
    VD.MoveWindowToDesktopNum("A", n)
    return
}

/*======Test Bench Toggle=======================================================#HK99
	Summary: Toggles the test bench section on/off. Useful for when the hotkeys in this section coincides with other hotkeys.

	Hotkey: MEH + B
*/
$^+!b::
{
    global ; V1toV2: Made function global
    testBench := IniRead(A_ScriptDir "\AutoHotkey.ini", "Toggles", "testBench") ;reads state of testBench from ini file
    switch testBench {
        case 1:
        {
            testBench := "0"
            IniWrite(testBench, A_ScriptDir "\AutoHotkey.ini", "Toggles", "testBench") ;changes testBench state on ini file
            ToolTip("test bench off")
            SetTimer(RemoveToolTip, 1000)
        }
        case 0:
        {
            testBench := "1"
            IniWrite(testBench, A_ScriptDir "\AutoHotkey.ini", "Toggles", "testBench") ;changes testBench state on ini file
            ToolTip("test bench on")
            SetTimer(RemoveToolTip, 1000)
        }
    }
    return
}

;---TEST BENCH---------------------------------------------------------------------------------------------------------------------------------------------
;This section is for scripts that I'm still testing, temporary scripts, or scripts that I don't want to always be active.
#HotIf testBench = 1

/*======Radial Menu=============================================================#TB01
	Summary:

	Hotkey: MEH + F24
*/

$~F24::
{
    ErrorLevel := ProcessExist("radial menu.exe")
    if !ErrorLevel {
        Run("`"F:\Users\Josh\Google Drive\MISC\Radial menu v4\Radial menu.exe`"")
        ToolTip("starting radial menu")
        Sleep(500)
        ToolTip()
    }
    return
}

/*======Round Calculator Result=================================================#TB02
	Summary: When user copies something from the calculator, round the number to the second decimal point. Used for when calculating money to charge on Venmo.

	Hotkey: CTRL + C
*/
^c::
{
    global ; V1toV2: Made function global
    Sleep(50)
    Send("^c")
    Sleep(50)
    if !WinActive("Calculator") {
        return
    }
    else {
        ;round the number to the second decimal point

        check := Round(A_Clipboard, 2)
        Sleep(100)
        A_Clipboard := check
    }
    return
}
/*======General Purpose Hotkey=================================================#TB03
	Summary: General purpose testing hotkey

	Hotkey: CTRL + RMB
*/

; ;^RButton::
; ;{
; ; global ; V1toV2: Made function global
; ; CoordMode, Mouse, Screen
; ; y_position = 235
; ; x_positions := [2540,2680,2800,2940,3080,3200,3350]
; ; Send ^g
; ; sleep 50
; ; send ^c
; ; for k, x_position in x_positions
; ; {
; ; 	KeyWait, Shift, down
; ; 	KeyWait, Shift, up
; ; 	MouseClick, L, x_position, y_position
; ; 	sleep 75
; ; 	KeyWait, Shift, down
; ; 	KeyWait, Shift, up
; ; 	Send ^g
; ; 	sleep 200
; ; 	send ^v{enter}

; ; 	sleep 200
; ; }
; ; tooltip done!
; ; SetTimer, RemoveToolTip, 2500
; Send ^g
; sleep 200
; send ^v{enter}
; ;return
; ;}

; ; ^!RButton::
; ;{
; ; global ; V1toV2: Made function global
; CoordMode, Mouse, Screen
; y_position = 220
; x_positions := {"m":2730,"t":2780,"w":2830,"th":2880,"f":2930,"s":2980,"su":3030}
; clicks := ["m","t","w","th","f","s","su"] ;,"s","f","th","w","t","m","w","f","su","f","w","m","th","su","th","m","f","su","w","m","s","su","t","su","m","su"]
; for k,click in clicks
; {
; 	for j,jclick in clicks
; 	{
; 		KeyWait, RButton, down
; 		KeyWait, RButton, up
; 		MouseClick, L, x_positions[click], y_position
; 		sleep 150
; 		MouseClick, L, x_positions[jclick], y_position
; 	}
; 	sleep 75

; }
; tooltip done!
; SetTimer, RemoveToolTip, 2500
return
; ;}
#HotIf