[string[]]$PowerShellModules = @("Pester", "posh-git", "platyPS", "InvokeBuild", "7Zip4Powershell")
[string[]]$PackageProviders = @('NuGet', 'PowerShellGet')
[string[]]$ChocolateyPackages = @('mkdocs')

# Line break for readability in AppVeyor console
Write-Host -Object ''

# Install package providers for PowerShell Modules
ForEach ($Provider in $PackageProviders) {
    If (-not (Get-PackageProvider $Provider -ErrorAction SilentlyContinue)) {
        Install-PackageProvider $Provider -Force -ForceBootstrap -Scope CurrentUser
    }
}

# Install the PowerShell Modules
ForEach ($Module in $PowerShellModules) {
    If (-not (Get-Module -ListAvailable $Module -ErrorAction SilentlyContinue)) {
        Install-Module $Module -Scope CurrentUser -Force -Repository PSGallery
    }
    Import-Module $Module
}

# Install Chocolatey
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Chocolatey packages
ForEach ($Package in $ChocolateyPackages) { choco install $Package -y --no-progress }