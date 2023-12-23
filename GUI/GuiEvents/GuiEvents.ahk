;#Warn All, Off ; ← If you want it, use this for skip the errors (Not recomended)
#SingleInstance Force
GuiEvent := GuiEvents()



;   Clase para controlar las GUI
Class GuiEvents
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
                MouseHoverControls() ; You need create this function in your code for add actions when mouse is 'MouseHover'
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
        Static Control ; Recordar el control (El objeto) dentro de esta función
        Static MouseIsHover := false ; El valor que recibe por primera vez es 'false' y recuerda sus valores en esta función
        Static MouseIsHoverOther := false ; El valor que recibe por primera vez es 'false' y recuerda sus valores en esta función

        if (GuiCtrlFromHwnd(This.hwnd)) ; Comprobar si el mouse está encima de un control
        {
            if (!MouseIsHover) ; Comprobar que el ID del control detectado está en la lista de controles para el MouseHover
            {
                if (This.IsInList())
                {
                    Control := GuiCtrlFromHwnd(This.hwnd) ; Actualiza el objeto
                    ThisGui := Control.Gui
                    UpdateControl(NewOptions)
                    MouseIsHover := true ; Establecer como verdadero indicando que no se debe repetir esto
                    MouseIsHoverOther := false
                }
            }
            else if (!MouseIsHoverOther and (This.hwnd != Control.hwnd))
            {
                LastControl := GuiCtrlFromHwnd(This.hwnd) ; Actualiza el objeto
                if (LastControl.hwnd != Control.hwnd)
                {
                    MouseIsHover := false
                }
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