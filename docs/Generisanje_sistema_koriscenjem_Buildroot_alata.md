# 🧱 Šta je Buildroot?

**Buildroot** je alat (framework) koji se koristi za automatsko generisanje **celog Linux sistema** (toolchain + bootloader + kernel + root filesystem) za neku embedded platformu.

Buildroot može da generiše:
- **toolchain**  (C/C++ kompajler, C/C++ libs, Kernel headers, binutils, ...)
- **Bootloader** (Obično U-Boot)
- **Linux kernel**
- **rootfs** (BusyBox + biblioteke + korisnicke aplikacije)
- **SD image** (Gotov .img fajl koji možeš flashovati na SD karticu)


💾 Na SD kartici će se nalaziti:
- **Bootloader** (npr. U-Boot)
- **Linux kernel** (npr. zImage ili uImage)
- **Device Tree Blob** (.dtb)
- **Root filesystem** (rootfs.ext2, rootfs.cpio.gz, ili sl. – često mountovan kao drugi partition ili initramfs)


❌ Toolchain se NE nalazi na SD kartici jer je samo alat za razvoj
- Instalira se na razvojnoj mašini (npr. Ubuntu)
- Koristi se da cross-kompajliraš aplikacije za target (ARM, MIPS…)
- Nema potrebu da se nalazi na samom target uređaju


## Generisanje sistema korišćenjem Buildroot alata

Kloniramo repozitorijum **buildroot**-a i prebacujemo se na najnoviju granu. U trenutku pisanja ovog vodica, to je grana 2025.05
```
git clone https://gitlab.com/buildroot.org/buildroot.git
cd buildroot
git checkout 2025.05
```

