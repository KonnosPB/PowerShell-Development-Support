# Einführung
PSDevelopmentSupport ist ein Powershell Modul, das dir bei deiner Entwicklungsarbeit bei Kumavision im Kontext von Business Central hilft.

# Voraussetzungen
- Es wird ein [Github](https://github.com/) Account
- Es wird [PowerShell 7.4.1](https://github.com/PowerShell/PowerShell/releases/tag/v7.4.1) benötigt.
  _Ich habe das Modul mit dieser Version entwickelt. Andere Versionen könnten auch funktionieren, aber ich kann das nicht garantieren._

# Installation 

1. Klone das GIT Repository
``` bash
git clone https://github.com/KonnosPB/PSDevelopmentSupport.git
```

2. Importiere das Modul
``` Powershell
Import-Module <FullPath-To-ThisProject> -Force
```

Achtung: Das Wurzelverzeichnis muss PSDevelopmentSupport heißen, sonst bekommst du eine Fehlermeldung. 
Zum Beispiel: Install-Package: No match was found for the specified search criteria and module name  'C:\<pfad-mit-falschen-wurzelverzeichnis>\'. Try Get-PSRepository to see all available registered module repositories.