
source "virtualbox-iso" "win_server_2008_R2" {
  boot_wait        = "3m"
  cpus             = 2
  disk_size        = "20480"
  floppy_files     = ["./answer_files/WinServer2008R2/Autounattend.xml", "./scripts/hotfix-KB3140245.bat", "./scripts/hotfix-KB4474419.bat"]
  gfx_controller   = "vboxsvga"
  gfx_vram_size    = "64"
  guest_os_type    = "Windows2008_64"
  iso_checksum     = "sha1:d3fd7bf85ee1d5bdd72de5b2c69a7b470733cd0a"
  iso_url          = "iso/en_windows_server_2008_r2_with_sp1_x64_dvd_617601.iso"
  memory           = "4096"
  shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  guest_additions_mode = "attach"
  communicator      = "winrm"
  winrm_username    = "manu"
  winrm_password    = "m0uL!n3x"
}

build {
  sources = ["source.virtualbox-iso.win_server_2008_R2"]
  name = "windows server 2008"
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
    script         = "./scripts/Upgrade-PowerShell-5.1-Win2k8R2.ps1"
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
    scripts         = ["./scripts/Upgrade-winRM.ps1", "./scripts/EnableTLS12Win2k8R2.ps1"]
  }
  provisioner "windows-shell" {
    script         = "./scripts/disable-auto-logon.bat"
  }

}
