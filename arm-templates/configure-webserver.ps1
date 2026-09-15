# 1. Install IIS and Management Tools
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# 2. Open HTTP Port 80 in Windows Defender Firewall
New-NetFirewallRule -DisplayName "Allow HTTP Port 80" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 80

# 3. Clean out default IIS landing page
Remove-Item -Path "C:\inetpub\wwwroot\*" -Recurse -Force

# 4. Download site files from GitHub
$zipUrl = "https://github.com/JaBarryII/oaknetworkingsolutions/archive/refs/heads/main.zip"
$zipDestination = "$env:TEMP\site.zip"
$extractPath = "$env:TEMP\site-extracted"

Invoke-WebRequest -Uri $zipUrl -OutFile $zipDestination
Expand-Archive -Path $zipDestination -DestinationPath $extractPath -Force

# 5. Copy extracted web content to IIS root
$extractedFolder = Get-ChildItem -Path $extractPath | Select-Object -First 1
Copy-Item -Path "$($extractedFolder.FullName)\*" -Destination "C:\inetpub\wwwroot" -Recurse -Force

# 6. Clean up temporary files
Remove-Item -Path $zipDestination -Force
Remove-Item -Path $extractPath -Recurse -Force