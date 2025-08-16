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
