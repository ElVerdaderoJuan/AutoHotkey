#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Pixel", "Screen" ; La posición del mouse se obtiene en relación a la pantalla






;   #################################
;   #########   Variables   #########
;   #################################

;   GUIs
Gui_Margin := 21
Gui_BorderRadious := 15
Width := 198
Background_Margin := 6
Objets_Margin := 6
Window := "A"
Style_CheckBox := "0x8000"

;   Colores de las GUIs
Color_Back := "00A192"          ; Fondo
Color_Back2 := "FDE8BD"         ; Fondo encima del fondo
Color_BackMenu := "01787C"      ; Fondo del MenuBar
Color_TextMenu := "F5E8BF"      ; Texto del MenuBAr
Color_TextDefault := "AB5533"   ; Texto por defecto
Color_Spaces := "FFFAF0"        ; Fondo de espacios para poner texto llamativo o que indica algo
Color_TextAdvice := "D42626"    ; Texto de aviso o sugerencia
Color_Success := "006E50"       ; TextoFCF7EB de aviso o sugerencia
Color_Error := "FF4A4A"         ; Texto de error
Color_TextButton := "692E17"    ; Texto de los botones secundarios
Color_Button := "E6B85E"        ; Color del borde de los botones

;   Hotkeys (Teclas de acceso rápido)
Hotkey_Cannon := [
    "F1",   ; Cañón izquierdaFCF7EB
    "F2",   ; Cañón centro
    "F3",   ; Cañón derecho
    "F4"    ; Cañón hacia arriba
]
Hotkey_WindowSelect := "LButton"
RightCannonColumn := 3 ; Columna en donde se encuentra el cañón que apunta hacia la derecha (Objetivo: Obtenerlo y hacer que apunte hacia arriba)
RightCannonHotkeys := "zzzzzz" ; Las teclas que se presionan cuando se selecciona el cañón de la variable RightCannonColumn

;   Areas en donde están los cañones
Cannons_Area := [
[970, 540, 1015, 740],  ; Area 1: [x1, y1, x2, y2]
[1015, 540, 1060, 740], ; Area 2: [x1, y1, x2, y2]
[1060, 540, 1105, 740], ; Area 3: [x1, y1, x2, y2]
]
Cannons_Color := Integer(0x999999) ; Color que se busca para hacer click en el cañón (Color de algún pixel de la imagen del cañón)






;   #########################################
;   #########   Creación de GUIs    #########
;   #########################################

;   En esta GUI seleccionas en qué ventana quieres insetar la GUI
Gui_Insert := Gui("-Caption LastFound AlwaysOnTop")
Gui_Insert.BackColor := Color_Back
Gui_Insert.MarginX := Gui_Margin
Gui_Insert.MarginY := Gui_Margin
Gui_Insert.SetFont("c" Color_TextDefault " q4 s11")
Gui_Insert.Add("Text", "x0 y0 Background" Color_BackMenu " c" Color_TextMenu " vInsert_TitleBar w" Width + Gui_Insert.MarginX " h26 0x200 Center", "Insetrar en una ventana")
Gui_Insert.Add("Text", "x" Background_Margin " y+" Background_Margin " Background" Color_Back2 " vInsert_Background w" Width + Gui_Insert.MarginX / 2 " h120 Center")
Gui_Insert["Insert_Background"].GetPos(, &Y,, &H)
Gui_Insert.Add("Text", "BackgroundTrans w" Width " vInsert_Texto Section x" Background_Margin + Objets_Margin " y" Y + Objets_Margin, "Haz clic en en una ventana para seleccionarla")
Gui_Insert.Add("Text", "Background" Color_Spaces " c" Color_TextAdvice " Center w" Width " vInsert_Window y+" Objets_Margin, "Sin seleccionar")
Gui_Insert.Add("Button", "Background" Color_Button " y+" Objets_Margin*2 " vInsert_Boton w" Width " Disabled", "Insertar")
Gui_Insert.Add("Text", "BackgroundTrans vInsert_LastObject x" Background_Margin + Objets_Margin " y+0 w" Width, "Pruebita")
Gui_Insert["Insert_Window"].GetPos(,,, &H)
Gui_Insert["Insert_Window"].Move(,,, H*1.4)
Gui_Insert["Insert_LastObject"].GetPos(, &Y,, &H)
Gui_Insert["Insert_Background"].Move(,,, H+Y-Gui_Margin*2)
Gui_Insert_ID := Gui_Insert.hwnd
Gui_Insert["Insert_TitleBar"].OnEvent("Click", Window_Move)
Gui_Insert["Insert_Boton"].OnEvent("Click", Gui_Insert_Next)

