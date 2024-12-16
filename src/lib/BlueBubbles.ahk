/*---INFO-------------------------------------------------------------------------------------------------------------------------------------------------
	BlueBubbles.ahk: A script that has all the hotkeys I use with Blue Bubbles

	Author: jmbvill
	Date Modified: 2024.04.27
	Version Number: 1.1.0
	Changelog: Added universal hotkey to switch quickly between chats
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
;BlueBubbles_Focus on Text Input                    ESC                         #HK01
;BlueBubbles_Switch Chat		                    PAGE UP, PAGE DOWN			#HK02

/*===BlueBubbles_Focus on Text Input============================================#HK01
	Summary: For use with Blue Bubbles.
	Focuses the cursor on the text input box.

	Hotkey: ESC
*/
esc::
{
global ; V1toV2: Made function global
	MouseGetPos(&mouseX, &mouseY)
	MouseMove(600, 1030)
	MouseClick()
	MouseMove(mouseX, mouseY)
return
}

/*===BlueBubbles_Switch Chat====================================================#HK02
	Summary: For use with Blue Bubbles.
	Overrides Blue Bubbles's default chat switching hotkeys to the universal chat switching hotkeys

	Hotkey: PAGE UP, PAGE DOWN
*/
$PgUp::
{
Send("^{up}")
Return
}

$PgDn::
{
Send("^{down}")
return
}