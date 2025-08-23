#SingleInstance Force
#Requires AutoHotkey v2

; =========================================================
; Paths (based on folder layout)
; =========================================================
cgomlSubDir   := A_ScriptDir
cgomlFilesDir := SubStr(A_ScriptDir, 1, InStr(A_ScriptDir, "\", 0, -1) - 1)
rootDir       := SubStr(cgomlFilesDir, 1, InStr(cgomlFilesDir, "\", 0, -1) - 1)

mainDir     := rootDir
modFilesDir := cgomlFilesDir "\Mods"
iniDir      := cgomlFilesDir "\INI"
activeIni   := iniDir "\mods.ini"
successSound:= cgomlFilesDir "incredible.wav"
failureSound:= cgomlFilesDir "failure.wav"


; =========================================================
; Ensure required folders exist
; =========================================================
if !DirExist(modFilesDir) {
    ;SoundPlay(failureSound, "false")
    MsgBox("❌ Mod Files folder not found:`n" modFilesDir)
    ExitApp()
}
if !DirExist(iniDir) {
    ;SoundPlay(failureSound, "false")
    MsgBox("❌ INI folder not found:`n" iniDir)
    ExitApp()
}

; =========================================================
; INI handling
; =========================================================
if !FileExist(activeIni)
    IniWrite("", activeIni, "State", "ActiveMod")

activeMod := IniRead(activeIni, "State", "ActiveMod", "")

; =========================================================
; Parse command line arguments
; =========================================================
if (A_Args.Length < 1) {
    ;SoundPlay(failureSound, "false")
    MsgBox("❌ No mod name provided.")
    ExitApp()
}
modName := Trim(A_Args[1])

if (modName = activeMod) {
    MsgBox("ℹ️ Mod '" modName "' is already active. Skipping copy...")
    RunGenerals()
    ExitApp()
}

modDir := modFilesDir "\" modName
if !DirExist(modDir) {
    ;SoundPlay(failureSound, "false")
    MsgBox("❌ Mod folder not found:`n" modDir)
    ExitApp()
}

; =========================================================
; Copy mod files (returns true/false)
; =========================================================
CopyModFiles(srcDir, destDir) {
    success := true
    Loop Files srcDir "\*.*", "R" {
        srcFile := A_LoopFileFullPath
        relPath := SubStr(srcFile, StrLen(srcDir) + 2)
        destFile := destDir "\" relPath

        SplitPath(destFile, , &destFolder)
        if !DirExist(destFolder)
            DirCreate(destFolder)

        ToolTip("Copying: " relPath)
        Sleep(50)

        try {
            FileCopy(srcFile, destFile, true)
        } catch {
            success := false
            ;SoundPlay(failureSound, "false")
            ToolTip("❌ Failed to copy: " relPath)
            Sleep(500)
            continue
        }

        ; Rename .gib → .big
        if RegExMatch(destFile, "\.gib$") {
            newFile := RegExReplace(destFile, "\.gib$", ".big")
            try {
                FileMove(destFile, newFile, true)
                ToolTip("Renamed: " relPath " → " newFile)
                Sleep(50)
            } catch {
                success := false
                ;SoundPlay(failureSound, "false")
                ToolTip("❌ Failed to rename: " relPath)
                Sleep(500)
            }
        }
    }
    ToolTip()
    return success
}

; =========================================================
; Delete old mod files
; =========================================================
DeleteOldModFiles(oldModName, srcDir, destDir) {
    if (oldModName = "")
        return
    oldDir := srcDir "\" oldModName
    if !DirExist(oldDir)
        return

    Loop Files oldDir "\*.*", "R" {
        relPath := SubStr(A_LoopFileFullPath, StrLen(oldDir) + 2)
        targetFile := destDir "\" relPath
        if FileExist(targetFile) {
            ToolTip("Deleting: " relPath)
            Sleep(50)
            FileDelete(targetFile)
        }
        else if RegExMatch(relPath, "\.gib$") {
            altTarget := destDir "\" RegExReplace(relPath, "\.gib$", ".big")
            if FileExist(altTarget) {
                ToolTip("Deleting leftover: " altTarget)
                Sleep(50)
                FileDelete(altTarget)
            }
        }
    }
    ToolTip()
}

; =========================================================
; Apply mod
; =========================================================
DeleteOldModFiles(activeMod, modFilesDir, mainDir)
if !CopyModFiles(modDir, mainDir) {
    ;SoundPlay(failureSound, "false")
    MsgBox("❌ Failed to fully apply mod '" modName "'.`nThe active mod has NOT been changed.")
    ExitApp()
}

IniWrite(modName, activeIni, "State", "ActiveMod")
;SoundPlay(successSound, "false")
MsgBox("✅ Mod '" modName "' applied successfully.`nAll old files removed, .gib renamed to .big.")

; =========================================================
; Launch Generals
; =========================================================
RunGenerals() {
    global mainDir
    exePath := mainDir "\GeneralsOnlineZH_30.exe"
    if !FileExist(exePath) {
        ;SoundPlay(failureSound, "false")
        MsgBox("❌ Cannot find Generals executable:`n" exePath)
        return
    }
    Run(exePath)
}

RunGenerals()
ExitApp()
