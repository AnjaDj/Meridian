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

> [!TIP]
> *BusyBox* kompajlira sve alate u jedan binarni fajl koji se kopira na lokaciju `rootfs/bin/busybox`.
Svi ostali fajlovi su zapravo simbolički linkovi koji pokazuju na ovaj binarni fajl, što možete
provjeriti npr. komandom `ls -l rootfs/bin/`.

Sada kada smo instalirali sve neophodne alate za pokretanje i rad sa *Linux* sistemom, potrebno je
da ih dostavimo ciljnoj platformi. Jedan način je da kompletan *root* fajl sistem kopiramo na EXT4
particiju na SD kartici, ali daleko felksibilniji i brži način je korišćenjem NFS protokola.

## Instalacija i konfiguracija NFS servera

Prvo je potrebno instalirati NFS server. Na *Ubuntu 22.04* distribuciji koristimo sljedeću komandu:

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

pri čemu `<client_ip_addr>` treba zamijeniti sa stvarnom IP adresom klijenta (ciljna platforma),
npr. 192.168.21.200, a `<user>` sa stvarnim korisničkim imenom.

> [!IMPORTANT]
> Svi parametri moraju da se nalaze u jednoj liniji, a između IP adrese i NFS parametara navedenih
u zagradi ne smije da se nalazi prazan prostor (čak ni razmak).

> [!TIP]
> Umjesto IP adrese može da se stavi `*`, čime se dozvoljava pristup NFS serveru svim klijentima koji
se nalaze u istoj mreži. Ovo je korisna opcija ukoliko više klijenata koristi isti *root* fajl sistem.
U našem slučaju je bolje specificirati IP adresu klijenta.

Konačno, da bi se promjene u `/etc/exports` fajlu propagirale do server, potrebno ga je restartovati
ili pokrenuti sljedeću komandu:

```
sudo exportfs -r
```
