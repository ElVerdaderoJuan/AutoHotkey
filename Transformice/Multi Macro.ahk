#Requires AutoHotkey v2.0
#SingleInstance Force
;CoordMode "Pixel", "Screen" ; La posición del mouse se obtiene en relación a la pantalla









;   #################################
;   #########   Variables   #########
;   #################################

;   GUIs
Width := 198
Background_Margin := 6
Objets_Margin := 6
Game_Window := "A"

;   Colores de las GUIs
Color_Back := "543B2C"          ; Fondo
Color_Back2 := "122529"         ; Fondo encima del fondo
Color_Back3 := "323747"         ; Fondo 2
Color_BackMenu := "3E2B20"      ; Fondo del MenuBar
Color_TextMenu := "FFD991"      ; Texto del MenuBAr
Color_TextDefault := "C2C2DA"   ; Texto por defecto
Color_Spaces := "1C3A40"        ; Fondo de espacios especiales
Color_Advice := "6C77C1"        ; Texto de aviso o sugerencia
Color_Error := "FF4A4A"         ; Texto de error

;   Hotkeys (Teclas de acceso rápido)
Hotkey_Toggle_Cannons := "~Numpad0 & ~F1"
Hotkey_Toggle_Places := "~Numpad0 & ~C"
Hotkey_Cannon := [
    "F1",   ; Cañón izquierda
    "F2",   ; Cañón centro
    "F3",   ; Cañón derecho
    "F4"    ; Cañón hacia arriba
]
Hotkey_WindowSelect := "LButton"
RightCannonColumn := 3 ; Columna en donde se encuentra el cañón que apunta hacia la derecha (Objetivo: Obtenerlo y hacer que apunte hacia arriba)
RightCannonHotkeys := "zzzzzz" ; Las teclas que se presionan cuando se selecciona el cañón de la variable RightCannonColumn
Hotkey_SetPos := [  ; Teclas de acceso rápido para guardar posición del mouse para Auto Clic en un lugar
    "Z",
    "C"
]
Hotkey_GoPos := [   ; Teclas de acceso rápido para ir a la posición del mouse para Auto Clic en un lugar
    "Q",
    "E"
]
Places_X1 := 0
Places_Y1 := 0
Places_X2 := 0
Places_Y2 := 0

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

;   Ventana de selección de juego inicial
Gui_Inyeccion := Gui("-Caption LastFound AlwaysOnTop")
Gui_Inyeccion.BackColor := Color_Back ;122529
Gui_Inyeccion.MarginX := 21
Gui_Inyeccion.MarginY := 21
Gui_Inyeccion.SetFont("c" Color_TextDefault " q4 s11") ;  Other font 8888FF
Gui_Inyeccion.Add("Text", "x0 y0 Background" Color_BackMenu " c" Color_TextMenu " vInyeccion_TitleBar w" Width + Gui_Inyeccion.MarginX " h26 0x200 Center", "Agregar ventana")
Gui_Inyeccion.Add("Text", "x" Background_Margin " y+" Background_Margin " Background" Color_Back2 " vInyeccion_Background w" Width + Gui_Inyeccion.MarginX / 2 " h120 Center")
Gui_Inyeccion["Inyeccion_Background"].GetPos(, &Y,, &H)
Gui_Inyeccion.Add("Text", "BackgroundTrans w" Width " vInyeccion_Texto Section x" Background_Margin + Objets_Margin " y" Y + Objets_Margin, "Haz clic en el juego para añadir la ventana")
Gui_Inyeccion.Add("Text", "Background" Color_Spaces " c" Color_Advice " Center w" Width " vInyeccion_Window y+" Objets_Margin, "Sin seleccionar")
Gui_Inyeccion.Add("Button", "Background" Color_TextMenu " vInyeccion_Boton w" Width " Disabled", "Continuar")
Gui_Inyeccion.Add("Text", "BackgroundTrans vInyeccion_LastObject x" Background_Margin + Objets_Margin " y+0 w" Width)
Gui_Inyeccion["Inyeccion_Window"].GetPos(,,, &H)
Gui_Inyeccion["Inyeccion_Window"].Move(,,, H*1.4)
Gui_Inyeccion["Inyeccion_LastObject"].GetPos(, &Y,, &H)
Gui_Inyeccion["Inyeccion_Background"].Move(,,, H+Y-42)
Gui_Inyeccion_ID := Gui_Inyeccion.hwnd
Gui_Inyeccion["Inyeccion_TitleBar"].OnEvent("Click", Window_Move)
Gui_Inyeccion["Inyeccion_Boton"].OnEvent("Click", Gui_Inyeccion_Next)

