
source "virtualbox-iso" "win_server_2012_R2" {
  boot_wait        = "3m"
  cpus             = 2
  disk_size        = "20480"
  floppy_files     = ["./answer_files/WinServer2012R2/Autounattend.xml"]
  gfx_controller   = "vboxsvga"
  gfx_vram_size    = "64"
  guest_os_type    = "Windows2012_64"
  iso_checksum     = "sha1:865494E969704BE1C4496D8614314361D025775E"
  iso_url          = "iso/en_windows_server_2012_r2_with_update_x64_dvd_6052708.iso"
  memory           = "4096"
  shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  guest_additions_mode = "attach" 
  communicator      = "winrm"
  winrm_username    = "manu"
  winrm_password    = "m0uL!n3x"
}

build {
  sources = ["source.virtualbox-iso.win_server_2012_R2"]
  name = "windows server 2012"
  provisioner "windows-shell" {
    script         = "./scripts/enable-rdp.bat"
  }
  provisioner "windows-shell" {    
    inline         = [
      "E:",
      "CD cert",
      "VBoxCertUtil.exe add-trusted-publisher vbox*.cer --root vbox*.cer",
      "CD ..",
      "VBoxWindowsAdditions.exe /S"]
  }
  provisioner "powershell" {
    elevated_user = "manu"  
    elevated_password = "m0uL!n3x"
    execution_policy = "unrestricted"
    script         = "./scripts/Upgrade-DotNet-4.5.2.ps1"
  }
  provisioner "windows-restart" {
    restart_timeout  = "5m"
  }
  provisioner "powershell" {
    elevated_user = "manu"  
    elevated_password = "m0uL!n3x"
    execution_policy = "unrestricted"
    script         = "./scripts/Upgrade-PowerShell-5.1-Win2012R2.ps1"
  }
  provisioner "windows-restart" {
    restart_timeout  = "5m"
  }
  provisioner "powershell" {
    elevated_user = "manu"  
    elevated_password = "m0uL!n3x"
    execution_policy = "unrestricted"
    inline = [
      "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12",
      "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"]
  }
  provisioner "powershell" {
    elevated_user = "manu"  
    elevated_password = "m0uL!n3x"
    execution_policy = "unrestricted"
    script         = "./scripts/Upgrade-winRM.ps1"
  }
  provisioner "windows-shell" {
    script         = "./scripts/disable-auto-logon.bat"
  }
}
