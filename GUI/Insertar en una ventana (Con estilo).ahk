#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Pixel", "Screen" ; La posición del mouse se obtiene en relación a la pantalla






;   #################################
;   #########   Variables   #########
;   #################################

;   GUIs
Gui_BorderRadious := 15
Gui_Font := "MS Reference Sans Serif"
Gui_SizeTitle := 11
Gui_SizeText := 10
Gui_StyleTitle := "Bold"
Gui_StyleText := "Norm"
Gui_Margin := 21
Style_CheckBox := "0x8000"
Style_Text := "0x200"
Size_TitleBar := 26
Width := 198
Background_Margin := 6
Objets_Margin := 6
Objets_W := Width-Objets_Margin/2
Window := "A"
MouseIsHover := false
InsertType := "Owner"       ; Recomendado, foco independiente de la ventana pero se minimiza, se abre y se cierra junto con ella
;InsertType := "Parent"     ; El foco de la GUI y de la ventana están sincronizados, se mueve, se minimiza, se abre y se cierra junto con ella, y solo es visible dentro de los límites la ventana propietaria

;   Colores de las GUIs
Color_Back := "00A192"            ; Fondo
Color_Back2 := "FDE8BD"           ; Fondo encima del fondo
Color_BackMenu := "01787C"        ; Fondo del MenuBar
Color_TextMenu := "F5E8BF"        ; Texto del MenuBAr
Color_TextDefault := "AB5533"     ; Texto por defecto
Color_Spaces := "FFFAF0"          ; Fondo de espacios para poner texto llamativo o que indica algo
Color_TextAdvice := "5F6328"      ; Texto de aviso o sugerencia
Color_Success := "007354"         ; Texto de aviso o sugerencia
Color_TextError := "D42626"       ; Texto de error
Color_TextButton := "692E17"      ; Texto de los botones secundarios
Color_Button := "E6B85E"          ; Color del borde de los botones
Color_MenuButton := "015E61"      ; Color del botón del menú de barra
Color_TextMenuButton := "02CDD4"  ; Color del símbolo del botón del menú de barra
ColorGradientSuccess := [  ; Degradado de color de verde claro a verde oscuro
    "00FFBB",   ; 1  → Verde claro
    "00F2B2",   ; 2         ↑
    "00E6A8",   ; 3         |
    "00D99F",   ; 4         |
    "00CC96",   ; 5         |
    "00BF8C",   ; 6         |
    "00B383",   ; 7         |
    "00A67A",   ; 8         |
    "009970",   ; 9         |
    "008C67",   ; 10        |
    "00805E",   ; 11        ↓
    "007354"    ; 12 → Verde oscuro
]
ColorGradientError := [  ; Degradado de color de rojo claro a verde
    "D42626",   ; 1  → Rojo claro
    "C92C26",   ; 2         ↑
    "BF3126",   ; 3         |
    "B43727",   ; 4         |
    "A93C27",   ; 5         |
    "9F4227",   ; 6         |
    "944727",   ; 7         |
    "8A4D27",   ; 8         |
    "7F5227",   ; 9         |
    "745828",   ; 10        |
    "6A5D28",   ; 11        ↓
    "5F6328"    ; 12 →   Verde
]

;   Teclas de acceso rápido
Hotkey_WindowSelect := "LButton" ; Clic izquierdo para seleccionar ventana






;   #########################################
;   #########   Creación de GUIs    #########
;   #########################################

;   En esta GUI seleccionas en qué ventana quieres insetar la GUI
Gui_Insert := Gui("-Caption LastFound AlwaysOnTop")
Gui_Insert.BackColor := Color_Back
Gui_Insert.MarginX := Gui_Margin
Gui_Insert.MarginY := Gui_Margin
Gui_Insert.SetFont(" c" Color_TextDefault " s" Gui_SizeText " " Gui_StyleText, Gui_Font)
Gui_Insert.Add("Text", "x0 y0 Background" Color_BackMenu " vInsert_TitleBar w" Width + Gui_Insert.MarginX " h" Size_TitleBar " " Style_Text " Center")
Gui_Insert.Add("Text", "x" Background_Margin " y+" Background_Margin " Background" Color_Back2 " vInsert_Background w" Width + Gui_Insert.MarginX / 2 " h120 Center")
Gui_Insert["Insert_Background"].GetPos(, &Y,, &H)
Gui_Insert.Add("Text", "BackgroundTrans w" Width " vInsert_Text Section x" Background_Margin + Objets_Margin " y" Y + Objets_Margin, "Haz clic en en una ventana para seleccionarla")
Gui_Insert.Add("Text", "Background" Color_Spaces " c" Color_TextAdvice " Center w" Width " vInsert_Window y+" Objets_Margin, "Sin seleccionar")
Gui_Insert.Add("Button", "Background" Color_Button " y+" Objets_Margin*2 " vInsert_Boton w" Width " Disabled", "Insertar")
Gui_Insert.Add("Text", "BackgroundTrans vInsert_LastObject x" Background_Margin + Objets_Margin " y+0 w" Width)
Gui_Insert["Insert_TitleBar"].GetPos(,,, &H)
Gui_Insert.Add("Text", "x0 y0 BackgroundTrans c" Color_TextMenu " vInsert_TitleBarText w" Width + Gui_Insert.MarginX-H " h" Size_TitleBar " " Style_Text " Center", "Insetrar en una ventana")
Gui_Insert["Insert_TitleBar"].GetPos(&X, &Y, &W,)
Gui_Insert.Add("Text", "Center Background" Color_MenuButton " c" Color_TextMenuButton " vInsert_ButtonX x" W-Gui_Insert.MarginX-1 " y" Y+5 " w" h-h/3 " h" h-h/3, "✖")
Gui_Insert["Insert_Window"].GetPos(,,, &H)
Gui_Insert["Insert_Window"].Move(,,, H*1.4)
Gui_Insert["Insert_LastObject"].GetPos(, &Y,, &H)
Gui_Insert["Insert_Background"].Move(,,, H+Y-Gui_Margin*2)
Gui_Insert["Insert_TitleBarText"].OnEvent("Click", Window_Move)
Gui_Insert["Insert_ButtonX"].OnEvent("Click", Window_Close)
Gui_Insert["Insert_Boton"].OnEvent("Click", Gui_Insert_Next)
Gui_Insert_ID := Gui_Insert.hwnd
Gui_Insert_ButtonX := Gui_Insert["Insert_ButtonX"].hwnd