;   ----------------------------------------------

;   Ventana inicial para activar/desactivar macros
Gui_Inicio := Gui("-Caption LastFound")
Gui_Inicio.BackColor := Color_Back ;122529
Gui_Inicio.MarginX := 21
Gui_Inicio.MarginY := 21
Gui_Inicio.SetFont("c" Color_TextDefault " q4 s11") ;  Other font 8888FF
Gui_Inicio.Add("Text", "x0 y0 Background" Color_BackMenu " c" Color_TextMenu " vInicio_TitleBar w" Width + Gui_Inicio.MarginX " h26 0x200 Center", "Multi Macro TFM")
Gui_Inicio.Add("Text", "x" Background_Margin " y+" Background_Margin " Background" Color_Back2 " vInicio_Background w" Width + Gui_Inicio.MarginX / 2 " h120 Center")
Gui_Inicio["Inicio_Background"].GetPos(, &Y,, &H)
Gui_Inicio.Add("CheckBox", "Background" Color_Back2 " 0x8000 vInicio_CheckBox_Cannons Section x" Background_Margin + Objets_Margin " y" Y + Objets_Margin, "Auto clic cañones")
Gui_Inicio.Add("CheckBox", "Background" Color_Back2 " 0x8000 vInicio_CheckBox_Objets y+" Objets_Margin, "Auto clic en color")
Gui_Inicio.Add("CheckBox", "Background" Color_Back2 " 0x8000 vInicio_CheckBox_Places y+" Objets_Margin, "Auto clic en un lugar")
Gui_Inicio.Add("CheckBox", "Background" Color_Back2 " 0x8000 vInicio_CheckBox_Clicks y+" Objets_Margin, "Múltiples clicks")
Gui_Inicio.Add("CheckBox", "Background" Color_Back2 " 0x8000 vInicio_CheckBox_Move y+" Objets_Margin, "Moverse infinitamente")
Gui_Inicio.SetFont("c" Color_Spaces " s15")
Gui_Inicio.Add("Text", "BackgroundTrans vInicio_Circle1 ys y" Y + 1, "⚫")
Gui_Inicio.Add("Text", "BackgroundTrans vInicio_Circle2 y+-" Objets_Margin/2, "⚫")
Gui_Inicio.Add("Text", "BackgroundTrans vInicio_Circle3 y+-" Objets_Margin/2, "⚫")
Gui_Inicio.Add("Text", "BackgroundTrans vInicio_Circle4 y+-" Objets_Margin/2, "⚫")
Gui_Inicio.Add("Text", "BackgroundTrans vInicio_Circle5 y+-" Objets_Margin/2, "⚫")
Gui_Inicio.SetFont("c" Color_TextMenu " s12")
Gui_Inicio["Inicio_Circle1"].GetPos(&X, &Y)
Gui_Inicio.Add("Text", "BackgroundTrans x" X+2 " y" Y+3, "✏️")
Gui_Inicio["Inicio_Circle2"].GetPos(&X, &Y)
Gui_Inicio.Add("Text", "BackgroundTrans x" X+2 " y" Y+3, "✏️")
Gui_Inicio["Inicio_Circle3"].GetPos(&X, &Y)
Gui_Inicio.Add("Text", "BackgroundTrans x" X+2 " y" Y+3, "✏️")
Gui_Inicio["Inicio_Circle4"].GetPos(&X, &Y)
Gui_Inicio.Add("Text", "BackgroundTrans x" X+2 " y" Y+3, "✏️")
Gui_Inicio["Inicio_Circle5"].GetPos(&X, &Y)
Gui_Inicio.Add("Text", "BackgroundTrans x" X+2 " y" Y+3, "✏️")
Gui_Inicio.Add("Text", "BackgroundTrans vInicio_LastObject x" Background_Margin + Objets_Margin " y+0 w" Width)
Gui_Inicio["Inicio_LastObject"].GetPos(, &Y,, &H)
Gui_Inicio["Inicio_Background"].Move(,,, H+Y-42)
Gui_Inicio_ID := Gui_Inicio.hwnd
Gui_Inicio["Inicio_TitleBar"].OnEvent("Click", Window_Move)
Gui_Inicio["Inicio_CheckBox_Cannons"].OnEvent("Click", Inicio_Toggle_Cannons)
Gui_Inicio["Inicio_CheckBox_Places"].OnEvent("Click", Inicio_Toggle_Places)

