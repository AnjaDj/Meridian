# Konfiguracija i kompajliranje Linux kernela

Prvo je potrebno da preuzmemo Linux source kod sa zvanicnog Altera-fpga [linux-socfpga](https://github.com/altera-fpga/linux-socfpga/tree/socfpga-6.1.38-lts)
repozitorijuma
```
git clone https://github.com/altera-fpga/linux-socfpga/tree/socfpga-6.1.38-lts
cd linux-socfpga
git checkout socfpga-6.1.38-lts
```
Za ispravnu konfiguraciju i kroskompajliranje Linux kernela, potrebno je da eksportujemo putanju do kroskompajlera i da postavimo varijablu `CROSS_COMPILE`
tako da odgovara prefiksu našeg kroskompajlera, te da ispravno definišemo arhitekturu (varijabla `ARCH`).
Koristimo skriptu [set-environment.sh](../scripts/set-environment.sh) iz scripts foldera u repozitorijumu.

Za Cyclone V platformu, najbliža predefinisana konfiguracija je `socfpga_defconfig`, pa se ona preporučuje kao polazna za konfiguraciju Linux kernela.
```
make socfpga_defconfig
make menuconfig
```

Prvo ćemo definisati lokalnu verziju kernela tako što postavljamo opciju 
**General setup-Local version-append to kernel release** (parametar CONFIG_LOCALVERSION) na `-etfbl-lab`.
U istoj kategoriji, isključite opciju **Automatically append version information to the version string** ako je omogućena.

U sklopu kategorije **Boot options**, pronađite opciju **Default kernel command string** i postavite neki proizvoljan string (npr. `console`).
Ispod ove opcije će se pojaviti nova stavka pod nazivom **Kernel command line type**, koju trebate postaviti na **Use bootloader kernel arguments if available**.
Na ovaj način definišemo da kernel dobija argumente komandne linije isključivo od bootloader-a (konfiguracioni parametar CONFIG_CMDLINE_FROM_BOOTLOADER).

Ukoliko se odlucimo da omogucimo podizanje sistema preko NFS servera, provjerite konfiguraciju kernela i potvrdite da su omogućene sljedeće opcije:
- `CONFIG_NFS_FS`: opcija **File systems→Network File Systems→NFS client support** u konfiguraciji koja omogućava podršku za komunikaciju sa NFS klijentom,
- `CONFIG_ROOT_NFS`: opcija **File systems→Network File Systems→Root file system on NFS** u konfiguraciji koja omogućava podizanje sistema kada se root fajl sistem nalazi na NFS serveru
- `CONFIG_IP_PNP`: opcija **Networking support→Networking options→IP: kernel level autoconfiguration** u konfiguraciji koja omogućava dodjeljivanje IP adrese tokom rane faze podizanja sistema, prije montiranja root fajl sistema
- `CONFIG_DEVTMPFS`: opcija **Device Drivers→Generic Driver Options→Maintain a devtmpfs filesystem to mount at /dev** u konfiguraciji koja kreira instancu devtmpfs fajl sistema u ranoj fazi podizanja sistema i
- `CONFIG_DEVTMPFS_MOUNT`: opcija **Device Drivers→Generic Driver Options→Automount devtmpfs at /dev, after the kernel mounted the rootfs** u konfiguraciji koja govori kernelu da automatski montira devtmpfs virtuelni fajl sistem nakon montiranja root fajl sistema.



Sada možemo sačuvati trenutnu konfiguraciju kernela kao predefinisanu za DE1-SoC ploču
```
make savedefconfig
mv defconfig arch/arm/configs/de1_soc_defconfig
```

Nakon što smo konfigurisali prethodno pomenute parametre kernela, možemo pokrenuti proces kroskompajliranja komandom `make`:
```
make -j 4
```

Ako smo izabrali da koristimo **Buildroot** alat za izgradnju Linux embedded sistema, dovoljno je samo da prekopiramo prethodno kreiranu konfiguraciju kernela za DE1-SoC plocu u direktorijum sa izvornim kodom `buildroot`-a
```
scp ~/linux-socfpga/arch/arm/configs/de1_soc_defconfig ~/buildroot/board/terasic/de1soc_cyclone5
```

Ukoliko biramo da rucno gradimo Linux embedded sistem, onda je potrebno da se do kraja isprati ovaj tekst.

## Kreiranje inicijalne strukture *root* fajl sistema

*Linux* kernel za podizanje sistema zahtjeva postojanje *root* fajl sistema koji
ima odgovarajuću strukturu foldera definisanu [Filesystem Hierarchy Standard (FHS)](https://refspecs.linuxfoundation.org/fhs.shtml)
specifikacijom. Većina foldera i fajlova kreira se prilikom instalacije *Busybox*
alata i prilikom montiranja virtuelnih fajl sistema. Međutim, prije svega, moramo
da napravimo incijalnu strukturu ovog fajl sistema. Prvo ćemo u `home` direktorijumu
korisnika kreirati krovni direktorijum pod nazivom `rootfs`.

```
cd ~
mkdir rootfs/bin/busybox
```

Ovaj direktorijum nazivamo još i *staging* direktorijum.

Zatim ćemo unutar ovog direktorijuma kreirati određeni broj standardnih foldera.

```
cd rootfs/
mkdir dev proc sys etc home lib tmp var
mkdir -p var/log usr/lib
```

Struktura `rootfs` direktorijuma treba da ima sljedeći izgled:

```
rootfs/
├── dev
├── etc
├── home
├── lib
├── proc
├── sys
├── tmp
├── usr
│   └── lib
└── var
    └── log
```

Sljedeći korak je instalacija alatki koje su neophodne za rad sa *Linux* sistemom.
U tu svrhu najbolje je koristiti *BusyBox* projekat.


## *Busybox*: konfiguracija i kompajliranje

Prvo ćemo preuzeti *BusyBox* izvorni kod i prebaciti se na stabilnu verziju `1_36_stable`:
```
git clone https://git.busybox.net/busybox
cd busybox/
git checkout 1_36_stable
```

Zatim ćemo postaviti podrazumijevanu konfiguraciju koja uključuje alate koje tipično koristi
većina korisnika.
```
make defconfig
```

Za dodatnu konfiguraciju pokrećemo meni za konfiguraciju *BusyBox* opcija.
```
make menuconfig
```

U okviru **Settings** pod kategorijom **Build Options** definisati opciju
**Cross compiler prefix** tako da odgovara prefiksu našeg kompajlera (npr. `arm-linux-`),
a pod kategorijom **Installation Options** definisati opciju **Destination path for 'make install'**
tako da pokazuje na lokaciju foldera u kojem se nalazi naš *root* fajl sistem (npr. `../rootfs`).
Omogućite opciju **Build static binary (no shared libs)**
koja se nalazi pod **Settings** u okviru **Build Options** kategorije.
 
Prije kompajliranja, potrebno je da eksportujemo putanju do *toolchain*-a korišćenjem skripte 
[set-environment.sh](../scripts/set-environment.sh)


Sada je dovoljno pokrenuti komandu `make` za kroskompajliranje *BusyBox* projekta. Po završetku
kompajliranja, komandom `make install` instaliramo konfigurisane alate na lokaciju specificiranu
u opciji **Destination path for 'make install'**. Dovoljno je da definišemo lokaciju odredišnog
foldera, a *BusyBox* će kreirati sve neophodne foldere ukoliko već nisu kreirani.

Sada kada smo instalirali sve neophodne alate za pokretanje i rad sa *Linux* sistemom, potrebno je
da ih dostavimo ciljnoj platformi. Jedan način je da kompletan *root* fajl sistem kopiramo na EXT4
particiju na SD kartici, ali daleko felksibilniji i brži način je korišćenjem NFS protokola.

## Instalacija i konfiguracija NFS servera

Prvo je potrebno instalirati NFS server. Na razvojnom racunaru koristimo sljedeću komandu:
```
sudo apt install nfs-kernel-server
```

Nakon instalacije, server će se automatski pokrenuti, ali njegov status možete provjeriti komandom
```
sudo service nfs-kernel-server status
```

Ekvivalentno, stanje servera možete kontrolisati komandama `start`, `stop` i `restart`.

Da bi naš *staging* direktorijum bio vidljiv na ciljnoj platformi, potrebno je da ga dodamo
u listu eksportovanih foldera NFS servera. U tom smislu, trebamo editovati fajl `/etc/exports`
tako što ćemo dodati liniju
```
/home/<user>/rootfs <client_ip_addr>(rw,no_root_squash,no_subtree_check)
```

pri čemu `<client_ip_addr>` treba zamijeniti sa stvarnom IP adresom targeta (ciljna platforma),
npr. 192.168.1.200, a `<user>` sa stvarnim korisničkim imenom.

> [!IMPORTANT]
> Svi parametri moraju da se nalaze u jednoj liniji, a između IP adrese i NFS parametara navedenih
u zagradi ne smije da se nalazi prazan prostor (čak ni razmak).


Konačno, da bi se promjene u `/etc/exports` fajlu propagirale do server, potrebno ga je restartovati
ili pokrenuti sljedeću komandu:
```
sudo exportfs -r
```


## Podizanje *Linux* kernela korišćenjem NFS *root* fajl sistema

Ostaje još da promijenimo *U-Boot* varijablu `bootargs` preko koje prosljeđujemo argumente komandne linije kernelu.
Povežite serijski terminal na ploči sa PC računarom, napajanje ploče i Ethernet kabl, a zatim uključite ploču.
Prekinite proces podizanja sistema kako biste dobili pristup *U-Boot* konzoli, a zatim dodajte sljedeće argumente
(npr. korišćenjem komande `editenv bootargs`)

```
root=/dev/nfs nfsroot=<server_ip>:/home/<user>/rootfs,nfsvers=3,tcp rw
```

gdje su: `<user>` korisničko ime, `<server_ip>` IP adresa NFS servera i `<client_ip>` IP adresa ploče.

Nakon editovanja, komandna linija bi trebalo da ima izgled ekvivalentan sljedećem primjeru:

```
=> printenv bootargs
bootargs=console=ttyS0,115200n8 ip=192.168.21.200 root=/dev/nfs nfsroot=192.168.21.101:/home/mknezic/rootfs,nfsvers=3,tcp rw
```

Sačuvajte izmjene komandom `saveenv`

```
=> saveenv
Saving Environment to MMC... Writing to MMC(0)... OK
```

a zatim ponovo pokrenite sistem.
