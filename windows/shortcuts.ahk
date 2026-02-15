#SingleInstance Force


; ----- EMACS ----
; Start Emacs & Open misc_todos.org
^!e:: { ; Ctrl + Alt + E
   Run 'C:\Program Files\WSL\wslg.exe -d Ubuntu-24.04 -- ~/.nix-profile/bin/emacsclient -cn'
}

; Capture TODO and kill 
^!c:: { ; Ctrl + Alt + C
   Run 'C:\Program Files\WSL\wslg.exe -d Ubuntu-24.04 -- ~/.nix-profile/bin/emacsclient -ce "(org-capture nil \"k\")"'
}

; Capture link in background
^!l:: {  ; Ctrl + Alt + L
    A_Clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.    
    Send "^l^c"
    if !ClipWait(1) {
        MsgBox "Clipboard did not receive data."
        return
    }

    if !RegExMatch(A_Clipboard, "^(https?|file)://") {
        MsgBox "Clipboard does not look like a link:`n`n" A_Clipboard,
               "Org capture",
               "Icon!"
        return
    }
    Run '"C:\Program Files\WSL\wslg.exe" -d Ubuntu-24.04 -- ~/.nix-profile/bin/emacsclient -n -e "(org-capture nil \"l\")"'
}


; ----- Micro$oft stuff ------ 
^!m:: { ; Ctrl + Alt + O
    ; /c ipm.note tells Outlook to create a new mail item
    Run "outlook.exe /c ipm.note"
}


^!t:: { ; Ctrl + Alt + T
    ; This uses the Microsoft Teams URI scheme to trigger a new chat
    Run "msteams:/l/chat/0/0?users="
}