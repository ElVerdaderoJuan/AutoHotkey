;   Mover la ventana activa
Window_Move(*)
{
    PostMessage 0xA1, 2
}

;   Terminar aplicación al cerrar la GUI
Window_Close(*)
{
    ExitApp
}

;   Comprobar si un elemento existe dentro de una lista
isInList(Element, List)
{
    for ElementFound in List
    {
        if (ElementFound = Element)
        {
            return true
        }
    }
    return false
}

;   MouseHover en botón de cerrar de las GUIs (Llamado por onMessage)
OnMessage 0x0200, CallMouseHover

CallMouseHover(wParam, lParam, msg, hwnd)
{
    MouseHoverControl.Hover(hwnd)
}

Class MouseHover
{
    __New()
    {
        This.List := Array()
    }

    AddControl(hwnd)
    {
        This.List.Push hwnd
    }

    Hover(hwnd)
    {
        Static Control ; Recordar el control (El objeto) dentro de esta función
        static MouseIsHover := false ; El valor que recibe por primera vez es 'false' y recuerda sus valores en esta función
        if (GuiCtrlFromHwnd(hwnd)) ; Comprobar si el mouse está encima de un control
        {
            if (MouseIsHover = false and (isInList(hwnd, This.List))) ; Comprobar que el ID del control detectado está en la lista de controles para el MouseHover
            {
                Control := GuiCtrlFromHwnd(hwnd) ; Actualiza el objeto
                Control.Opt("+Background" Color_MenuButtonX_MouseHover)
                Control.Visible := false
                Control.Visible := true
                MouseIsHover := true ; Establecer como verdadero a MouseIsHover indicando que no se debe repetir esto
            }
        }
        else if (MouseIsHover)
        {
            Control.Opt("+Background" Color_MenuButton)
            Control.Visible := false
            Control.Visible := true
            MouseIsHover := false ; Establecer como falso a MouseIsHover indicando que no se debe repetir esto
        }
    }
}