;   Esta GUI es la que se muestra insertada en la ventana que se seleccionó
Gui_Home := Gui("-Caption LastFound")
Gui_Home.BackColor := Color_Back
Gui_Home.MarginX := 21
Gui_Home.MarginY := 21
Gui_Home.SetFont("q4 c" Color_TextDefault " s" Gui_SizeText " " Gui_StyleText, Gui_Font)
Gui_Home.Add("Text", "x0 y0 Background" Color_BackMenu " c" Color_TextMenu " vHome_TitleBar w" Width + Gui_Home.MarginX " h" Size_TitleBar " " Style_Text " Center")
Gui_Home.Add("Text", "x" Background_Margin " y+" Background_Margin " Background" Color_Back2 " vHome_Background w" Width + Gui_Home.MarginX / 2 " Center")
Gui_Home["Home_Background"].GetPos(, &Y,, &H)
Gui_Home.SetFont("s" Gui_SizeTitle " " Gui_StyleTitle)
Gui_Home.Add("Text", "Background" Color_Back2 " Center " Style_CheckBox " Section x" Background_Margin + Objets_Margin " w" Objets_W " y" Y + Objets_Margin, "Contenido para tu GUI")
Gui_Home.SetFont("s" Gui_SizeText " " Gui_StyleText)
Gui_Home.Add("Text", "BackgroundTrans w" Objets_W " y+" Objets_Margin " vHome_Text", "• Esta GUI ahora pertenece a la ventana actual")
Gui_Home.Add("Text", "BackgroundTrans w" Objets_W " y+" Objets_Margin, "• El tamaño del alto de la GUI se adaptará automáticamente")
Gui_Home.Add("Text", "BackgroundTrans w" Objets_W " y+" Objets_Margin, "• Modifica todo editando las variables del principio del script")
Gui_Home.Add("Text", "BackgroundTrans vHome_SizeController x" Background_Margin + Objets_Margin " y+-" Objets_Margin "  w" Width)
Gui_Home["Home_TitleBar"].GetPos(,,, &H)
Gui_Home.Add("Text", "x0 y0 BackgroundTrans c" Color_TextMenu " vHome_TitleBarText w" Width + Gui_Home.MarginX-H " h" Size_TitleBar " " Style_Text " Center", "Mi GUI")
Gui_Home["Home_TitleBar"].GetPos(&X, &Y, &W,)
Gui_Home.Add("Text", "Center Background" Color_MenuButton " c" Color_TextMenuButton " vHome_ButtonX x" W-Gui_Home.MarginX-1 " y" Y+5 " w" h-h/3 " h" h-h/3, "✖")
Gui_Home["Home_SizeController"].GetPos(, &Y,, &H)
Gui_Home["Home_Background"].Move(,,, H+Y-Gui_Margin*2+Objets_Margin)
Gui_Home["Home_TitleBarText"].OnEvent("Click", Window_Move)
Gui_Home["Home_ButtonX"].OnEvent("Click", Window_Close)
Gui_Home["Home_ButtonX"].GetPos(&Home_ButtonX_X, &Home_ButtonX_Y, &Home_ButtonX_W, &Home_ButtonX_H)
Gui_Home_ID := Gui_Home.hwnd
Gui_Home_ButtonX := Gui_Home["Home_ButtonX"].hwnd






;   ###########################################################################
;   #########   Inicio - Mostrar ventana de selección de ventanas     #########
;   ###########################################################################

;   Mostrar la ventana de inserción
Gui_Insert.Show("w" Width + Gui_Insert.MarginX)
OnMessage 0x0200, MouseHover
Gui_Insert.GetPos(,, &W, &H)
WinSetRegion "0-0 r" Gui_BorderRadious "-" Gui_BorderRadious " w" W+1 " H" H-Objets_Margin*4, "ahk_id " Gui_Insert_ID
Hotkey "~" Hotkey_WindowSelect, WindowSelect, "On"
return