;   Esta GUI es la que se muestra insertada en la ventana que se seleccionó
Gui_Home := Gui("-Caption LastFound")
Gui_Home.BackColor := Color_Back
Gui_Home.MarginX := 21
Gui_Home.MarginY := 21
Gui_Home.SetFont("c" Color_TextDefault " q4 s11")
Gui_Home.Add("Text", "x0 y0 Background" Color_BackMenu " c" Color_TextMenu " vHome_TitleBar w" Width + Gui_Home.MarginX " h26 0x200 Center", "Mi GUI")
Gui_Home.Add("Text", "x" Background_Margin " y+" Background_Margin " Background" Color_Back2 " vHome_Background w" Width + Gui_Home.MarginX / 2 " h120 Center")
Gui_Home["Home_Background"].GetPos(, &Y,, &H)
Gui_Home.Add("CheckBox", "Background" Color_Back2 " " Style_CheckBox " vHome_Option1 Section x" Background_Margin + Objets_Margin " y" Y + Objets_Margin, "Opcion 1")
Gui_Home.Add("CheckBox", "Background" Color_Back2 " " Style_CheckBox " vHome_Option2 y+" Objets_Margin, "Opcion 2")
Gui_Home.Add("CheckBox", "Background" Color_Back2 " " Style_CheckBox " vHome_Option3 y+" Objets_Margin, "Opcion 3")
Gui_Home.Add("CheckBox", "Background" Color_Back2 " " Style_CheckBox " vHome_Option4 y+" Objets_Margin, "Opcion 4")
Gui_Home.SetFont("c" Color_Spaces " s15")
Gui_Home["Home_Option1"].GetPos(&X, &Y, &W)
Gui_Home.Add("Text", "BackgroundTrans vHome_Circle1 x" X+W + Objets_Margin/2 " ys y" Y+-Objets_Margin, "⚫")
Gui_Home["Home_Option2"].GetPos(&X, &Y, &W)
Gui_Home.Add("Text", "BackgroundTrans vHome_Circle2 x" X+W + Objets_Margin/2 " y" Y+-Objets_Margin, "⚫")
Gui_Home["Home_Option3"].GetPos(&X, &Y, &W)
Gui_Home.Add("Text", "BackgroundTrans vHome_Circle3 x" X+W + Objets_Margin/2 " y" Y+-Objets_Margin, "⚫")
Gui_Home["Home_Option4"].GetPos(&X, &Y, &W)
Gui_Home.Add("Text", "BackgroundTrans vHome_Circle4 x" X+W + Objets_Margin/2 " y" Y+-Objets_Margin, "⚫")
Gui_Home.SetFont("c" Color_TextButton " s12")
Gui_Home["Home_Circle1"].GetPos(&X, &Y)
Gui_Home.Add("Text", "BackgroundTrans x" X+2 " y" Y+3, "✏️")
Gui_Home["Home_Circle2"].GetPos(&X, &Y)
Gui_Home.Add("Text", "BackgroundTrans x" X+2 " y" Y+3, "✏️")
Gui_Home["Home_Circle3"].GetPos(&X, &Y)
Gui_Home.Add("Text", "BackgroundTrans x" X+2 " y" Y+3, "✏️")
Gui_Home["Home_Circle4"].GetPos(&X, &Y)
Gui_Home.Add("Text", "BackgroundTrans x" X+2 " y" Y+3, "✏️")
Gui_Home.Add("Text", "BackgroundTrans vHome_LastObject x" Background_Margin + Objets_Margin " y+-10 w" Width, "Pruebita")
Gui_Home["Home_LastObject"].GetPos(, &Y,, &H)
Gui_Home["Home_Background"].Move(,,, H+Y-Gui_Margin*2+Objets_Margin)
Gui_Home_ID := Gui_Home.hwnd
Gui_Home["Home_TitleBar"].OnEvent("Click", Window_Move)
Gui_Home["Home_Option1"].OnEvent("Click", Home_Toggle_Option1)






;   #####################################################################################
;   #########   Iniciar programa - Muestra ventana de selección de ventanas     #########
;   #####################################################################################

