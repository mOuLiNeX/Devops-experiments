# Objectif

Par approche IaC, créer (et administrer) des VMs Windows sur VirtualBox avec les outils [Packer](https://www.packer.io/) et [Ansible](https://www.ansible.com/community). Les cibles seront Windows Server 2008 R2, Windows Server 2012 R2 ...

## Détail du build

Les VMs produites correspondent à des VMs Windows pouvant être utilisées par la suite dans des playbooks Ansible avec :
* WinRM (opérationnel pour Ansible)
* Remote Desktop
* Activation TLS 1.2 (surtout pour Windows Server 2008)
* [Chocolatey](https://chocolatey.org/)
* DotNet 4.5.2
* PowerShell 5.1

## ISOs :

Pour builder les VMs, il faudra se produrer les ISOs suivantes (par exemple sur https://download.my.visualstudio.com) :

| Distribution                                     	| Nom du fichier                                            	| SHA1                                     	|
|--------------------------------------------------	|-----------------------------------------------------------	|------------------------------------------	|
| Windows Server 2008 R2 with Service Pack 1 (x64) 	| en_windows_server_2008_r2_with_sp1_x64_dvd_617601.iso     	| d3fd7bf85ee1d5bdd72de5b2c69a7b470733cd0a 	|
| Windows server 2012 R2                           	| en_windows_server_2012_r2_with_update_x64_dvd_6052708.iso 	| 865494E969704BE1C4496D8614314361D025775E 	|

## Avant de lancer les builds

Saisir les clés d'activation dans les fichiers `Autounattend.xml` correspondant !

Changer (si besoin) les logins / mots de passes

# Lancement des builds

```
packer build windows_server2008-r2.pkr.hcl 
```

```
packer build windows_server2012-r2.pkr.hcl 
```

### Inspirations

https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1
https://github.com/joefitzgerald/packer-windows
https://github.com/jborean93/ansible-windows
https://people.redhat.com/mlessard/mtl/presentations/fev2018/AnsibleWindows.pdf