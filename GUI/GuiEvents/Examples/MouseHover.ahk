#Requires AutoHotkey v2.0
#Include <GuiEvents>

;   Variables
Width := 200
Margin := 0
ColorBackground := "Blue"
NewColorBackground := "Red"
TextColor := "White"
FontSize := 15






; Create your 'MouseHover' name
; 👇 👇 👇
MyHover := MouseHover()






;   My GUI: Create your GUI
MyGui := Gui(, "Mi GUI")
MyGui.MarginX := 21
MyGui.MarginY := 21
MyGui.SetFont("s" FontSize " c" TextColor)
Text1 := MyGui.Add("Text","Background" ColorBackground " y+" MyGui.MarginX " w" Width-MyGui.MarginX*2, "This is the MouseHover easy to use")
Text2 := MyGui.Add("Text","Background" ColorBackground " y+6 w" Width-MyGui.MarginX*2, "Open Notepad")
Text3 := MyGui.Add("Text","Background" ColorBackground " y+0 w" Width-MyGui.MarginX*2, "Open Calculator")
Text4 := MyGui.Add("Text","Background" ColorBackground " y+0 w" Width-MyGui.MarginX*2, "Open Explorer")

; Create normal events from AutoHotkey
Text1.onEvent("Click", MyFunction1)
Text2.onEvent("Click", MyFunction2)
Text3.onEvent("Click", MyFunction3)
Text4.onEvent("Click", MyFunction4)

; Show the created GUI
MyGui.Show("w" Width)






; Add the controls where you need the 'MouseHover'
; 👇 👇 👇
MyHover.Add(Text1)
MyHover.Add(Text2)
MyHover.Add(Text3)
MyHover.Add(Text4)

; Actions when 'MouseHover' is not detected (Default options) and when it is detected (Hover options)
; 👇 👇 👇
GuiEvents()
{
;   MyHover.Opt( DefaultOptions , HoverOptions )
    MyHover.Opt("Background" ColorBackground, "Background" NewColorBackground)
}






; Functions called when controls are pressed
MyFunction1(*)
{
    MsgBox "¡Hi!    :D `n`nYou can use the code of GuiEvents.ahk using this: #Include GuiEvents.ahk", "MouseHover"
}
MyFunction2(*)
{
    Run "notepad.exe"
}
MyFunction3(*)
{
    Run "calc.exe"
}
MyFunction4(*)
{
    Run "explorer.exe"
}
