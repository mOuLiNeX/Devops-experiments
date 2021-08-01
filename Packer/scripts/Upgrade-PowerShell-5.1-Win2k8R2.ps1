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

$arguments = "/quiet /norestart"
    
Write-Log -message "running powershell update to version 5.1"
$url = "http://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7AndW2K8R2-KB3191566-x64.zip"

$filename = $url.Split("/")[-1]
$zip_file = "$tmp_dir\$filename"

Download-File -url $url -path $zip_file
Write-Log -message "extracting '$zip_file' to '$tmp_dir'"
$shell = New-Object -ComObject Shell.Application
$zip_src = $shell.NameSpace($zip_file)
$zip_dest = $shell.NameSpace($tmp_dir)
$zip_dest.CopyHere($zip_src.Items(), 1044)

$file = "$tmp_dir\Win7AndW2K8R2-KB3191566-x64.msu"
Write-Log -message "powershell update downloaded"





$exit_code = Run-Process -executable $file -arguments $arguments
Write-Log -message "powershell update executed, exit code = $exit_code"

if ($exit_code -ne 0 -and $exit_code -ne 3010) {
    $log_msg = "$($error_msg): exit code $exit_code"
    Write-Log -message $log_msg -level "ERROR"
    throw $log_msg
}   