;   Mostrar la ventana de inyección
Gui_Insert.Show("w" Width + Gui_Insert.MarginX)
Gui_Insert.GetPos(,, &W, &H)

Reducer := 26
WinSetRegion "0-0 r" Gui_BorderRadious "-" Gui_BorderRadious " w" W+1 " H" H-Reducer, "ahk_id " Gui_Insert_ID
Hotkey "~" Hotkey_WindowSelect, WindowSelect, "On"
return

;   Selecionar una ventana y poner el nombre sin la extensión .exe en el cuadro
WindowSelect(*)
{
    MouseGetPos ,, &Window_ID
    if (Window_ID != Gui_Insert.hwnd)
    {
        Gui_Insert["Insert_Window"].Text := UpperFirst(CleanExtension(WinGetProcessName("ahk_id " Window_ID)))
        Gui_Insert["Insert_Window"].SetFont("c" Color_Success)
        Gui_Insert["Insert_Texto"].Text := "Para reemplazar la ventana haz clic en otra"
        Gui_Insert["Insert_Boton"].Enabled := true
        Global Window := Window_ID
    }
}






;   #########################################################################################################
;   #########   Cierra Gui de selección de ventanas - Abre ventana de activar/desactivar macros     #########
;   #########################################################################################################

Gui_Insert_Next(*)
{
    Gui_Insert["Insert_Boton"].Enabled := false
    Hotkey "~" Hotkey_WindowSelect, WindowSelect, "Off"
    Gui_Home.Opt("+Owner" Window)
    Gui_Insert.Destroy()
    Gui_Home.Show("Center w" Width + Gui_Home.MarginX)
    Gui_Home.GetPos(,, &W, &H)
    Reducer := 39

    ;Gui_Home.Move(,,, H-Reducer)
    WinSetRegion "0-0 r" Gui_BorderRadious "-" Gui_BorderRadious " w" W+1 " H" H-Reducer, "ahk_id " Gui_Home_ID
}






;   #########################################
;   #########   Auto Clic Cañones   #########
;   #########################################

;   Activar/Desactivar Auto click en cañones
Home_Toggle_Option1(*)
{
    if (Gui_Home["Home_CheckBox_Cannons"].Value)
    {
        HotIfWinActive "Ahk_id " Window
        Hotkey Hotkey_Cannon[1], Cannon1, "On"
        Hotkey Hotkey_Cannon[2], Cannon2, "On"
        Hotkey Hotkey_Cannon[3], Cannon3, "On"
        Hotkey Hotkey_Cannon[4], Cannon4, "On"
        HotIfWinActive
    }
    else
    {
        HotIfWinActive "Ahk_id " Window
        Hotkey Hotkey_Cannon[1], Cannon1, "Off"
        Hotkey Hotkey_Cannon[2], Cannon2, "Off"
        Hotkey Hotkey_Cannon[3], Cannon3, "Off"
        Hotkey Hotkey_Cannon[4], Cannon4, "Off"
        HotIfWinActive
    }
}

;   Hacer clic en el cañón
Cannon1(*)
{
    AutoClickCannon(1)
}
Cannon2(*)
{
    AutoClickCannon(2)
}
Cannon3(*)
{
    AutoClickCannon(3)
}

Cannon4(*)
{
    AutoClickCannon(RightCannonColumn)
    SendInput RightCannonHotkeys
}

AutoClickCannon(Column)
{
    if PixelSearch(&X, &Y, Cannons_Area[Column][1], Cannons_Area[Column][2], Cannons_Area[Column][3], Cannons_Area[Column][4], Cannons_Color)
    {
        ControlClick "X" X " Y" Y, Window
    }
    else
    {
        SoundBeep 270, 100
        ;SoundBeep 200, 60
        return
    }
}






;   ###########################################
;   #########   Funciones globales    #########
;   ###########################################

; Convertir primera letra de alguna cadena en mayúscula
UpperFirst(String)
{
    return StrUpper(SubStr(String, 1, 1)) SubStr(String, 2)
}

;   Limpiar extensión de una cadena (.exe .io .pdf y todo lo que esté desde el punto al final de la cadena hacia adelante)
CleanExtension(String)
{
    return SubStr(String, 1, InStr(String, ".",, -1, -1) - 1)
}

;   Mover la ventana activa
Window_Move(*)
{
    PostMessage 0xA1, 2
}






;   Acciones de acceso rápido temporales
NumpadAdd::Reload
NumpadAdd & ~Esc::ExitApp
