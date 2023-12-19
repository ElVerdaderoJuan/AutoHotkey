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

;   MouseHover en botón de cerrar de las GUIs (Llamado por onMessage)
OnMessage 0x0200, SendToMouseHoverControls
OnMessage 0x02A3, SendToMouseHoverControls

SendToMouseHoverControls(wParam, lParam, msg, hwnd)
{
    Global MouseEvents_GuiControlHwnd := hwnd
    MouseHoverControls()
}

;   Clase para crear los MouseHover's
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

    Opt(DefaultOptions, NewOptions)
    {
        Global MouseEvents_GuiControlHwnd
        Static Control ; Recordar el control (El objeto) dentro de esta función
        static MouseIsHover := false ; El valor que recibe por primera vez es 'false' y recuerda sus valores en esta función
        static MouseIsHoverOther := false ; El valor que recibe por primera vez es 'false' y recuerda sus valores en esta función
        if (GuiCtrlFromHwnd(MouseEvents_GuiControlHwnd)) ; Comprobar si el mouse está encima de un control
        {
            if (!MouseIsHover) ; Comprobar que el ID del control detectado está en la lista de controles para el MouseHover
            {
                if (IsInList(MouseEvents_GuiControlHwnd, This.List))
                {
                    Control := GuiCtrlFromHwnd(MouseEvents_GuiControlHwnd) ; Actualiza el objeto
                    UpdateControl(NewOptions)
                    MouseIsHover := true ; Establecer como verdadero indicando que no se debe repetir esto
                    MouseIsHoverOther := false
                }
            }
            else if (!MouseIsHoverOther and !(IsInList(MouseEvents_GuiControlHwnd, This.List)))
            {
                UpdateControl(DefaultOptions)
                MouseIsHoverOther := true ; Establecer como verdadero indicando que no se debe repetir esto
            }
        }
        else if (MouseIsHover)
        {
            UpdateControl(DefaultOptions)
            MouseIsHover := false
        }

        UpdateControl(Options)
        {
            Control.Opt(Options)
            Control.Visible := false
            Control.Visible := true
        }

        IsInList(Element, List)
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
    }
}
