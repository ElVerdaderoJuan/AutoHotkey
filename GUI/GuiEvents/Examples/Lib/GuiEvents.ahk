;#Warn All, Off ; ← If you want it, use this for skip the errors (Not recomended)
#SingleInstance Force
GuiEvent := GuiEventsManager()



;   Clase para controlar las GUI
Class GuiEventsManager
{
    Move(*)
    {
        PostMessage 0xA1, 2
    }

    ; Create the same click event as 'OnEvent' but cancelable
    Close(*)
    {
        MouseGetPos(,,,&Control)
        if (Control)
        {
            KeyWait "LButton"
            MouseGetPos(,,,&NewControl)
            if (Control = NewControl)
            {
                PostMessage 0x10
            }
        }
    }
}



;   Create 'MouseHover'
Class MouseHover
{
    List := Array()

    __New()
    {
        ; Call MouseHoverControls when detecting 0x0200 (Mouse in the GUI)
        OnMessage 0x0200, SendToMouseHoverControls

        ; Receive the hwnd from the detected control from 'OnMessage'
        SendToMouseHoverControls(wParam, lParam, msg, hwnd)
        {
            This.hwnd := hwnd
            try
            {
                GuiEvents() ; You need create this function in your code for add actions when mouse is 'MouseHover'
            }
        }
    }

    ; Add a control for active the 'MouseHover' on this
    Add(Control)
    {
        This.List.Push Control.hwnd
    }

    ;MouseHoverClick
    Click()
    {
        
    }

    ; MouseHover para las opciones (Background, color, etc)
    Opt(DefaultOptions, NewOptions)
    {
        Static MouseIsHover := false ; The value it receives for the first time is 'false' and it remembers its values in this function
        Static MouseIsHoverOther := false ; The value it receives for the first time is 'false' and it remembers its values in this function

        if (GuiCtrlFromHwnd(This.hwnd)) ; Comprobar si el mouse está encima de un control
        {
            if (!MouseIsHover) ; Comprobar que el ID del control detectado está en la lista de controles para el MouseHover
            {
                if (This.IsInList())
                {
                    This.Control := GuiCtrlFromHwnd(This.hwnd) ; Actualiza el objeto
                    UpdateControl(NewOptions)
                    MouseIsHover := true ; Establecer como verdadero indicando que no se debe repetir esto
                    MouseIsHoverOther := false
                }
            }
            else if (!MouseIsHoverOther and (This.hwnd != This.Control.hwnd))
            {
                UpdateControl(DefaultOptions)
                MouseIsHoverOther := true ; Establecer como verdadero indicando que no se debe repetir esto
                LastControl := GuiCtrlFromHwnd(This.hwnd) ; Actualiza el objeto
                if (LastControl.hwnd != This.Control.hwnd)
                {
                    MouseIsHover := false
                }
            }
        }
        else if (MouseIsHover)
        {
            UpdateControl(DefaultOptions)
            MouseIsHover := false
        }

        UpdateControl(Options)
        {
            This.Control.Opt(Options)
            This.Control.Redraw()
        }
    }

    IsInList(Element := This.hwnd, List := this.List)
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
