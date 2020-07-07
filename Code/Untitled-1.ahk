; <COMPILER: v1.1.31.01>
#NoEnv
SetBatchLines -1
SetTitleMatchMode 2
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
wintitle := Minecraft X-AHK V0.4
targettitle := none
targetwinclass := GLFW30
ModeText := Empty
id := 0
ProgState := 0
Hotkey	!^f,	Fishing
Hotkey  !^e,	JumpFly
Hotkey  !^c,	Concrete
Hotkey  !^m,	MobGrind
Hotkey	!^s,	Stop
Hotkey  !^w,    SelectWindow
Menu, FileMenu, Add, Open, MenuFileOpen
Menu, FileMenu, Add, Exit, MenuHandler
Menu, HelpMenu, Add, About, MenuHandler
Menu, OptionsMenu, Add, Fishing, MenuFishing
Menu, OptionsMenu, Add, AFK Mob, MenuAFK
Menu, OptionsMenu, Add, Concrete, MenuConcrete
Menu, OptionsMenu, Add, JumpFlying, MenuJumpFly
Menu, ClickerMenu, Add, File, :FileMenu
Menu, ClickerMenu, Add, Help, :HelpMenu
Menu, ClickerMenu, Add, Options, :OptionsMenu
if %ProgState% != 0
Return
Gui, Show, w300 h300, Shortcuts
Gui, Add, Pic, w280 h290 vpic_get, welcomepic.png
Gui, Show,, Minecraft X-AHK V0.4
return
SelectWindow:
{
MouseGetPos, , , id, control
WinGetTitle, targettitle, ahk_id %id%
WinGetClass, targetclass, ahk_id %id%
if InStr(targetclass, targetwinclass)
{
ProgState = 1
Gui, Destroy
Gui, Show, w500 h500, Temp
Gui, Menu, ClickerMenu
Gui, Add, Text,, Target Window Title : %targettitle%
Gui, Add, Text,, Windows HWIND is : %id%
Gui, Add, Text,, To change mode of opperation please select from Option menu.
Gui, Add, Text,, MODE:
Gui, Add, Text, vMode w30, None
Gui, Show,, Minecraft X-AHK V0.4
ControlClick, , ahk_id %id%, ,Right, , NAU
ControlClick, , ahk_id %id%, ,Left, ,NAU
sleep 500
}
Else
{
MsgBox, You do not seam to have selected a Minecraft window. Please check before you continue.
}
Return
}
MenuFileOpen:
{
ModeText := JumpFlying
GuiControl,,Mode, %ModeText%
Return
}
MenuHandler:
{
Return
}
MenuFishing:
{
BreakLoop := 1
Gui, Destroy
Gui, Show, w500 h500, Temp
Gui, Menu, ClickerMenu
Gui, Add, Text,, Target Window Title : %targettitle%
Gui, Add, Text,, Windows HWIND is : %id%
Gui, Add, Text,, CURRENT AVALIBLE OPTIONS:
Gui, Add, Text,, o- Pressing ctrl + alt + f will start fishing
Gui, Add, Text,, o- Pressing ctrl + alt + s will stop any AutoKey funtion above
Gui, Add, Text,,
Gui, Add, Slider, vMySlider w200 ToolTip Range0-1000 TickInterval100, 500
Gui, Show,, Minecraft X-AHK V0.4
ProgState := 2
Return
}
MenuAFK:
{
BreakLoop := 1
Gui, Destroy
Gui, Show, w500 h500, Temp
Gui, Menu, ClickerMenu
Gui, Add, Text,, Target Window Title : %targettitle%
Gui, Add, Text,, Windows HWIND is : %id%
Gui, Add, Text,, CURRENT AVALIBLE OPTIONS:
Gui, Add, Text,, o- Pressing ctrl + alt + m will start Mod Grinding
Gui, Add, Text,, o- Pressing ctrl + alt + s will stop any AutoKey funtion above
Gui, Show,, Minecraft X-AHK V0.4
ProgState := 4
Return
}
MenuConcrete:
{
BreakLoop := 1
Gui, Destroy
Gui, Show, w500 h500, Temp
Gui, Menu, ClickerMenu
Gui, Add, Text,, Target Window Title : %targettitle%
Gui, Add, Text,, Windows HWIND is : %id%
Gui, Add, Text,, CURRENT AVALIBLE OPTIONS:
Gui, Add, Text,, o- Pressing ctrl + alt + c will start concrete farming
Gui, Add, Text,, o- Pressing ctrl + alt + s will stop any AutoKey funtion above
Gui, Show,, Minecraft X-AHK V0.4
ProgState := 3
Return
}
MenuJumpFly:
{
BreakLoop := 1
Gui, Destroy
Gui, Show, w500 h500, Temp
Gui, Menu, ClickerMenu
Gui, Add, Text,, Target Window Title : %targettitle%
Gui, Add, Text,, Windows HWIND is : %id%
Gui, Add, Text,, CURRENT AVALIBLE OPTIONS:
Gui, Add, Text,, o- Pressing ctrl + alt + e will dubble hit space and fire a rocket in main hand
Gui, Show,, Minecraft X-AHK V0.4
ProgState := 1
Return
}
JumpFly:
{
if (ProgState != 1)
Return
Sleep 500
Send {Space down}
Sleep 75
Send {Space up}
Sleep 200
Send {Space down}
Sleep 75
Send {Space up}
Sleep 50
ControlClick, , ahk_id %id%, ,Right, , NAD
Sleep 100
ControlClick, , ahk_id %id%, ,Right, , NAU
Return
}
Concrete:
{
if (ProgState != 3)
Return
BreakLoop := 0
ControlClick, , ahk_id %id%, ,Right, , NAD
Sleep 500
ControlClick, , ahk_id %id%, ,Left, , NAD
sleep 100
While (BreakLoop = 0)
{
if BreakLoop = 1)
{
sleep 10
}
}
ControlClick, , ahk_id %id%, ,Left, , NAU
Sleep 100
ControlClick, , ahk_id %id%, ,Right, , NAU
Return
}
Fishing:
{
if (ProgState != 2)
Return
BreakLoop := 0
Loop
{
if (BreakLoop = 1)
{
BreakLoop := 0
break
}
Sleep 100
ControlClick, , ahk_id %id%, ,Right, , NAD
Sleep 500
ControlClick, , ahk_id %id%, ,Right, , NAU
}
Return
}
MobGrind:
{
if (ProgState != 4)
Return
BreakLoop := 0
Delay := 0
Sleep 500
While (BreakLoop = 0)
{
ControlClick, , ahk_id %id%, ,Right, , NAD
if (BreakLoop = 1)
{
ControlClick, , ahk_id %id%, ,Right, , NAU
Return
}
Sleep 100
if (Delay >= 12)
{
Delay := 0
sleep 50
ControlClick, , ahk_id %id%, ,Left, ,NAD
Sleep 50
ControlClick, , ahk_id %id%, ,Left, ,NAU
}
else
Delay++
}
Sleep 100
ControlClick, , ahk_id %id%, ,Right, , NAU
ControlClick, , ahk_id %id%, ,Left, ,NAU
Return
}
Stop:
{
BreakLoop := 1
ControlClick, , ahk_id %id%, ,Right, , NAU
ControlClick, , ahk_id %id%, ,Left, ,NAU
sleep 500
return
}
ESC:
GuiClose:
GuiEscape:
ExitApp
