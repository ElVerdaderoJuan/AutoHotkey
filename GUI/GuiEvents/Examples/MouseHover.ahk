#Requires AutoHotkey v2.0
#Include GuiEvents.ahk



;   Variables
Width := 200
Margin := 0
InitialBackground := "Blue"
DefaultBackground := "Yellow"
HoverBackground := "Green"
TextColor := "White"
FontSize := 16
MiHover := MouseHover()



;   Mi GUI
MyGui := Gui(, "Mi GUI")
MyGui.MarginX := 21
MyGui.MarginY := MyGui.MarginX
MyGui.SetFont("s" FontSize " c" TextColor)
Text1 := MyGui.Add("Text","Background" InitialBackground " y+" MyGui.MarginX, "Text1")
Text2 := MyGui.Add("Text","Background" InitialBackground " y+" Margin, "Text2")
Text1.onEvent("Click", Presionando)
Text2.onEvent("Click", Presionando)

MiHover.Add(Text1.hwnd)
MiHover.Add(Text2.hwnd)

MyGui.Show("w" Width)



Presionando(*)
{
    
}

;   Acciones para el MouseHover
MouseHoverControls()
{
    MiHover.Opt("Background" InitialBackground, "BackgroundRed")
}
