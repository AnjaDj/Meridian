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


❌ Toolchain se NE nalazi na SD kartici jer je samo za razvoj
- Instalira se na razvojnoj mašini (npr. Ubuntu)
- Koristi se da cross-kompajliraš aplikacije za target (ARM, MIPS…)
- Nema potrebu da se nalazi na samom target uređaju


## Generisanje sistema korišćenjem Buildroot alata

Prvo je potrebno da preuzmemo repozitorijum ovog *build* sistema i da se prebacimo
na odgovarajuću granu:
```
git clone https://gitlab.com/buildroot.org/buildroot.git
cd buildroot
git checkout 2024.02
```

Potvrdite da na razvojnom računaru imate instalirane sve [obavezne softverske pakete](https://buildroot.org/downloads/manual/manual.html#requirement-mandatory).

Za DE1-SoC ploču ne postoji predefinisana konfiguracija, pa ćemo kreirati resurse neophodne
za ovu ploču. Prvo je potrebno kreirati direktorijum u kojem će se nalaziti potrebni resursi
```
user:~/buildroot$  mkdir -p board/terasic/de1soc_cyclone5
```



