Gui_Notice := Gui("-Caption LastFound")
Gui_Notice.BackColor := Color_Back3 ;122529
Gui_Notice.MarginX := 21
Gui_Notice.MarginY := 21
Gui_Notice.SetFont("c" Color_TextDefault " q4 s11") ;  Other font 8888FF
Gui_Notice.Add("Text", "BackgroundTrans 0x8000 Center vNotice_Texto Section x0 y0", "Posición 1 cambiada")
Gui_Notice_ID := Gui_Notice.hwnd









;   #####################################################################################
;   #########   Iniciar programa - Muestra ventana de selección de ventanas     #########
;   #####################################################################################

;   Mostrar la ventana de inyección
Gui_Inyeccion.Show("w" Width + Gui_Inyeccion.MarginX)
Gui_Inyeccion.GetPos(,, &W, &H)
Gui_Inyeccion.Move(,,, H-24)
WinSetRegion "0-0 r15-15 w" W+1 " H" H-24, "ahk_id " Gui_Inyeccion_ID
Hotkey "~" Hotkey_WindowSelect, WindowSelect, "On"
return



;   Selecionar una ventana y poner el nombre sin la extensión .exe en el cuadro
WindowSelect(*)
{
    MouseGetPos ,, &Window
    if (Window != Gui_Inyeccion.hwnd)
    {
        Gui_Inyeccion["Inyeccion_Window"].Text := UpperFirst(CleanExtension(WinGetProcessName("ahk_id " Window)))
        Gui_Inyeccion["Inyeccion_Window"].SetFont("c" Color_TextMenu)
        Gui_Inyeccion["Inyeccion_Texto"].Text := "Si quieres cambiar la ventana haz clic en otra"
        Gui_Inyeccion["Inyeccion_Boton"].Enabled := true
        Global Game_Window := Window
    }
}









;   #########################################################################################################
;   #########   Cierra Gui de selección de ventanas - Abre ventana de activar/desactivar macros     #########
;   #########################################################################################################

Gui_Inyeccion_Next(*)
{
    Gui_Inyeccion["Inyeccion_Boton"].Enabled := false
    Hotkey "~" Hotkey_WindowSelect, WindowSelect, "Off"
    ;Gui_Inyeccion.GetPos(&X, &Y)
    WinGetPos &X, &Y, &W, &H, "ahk_id " Game_Window
    Gui_Inicio.Opt("+Parent" Game_Window)
    Gui_Notice.Opt("+Parent" Game_Window)
    HotIfWinActive "Ahk_id " Game_Window
    Hotkey Hotkey_Toggle_Cannons, LabelHotkey_Toggle_Cannons, "On"
    Hotkey Hotkey_Toggle_Places, LabelHotkey_Toggle_Places, "On"
    HotIfWinActive
    Gui_Inyeccion.Destroy()
    Gui_Inicio.Show("X" (X+W)/100*6 " Y" (Y+H)/100*18 " w" Width + Gui_Inicio.MarginX)
    Gui_Inicio.GetPos(,, &W, &H)
    Gui_Inicio.Move(,,, H-24)
    WinSetRegion "0-0 r15-15 w" W+1 " H" H-24, "ahk_id " Gui_Inicio_ID
}








;   #########################################
;   #########   Auto Clic Cañones   #########
;   #########################################

;   Activar/Desactivar Auto click en cañones
Inicio_Toggle_Cannons(*)
{
    if (Gui_Inicio["Inicio_CheckBox_Cannons"].Value)
    {
        Activate_Cannons(true)
    }
    else
    {
        Activate_Cannons(false)
    }
}

LabelHotkey_Toggle_Cannons(*)
{
    if (Gui_Inicio["Inicio_CheckBox_Cannons"].Value)
    {
        Gui_Inicio["Inicio_CheckBox_Cannons"].Value := false
        Activate_Cannons(false)
    }
    else
    {
        Gui_Inicio["Inicio_CheckBox_Cannons"].Value := true
        Activate_Cannons(true)
    }
}

