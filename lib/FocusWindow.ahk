/*---INFO-------------------------------------------------------------------------------------------------------------------------------------------------
	FocusWindow.ahk: A function that finds an open window using its title, focuses on the window, and brings it to the front. A user or program calls this script from the command line with specific arguments and flags to change the functionality.

	Author: jmbvill
	Date Modified: 2024.04.18
	Version Number: 1.1.0
	Changelog: Added if __name__ == __main__ functionality. Merged the main function of WindowFocus.ahk into FocusWindow.ahk.
*/

;---SETTINGS-----------------------------------------------------------------------------------------------------------------------------------------------
#NoEnv ;Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ;Enable warnings to assist with detecting common errors.
SendMode Input ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ;Ensures a consistent starting directory.

;The following settings are disabled because this script sets them during normal operation.
;SetTitleMatchMode, 1 ;The window's title can contain WinTitle anywhere inside it to be a match.
;DetectHiddenWindows, On ;Allows the script to find windows that live on different desktops.

;---INCLUDED FILES-----------------------------------------------------------------------------------------------------------------------------------------

;---FUNCTIONS----------------------------------------------------------------------------------------------------------------------------------------------
;FocusWindow					#F01

/*===FocusWindow=========================================#F01
	Summary: Finds an existing window given a window title and activates it, maximizes it, and brings it to the front.

	 If the window is already active, the function will minimize it and activate the previously activated window instead.

	Paramters:
		p_windowTitle: The title of the window to be focused on
		p_matchMode (default = 2): Sets the Match Mode
		p_hiddenWindows (default = "On"): Turns on/off the ability to detect hidden windows/windows that are on other virtual desktops

	Return:
		Nothing
*/
FocusWindow(p_windowTitle, p_matchMode:=2, p_hiddenWindows:="On")
{
	;Set search parameters based on function parameters
	setTitleMatchMode, %p_matchMode%
	DetectHiddenWindows, %p_hiddenWindows%
	; Makes sure that the window exists
	if (!WinExist(p_windowTitle))
	{
		msgbox Window does not exist!`nMake sure to include any flags AFTER the Window Title.`nIf Window Title has spaces, put the Window Title in quotes.
		return
	}

	; If the window is not active, then activate it
	; If the window is active, then minimize it and then activate the previous active window
	if (WinActive(p_windowTitle))
	{

		Send !{Esc} ;Activates the most recently activated window
		sleep 10
		WinMinimize, p_windowTitle
	}
	else
	{
		WinActivate
		WinMaximize
	}
	return
}

/*MAIN------------------------------------------------------------------------------------------------------------------------------------------------------
	Summary: Main takes the arguments and flags from the command line prompt, checks for validity, and passes them into the FocusWindow function.

	Command Line Arguments:	The first argument MUST be the Window Title!
	"-1" will change the title match mode to use mode 1
	"-2" will change the title match mode to use mode 2
	"-regex" will change the title match mode to use regular expressions
	"-hidden=on" will allow hidden windows/windows on other virtual desktops to be found
	"-hidden=off" won't allow hidden windows/windows on other virtual desktops to be found

	Example: FocusWindow.ahk Messenger
 			- In the above example, the script will take "Messenger" as the title of the window that it should focus/unfocus
			- No flags are given, so the script will default to title match mode of 2 and detect hidden windows on

*/

If (A_ScriptFullPath == A_LineFile)
{
	;Pushes command line arguments to an array
	args := []
	for n, arg in A_Args
	{
		args.Push(arg)
	}
	windowTitle := args[1]

	;Makes sure that an argument is included
	if (args.MaxIndex() < 1)
	{
		MsgBox Please provide a window title in arguments.`nWindow title MUST be the first argument.
		return
	}

	;Checks if the user included a flag to set match mode and detect hidden windows
	for n, arg in args
	{
		Switch arg
		{
		;checking for match mode flag
		Case "-regex":
			{
				matchMode = regex
			}
		Case "-2":
			{
				matchMode = 2
			}
		Case "-1":
			{
				matchMode = 1
			}

		;checking for detect hidden windows flag
		Case "-hidden=off":
			{
				hiddenWindows = off
			}
		Case "-hidden=on":
			{
				hiddenWindows = on
			}
		}

	}

	;set default values for matchMode and hiddenWindows
	if (matchMode == "")
	{
		matchMode = 2
	}

	if (hiddenWindows == "")
	{
		hiddenWindows = on
	}

	;call focus window
	FocusWindow(windowTitle, matchMode, hiddenWindows)
}