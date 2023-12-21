GuiEvent := GuiEvents()

;   Mover la ventana activa
Window_Move(*)
{
    PostMessage 0xA1, 2
}

SendToMouseHoverControls(wParam, lParam, msg, hwnd)
{
    Global MouseEvents_GuiControlHwnd := hwnd
    MouseHoverControls()
}

Class GuiEvents
{
    Move(*)
    {
        PostMessage 0xA1, 2
    }
}

;   Clase para crear los MouseHover's
Class MouseHover
{
    __New()
    {
        ; Recibir mensajes de Windows en las ventnaas
        OnMessage 0x0200, SendToMouseHoverControls
        OnMessage 0x02A3, SendToMouseHoverControls
        This.List := Array()
    }

    Add(hwnd)
    {
        This.List.Push hwnd
    }

    Opt(DefaultOptions, NewOptions)
    {
        Global MouseEvents_GuiControlHwnd
        Static Control ; Recordar el control (El objeto) dentro de esta función
        ;Static thisGui
        Static MouseIsHover := false ; El valor que recibe por primera vez es 'false' y recuerda sus valores en esta función
        Static MouseIsHoverOther := false ; El valor que recibe por primera vez es 'false' y recuerda sus valores en esta función
        if (GuiCtrlFromHwnd(MouseEvents_GuiControlHwnd)) ; Comprobar si el mouse está encima de un control
        {
            if (!MouseIsHover) ; Comprobar que el ID del control detectado está en la lista de controles para el MouseHover
            {
                if (This.IsInList())
                {
                    Control := GuiCtrlFromHwnd(MouseEvents_GuiControlHwnd) ; Actualiza el objeto
                    UpdateControl(NewOptions)
                    MouseIsHover := true ; Establecer como verdadero indicando que no se debe repetir esto
                    MouseIsHoverOther := false
                }
            }
            else if (!MouseIsHoverOther and (MouseEvents_GuiControlHwnd != Control.hwnd))
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
    }

    IsInList(Element := MouseEvents_GuiControlHwnd, List := this.List)
    {
        ;Global MouseEventsListIndex := 0
        for ElementFound in List
        {
            if (ElementFound = Element)
            {
                ;MouseEventsListIndex++
                return true
            }
        }
        return false
    }
}
