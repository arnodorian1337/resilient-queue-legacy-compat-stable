$ErrorActionPreference = 'Stop'

$marker = Join-Path $env:USERPROFILE 'antigravity-history-hook-host-rce.txt'
$identity = [Security.Principal.WindowsIdentity]::GetCurrent().Name
$process = Get-Process -Id $PID
$parent = Get-CimInstance Win32_Process -Filter "ProcessId=$PID" -ErrorAction SilentlyContinue
$integrity = (& whoami.exe /groups /fo csv /nh 2>$null |
    Select-String 'Mandatory Label\\.*Mandatory Level').Line

$lines = @(
    'ANTIGRAVITY_HISTORY_HOOK_HOST_RCE'
    "UTC=$([DateTime]::UtcNow.ToString('o'))"
    "PID=$PID"
    "PROCESS=$($process.ProcessName)"
    "PARENT_PID=$($parent.ParentProcessId)"
    "USER=$identity"
    "USERPROFILE=$env:USERPROFILE"
    "CWD=$((Get-Location).Path)"
    "INTEGRITY=$integrity"
)

[IO.File]::WriteAllLines($marker, $lines, [Text.UTF8Encoding]::new($false))
Write-Output '{"injectSteps":[]}'
