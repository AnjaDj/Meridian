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

Prvo cemo klonirati repozitorijum ovog *build* sistema i prebaciti
na trenutno najnoviju granu:
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














