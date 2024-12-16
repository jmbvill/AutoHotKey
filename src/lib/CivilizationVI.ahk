/*---INFO-------------------------------------------------------------------------------------------------------------------------------------------------
	CivilizationVI.ahk: A script that has all the hotkeys I use while playing Civ 6

	Author: jmbvill
	Date Modified: 2024.04.23
	Version Number: 1.0.0
	Changelog: Initial Release
*/

;---SETTINGS-----------------------------------------------------------------------------------------------------------------------------------------------
InstallKeybdHook() ;monitors keystrokes that are not supported by RegisterHotkey. Also supports the Input command.
; V1toV2: Removed #NoEnv ;Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ;Enable warnings to assist with detecting common errors.
SendMode("Input") ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir) ;Ensures a consistent starting directory.

;The following settings are disabled because this script sets them during normal operation.
;SetTitleMatchMode, 1 ;The window's title can contain WinTitle anywhere inside it to be a match.
;DetectHiddenWindows, On ;Allows the script to find windows that live on different desktops.

;---INCLUDED FILES-----------------------------------------------------------------------------------------------------------------------------------------

;---LABELS-------------------------------------------------------------------------------------------------------------------------------------------------
;This section is to set labels for use with the SetTimer function

;---MAIN---------------------------------------------------------------------------------------------------------------------------------------------------
;NAME												HOTKEY						INDEX
;Civ6_Restart Map                                   CTRL + R                    #HK01

/*======Civ6_Restart Map========================================================#HK01
	Summary: For use with Civ 6.
	Restarts

	Hotkey: CTRL + R
*/
^r::
{ ; V1toV2: Added bracket
global ; V1toV2: Made function global
    CoordMode("Mouse", "Screen")
    Send("{esc}")
    Sleep(500)
    MouseClick("Left", 960, 550)
    Sleep(500)
    MouseClick("Left", 840, 580)
return
} ; V1toV2: Added bracket in the end