Activate_Cannons(Bool)
{
    if (Bool)
    {
        HotIfWinActive "Ahk_id " Game_Window
        Hotkey Hotkey_Cannon[1], Cannon1, "On"
        Hotkey Hotkey_Cannon[2], Cannon2, "On"
        Hotkey Hotkey_Cannon[3], Cannon3, "On"
        Hotkey Hotkey_Cannon[4], Cannon4, "On"
        HotIfWinActive
    }
    else
    {
        HotIfWinActive "Ahk_id " Game_Window
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
        ;ControlClick "X" X " Y" Y, Game_Window
        MouseGetPos &Xi, &Yi
        Click X, Y
        MouseMove Xi, Yi
    }
    else
    {
        SoundBeep 270, 100
        ;SoundBeep 200, 60
        return
    }
}









;   #########################################
;   #########   Auto Clic en color  #########
;   #########################################

;    ;









;   #############################################
;   #########   Auto Clic en un lugar   #########
;   #############################################

;   Toggle
Inicio_Toggle_Places(*)
{
    if (Gui_Inicio["Inicio_CheckBox_Places"].Value)
    {
        Activate_Places(true)
    }
    else
    {
        Activate_Places(false)
    }
}

LabelHotkey_Toggle_Places(*)
{
    if (Gui_Inicio["Inicio_CheckBox_Places"].Value)
    {
        Gui_Inicio["Inicio_CheckBox_Places"].Value := false
        Activate_Places(false)
    }
    else
    {
        Gui_Inicio["Inicio_CheckBox_Places"].Value := true
        Activate_Places(true)
    }
}

Activate_Places(Boolean)
{
    if (Boolean)
    {
        HotIfWinActive "Ahk_id " Game_Window
        Hotkey Hotkey_SetPos[1], SetPos1, "On"
        Hotkey Hotkey_SetPos[2], SetPos2, "On"
        Hotkey Hotkey_GoPos[1], GoPos1, "On"
        Hotkey Hotkey_GoPos[2], GoPos2, "On"
        HotIfWinActive
    }
    else
    {
        HotIfWinActive "Ahk_id " Game_Window
        Hotkey Hotkey_SetPos[1], SetPos1, "Off"
        Hotkey Hotkey_SetPos[2], SetPos2, "Off"
        Hotkey Hotkey_GoPos[1], GoPos1, "Off"
        Hotkey Hotkey_GoPos[2], GoPos2, "Off"
        HotIfWinActive
    }
}

SetPos1(*)
{
    Global
    MouseGetPos &Places_X1, &Places_Y1
    Notice("Posicion 1 Guardado", 300)
}

SetPos2(*)
{
    Global
    MouseGetPos &Places_X2, &Places_Y2
    Notice("Posicion 2 Guardado", 300)
}

GoPos1(*)
{
    MouseGetPos &Xi, &Yi
    Click Places_X1, Places_Y1
    MouseMove Xi, Yi
}

GoPos2(*)
{
    MouseGetPos &Xi, &Yi
    Click Places_X2, Places_Y2
    MouseMove Xi, Yi
}









;   ###########################################
;   #########   Funciones globales    #########
;   ###########################################

; Convertir primera letra de alguna cadena en mayúscula
UpperFirst(String)
{
    return StrUpper(SubStr(String, 1, 1)) SubStr(String, 2)
}

; Limpiar extensión de una cadena (.exe .io .pdf y todo lo que esté desde el punto al final de la cadena hacia adelante)
CleanExtension(String)
{
    return SubStr(String, 1, InStr(String, ".",, -1, -1) - 1)
}

;   Anuncio con texto
Notice(String, Time)
{
    Gui_Notice["Notice_Texto"].Text := String
    Gui_Notice.Show("w" Width + Gui_Notice.MarginX " Center")
    Gui_Notice.GetPos(,,, &H)
    Gui_Notice["Notice_Texto"].GetPos(,, &W)
    Gui_Notice["Notice_Texto"].Move(,, W, H*1.5)
    Gui_Notice["Notice_Texto"].Opt(-0x8000 " -Center")
    Gui_Notice["Notice_Texto"].Opt(+0x8000 " Center")
    WinSetRegion "0-0 r15-15 w" W*1.3 " H" (H*1.5)-21, "ahk_id " Gui_Notice_ID
    Gui_Notice.Hide()
    Gui_Notice.show("Center")
    Sleep Time
    Gui_Notice.Hide()
}

;   Mover la ventana activa
Window_Move(*)
{
    PostMessage 0xA1, 2
}









;   Acciones de acceso rápido temporales
NumpadAdd::Reload
NumpadAdd & ~Esc::ExitApp
