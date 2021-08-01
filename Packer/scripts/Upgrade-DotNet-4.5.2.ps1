$ErrorActionPreference = 'Stop'
$VerbosePreference = "Continue"

$tmp_dir = $env:temp
if (-not (Test-Path -Path $tmp_dir)) {
    New-Item -Path $tmp_dir -ItemType Directory > $null
}

Function Write-Log($message, $level="INFO") {
    # Poor man's implementation of Log4Net
    $date_stamp = Get-Date -Format s
    $log_entry = "$date_stamp - $level - $message"
    $log_file = "$tmp_dir\upgrade_powershell.log"
    Write-Verbose -Message $log_entry
    Add-Content -Path $log_file -Value $log_entry
}

Function Run-Process($executable, $arguments) {
    $process = New-Object -TypeName System.Diagnostics.Process
    $psi = $process.StartInfo
    $psi.FileName = $executable
    $psi.Arguments = $arguments
    Write-Log -message "starting new process '$executable $arguments'"
    $process.Start() | Out-Null
    
    $process.WaitForExit() | Out-Null
    $exit_code = $process.ExitCode
    Write-Log -message "process completed with exit code '$exit_code'"

    return $exit_code
}

Function Download-File($url, $path) {
    Write-Log -message "downloading url '$url' to '$path'"
    $client = New-Object -TypeName System.Net.WebClient
    $client.DownloadFile($url, $path)
}


Write-Log -message "running .NET update to 4.5.2"
$url = "https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
$error_msg = "failed to update .NET to 4.5.2"
$arguments = "/q /norestart"


$filename = $url.Split("/")[-1]
$file = "$tmp_dir\$filename"
Download-File -url $url -path $file
Write-Log -message ".NET update downloaded"


$exit_code = Run-Process -executable $file -arguments $arguments
Write-Log -message ".NET update executed, exit code = $exit_code"

if ($exit_code -ne 0 -and $exit_code -ne 3010) {
    $log_msg = "$($error_msg): exit code $exit_code"
    Write-Log -message $log_msg -level "ERROR"
    throw $log_msg
}