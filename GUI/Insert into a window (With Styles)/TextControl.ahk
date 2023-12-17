; Esta librería de AutoHotkey modifica texto
; 👇 Copie la línea de abajo y péguela en el script
; #Include TextControlFunctions.ahk

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