;   Selecionar una ventana y poner el nombre sin la extensión .exe en el cuadro
WindowSelect(*)
{
    Global Gui_Insert_ID, Window, WindowName
    MouseGetPos ,, &Window_ID
    if !(Window_ID = Gui_Insert_ID or Window_ID = "")
    {
        WindowName := UpperFirst(CleanExtension(WinGetProcessName("ahk_id " Window_ID)))
        Gui_Insert["Insert_Window"].Text := WindowName
        Gui_Insert["Insert_Window"].setFont("Bold")
        Gui_Insert["Insert_Text"].Text := "Para reemplazar la ventana haz clic en otra"
        Gui_Insert["Insert_Text"].SetFont("c" Color_TextDefault)
        Gui_Home["Home_Text"].Text := "• Esta GUI ahora pertenece a la ventana " WindowName
        Window := Window_ID
        Gui_Insert["Insert_Boton"].Enabled := true
        for Color in ColorGradientSuccess
        {
            if (WinExist("ahk_id " Gui_Insert_ID))
            {
                Gui_Insert["Insert_Window"].SetFont("c" Color)
                sleep 39
            }
        }
    }
}






;   #############################################################################################
;   #########   Mostrar la siguiente GUI insertada en la ventana que se seleccionó      #########
;   #############################################################################################

Gui_Insert_Next(*)
{
    ;   Mostrar advertencia si la ventana que se seleccionó ya no está disponible
    Global Gui_Insert_ID, Window
    if (WinExist("ahk_id " Window))
    {
        Gui_Insert["Insert_Boton"].Enabled := false
        Hotkey "~" Hotkey_WindowSelect, WindowSelect, "Off"
        Gui_Insert.Destroy()
        Gui_Home.Show("w" Width + Gui_Home.MarginX)
        Gui_Home.GetPos(,, &W, &H)
        WinSetRegion "0-0 r" Gui_BorderRadious "-" Gui_BorderRadious " w" W+1 " H" H-Objets_Margin*3, "ahk_id " Gui_Home_ID
        Gui_Home.Opt("+" InsertType Window)
        WinActivate "ahk_id " Window
    }
    else
    {
        Gui_Insert["Insert_Boton"].Enabled := false
        Gui_Insert["Insert_Text"].Text := "La ventana que seleccionaste ya no existe, selecciona otra"
        Gui_Insert["Insert_Text"].SetFont("c" Color_TextError)
        Gui_Insert["Insert_Window"].Text := "Sin seleccionar"
        Gui_Insert["Insert_Window"].setFont("Norm")
        for Color in ColorGradientError
        {
            if (WinExist("ahk_id " Gui_Insert_ID))
            {
                Gui_Insert["Insert_Window"].SetFont("c" Color)
                sleep 39
            }
        }
    }
}






;   #######################################################
;   #########   Funciones de propósito general    #########
;   #######################################################

; Convertir primera letra de alguna cadena en mayúscula
UpperFirst(Text)
{
    return StrUpper(SubStr(Text, 1, 1)) SubStr(Text, 2)
}

;   Limpiar extensión de una cadena (.exe .io .pdf y todo lo que esté desde el punto al final de la cadena hacia adelante)
CleanExtension(Text)
{
    return SubStr(Text, 1, InStr(Text, ".",, -1, -1) - 1)
}

;   Mover la ventana activa
Window_Move(*)
{
    PostMessage 0xA1, 2
}

;   Terminar aplicación cuando se cierre la GUI
Window_Close(*)
{
    ExitApp
}

;   MouseHover en botón de cerrar de las GUIs (Llamado por onMessage de Windows)
MouseHover(wParam, lParam, msg, hwnd)
{
    Global MouseIsHover
    ThisGui := GuiFromHwnd(hwnd)
    Control := GuiCtrlFromHwnd(hwnd)
    
    if (Control)
    {
        Control_ID := Control.hwnd
        if (MouseIsHover = false and (Control_ID = Gui_Home_ButtonX or Control_ID = Gui_Insert_ButtonX))
        {
            Control.Opt("+Background" Color_TextError)
            Control.Visible := false
            Control.Visible := true
            MouseIsHover := true
        }
    }
    else
    {
        ThisGui_ID := ThisGui.hwnd
        if (MouseIsHover = true and IsObject(ThisGui))
        {
            Switch (ThisGui_ID)
            {
                Case Gui_Home_ID:
                {
                    Gui_Home["Home_ButtonX"].Opt("+Background" Color_MenuButton)
                    Gui_Home["Home_ButtonX"].Visible := false
                    Gui_Home["Home_ButtonX"].Visible := true
                    MouseIsHover := false
                }
                Case Gui_Insert_ID:
                {
                    Gui_Insert["Insert_ButtonX"].Opt("+Background" Color_MenuButton)
                    Gui_Insert["Insert_ButtonX"].Visible := false
                    Gui_Insert["Insert_ButtonX"].Visible := true
                    MouseIsHover := false
                }
                
            }
        }
    }
}
