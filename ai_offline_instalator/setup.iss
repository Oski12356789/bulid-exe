; AI Offline Instalator - Inno Setup
#define MyAppName "AI Offline Instalator"
#define MyAppVersion "1.0.0"

[Setup]
AppId={{A7C1F1B8-8E21-4D54-8E47-3D8C5D1B7A20}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
DefaultDirName={localappdata}\AI Offline Instalator
DisableProgramGroupPage=yes
OutputDir=output
OutputBaseFilename=AI-Offline-Instalator-Setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
Uninstallable=no

[Files]
Source: "setup.ps1"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autodesktop}\AI Offline Instalator - konfiguracja"; Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\setup.ps1"""; WorkingDir: "{app}"

[Run]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\setup.ps1"""; WorkingDir: "{app}"; Description: "Pobierz i skonfiguruj lokalne AI"; Flags: postinstall waituntilterminated