Potvrdite da na razvojnom računaru imate instalirane sve [obavezne softverske pakete](https://buildroot.org/downloads/manual/manual.html#requirement-mandatory).

Za DE1-SoC ploču ne postoji predefinisana konfiguracija, pa ćemo kreirati resurse neophodne
za ovu ploču. Prvo je potrebno kreirati direktorijum u kojem će se nalaziti potrebni resursi
```
mkdir -p board/terasic/de1soc_cyclone5
```

Unutar `~/buildroot/board/terasic/de1soc_cyclone5` direktorijuma treba da se nadju sledeci fajlovi:
- **Device Tree Source** ([socfpga_cyclone5_de1_soc.dts](../buildroot/board/terasic/de1soc_cyclone5/socfpga_cyclone5_de1_soc.dts))
- **Default kernel configuration file** ([de1_soc_defconfig](../buildroot/board/terasic/de1soc_cyclone5/de1_soc_defconfig))
- fajl kojim opisujemo **strukturu SD kartice** koja je pogodna za našu platformu ([genimage.cfg](../buildroot/board/terasic/de1soc_cyclone5/genimage.cfg))
- fajl kojim opisujemo U-Boot okruženje (umjesto podrazumijevanog sadržaja koji je ugrađen u sam izvorni kod bootloader-a) ([boot-env.txt](../buildroot/board/terasic/de1soc_cyclone5/boot-env.txt))


Kako predefinisana konfiguracija ne postoji za DE1-SoC ploču, koristicemo predefinisanu konfiguraciju
za DE10-nano plocu jer su vrlo slicne. 
- Ucitavamo predefinisanu konfiguraciju za DE10-nano plocu u `.config` kao nasu polaznu radnu konfiguraciju </br>
  `make terasic_de10nano_cyclone5_defconfig`
- pokrecemo alat za prilagodjavanje pojedinih opcija polazne konfiguracije kako bi u potpunosti odgovarala nasoj ciljnoj DE1-SoC platformi</br>
`make menuconfig`</br>
![image](https://github.com/user-attachments/assets/6abec423-27d6-4b12-80ed-5105ee7fc3ac)
- U okviru **Toochain**:
    - postavite **Toolchain type** opciju na **External toolchain**
    - postavite **Toolchain** opciju na **Custom toolchain**
    - postavite **Toolchain origin** opciju na **Pre-installed toolchain**
    - postavite **Toolchain path** tako da odgovara putanji korišćenog *toolchain*-a (relativno u odnosu na `buildroot` folder)
    - ostavite opciju **Toolchain prefix** kako jeste (**$(ARCH)-linux**)
    - ostavite opciju **External toolchain gcc version** na (**13x**)
    - postavite **External toolchain kernel headers series** opciju na **6.1.x**
    - postavite **External toolchain C library** opciju na **glibc**
    - uključite opciju **Toolchain has SSP support?**
    - uključite opciju **Toolchain has C++ support?**
    - isključite opciju **Toolchain has RPC support?**
      
- U okviru **Build options**:
    - postavite **Location to save buildroot config** opciju na **<path-to-buildroot>/configs/terasic_de1soc_cyclone5_defconfig**
      
- U okviru **System configuration**:
    - postavite **System hostname** opciju na **etfbl**
    - postavite **System banner** opciju na **Welcome to DE1-SoC on ETFBL**
    - odaberite **systemd** u okviru opcije **Init system**
    - postavite **Root filesystem overlay directories** na **board/terasic/de1soc_cyclone5/rootfs-overlay**
    - izmijenite **Extra arguments** opciju tako da bude **-c board/terasic/de1soc_cyclone5/genimage.cfg**

- U okviru **Kernel**:
    - postavite **Custom repository version** opciju na **socfpga-6.1.38-lts**
    - postavite **Kernel configuration** opciju na **Using a custom (def)config file**
    - postavite **Configuration file path** opciju na **board/terasic/de1soc_cyclone5/de1_soc_defconfig**
    - obrišite sadržaj opcije **In-Tree Device Tree Source file names**
    - postavite **Out-of-tree Device Tree Source file names** opciju na **board/terasic/de1soc_cyclone5/socfpga_cyclone5_de1_soc.dts**
    - uključite opciju **Linux Kernel Tools**&rarr;**iio**

- U okviru **Target packages**:
    - uključite opciju **Hardware handling**&rarr;**evtest**
    - uključite opciju **Hardware handling**&rarr;**i2c-tools**
    - uključite opciju **Hardware handling**&rarr;**spi-tools**
    - uključite opciju **Libraries**&rarr;**Hardware handling**&rarr;**libgpiod**
    - uključite opciju **Libraries**&rarr;**Hardware handling**&rarr;**install tools**

- U okviru **Bootloaders**:
    - isključite opciju **Barebox**
    - uključite opciju **U-Boot**
    - postavite vrijednost opcije **U-Boot version** (**2025.04**)
    - postavite **Custom U-Boot patches** na **board/terasic/de1soc_cyclone5/patches/de1-soc-handoff.patch**
    - postavite **U-Boot configuration** opciju na **Using an in-tree board defconfig file**
    - postavite **Board defconfig** opciju na **socfpga_de1_soc**
    - uključite opciju **U-Boot needs dtc**
    - u okviru **U-Boot binary format** isključite opciju **u-boot.bin** i uključite opciju **u-boot.img**
    - uključite opciju **Install U-Boot SPL binary image**
    - uključite opciju **CRC image for Altera SoC FPGA (mkpimage)**

- U okviru **Host utilities**:
    - uključite opciju **host u-boot tools**
    - uključite opciju **Environment image**
    - postavite **Source files for environment** opciju na **board/terasic/de1soc_cyclone5/boot-env.txt** 
    - postavite **Size of environment** opciju na 8192


Nakon sto smo izvrsili prilagodjenje polazne radne konfiguracije koja je bila u potpunosti prilagodjena **DE10-nano** platformi,
mozemo u **menuconfig**-u ici na **Save**. 

Sada u **.config** fajlu imamo novu konfiguraciju koja je prilagodjena za **DE1-SoC** platformu, a kreirana je na bazi konfiguracije za
**DE10-nano** platformu.

Sada cemo da sacuvamo našu prilagođenu konfiguraciju za **DE1-SoC** kao predefinisanu pod nazivom `terasic_de1soc_cyclone5_defconfig`.Bice smjestena u `buildroot/configs`.</br>
```
make savedefconfig
```
Nakon što smo sačuvali predefinisanu konfiguraciju, po potrebi mozemo da je aktiviramo komandom:
```
make terasic_de1soc_cyclone5_defconfig
```
<img width="664" height="81" alt="image" src="https://github.com/user-attachments/assets/9cc985d8-d8fe-4512-b966-337e9b0ca581" />








