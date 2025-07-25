# Konfiguracija i kompajliranje U-Boot-a

Ukoliko koristite **Quartus Prime Pro 19.2**, **Quartus Prime Standard 18.1** ili starije verzije, za razvoj 
**preloader**-a bice vam potreban [**Intel® SoC FPGA Embedded Development Suite**](https://www.intel.com/content/www/us/en/collections/products/fpga/software/downloads.html?edition=standard&platform=linux&download_manager=direct&f:os-rdc=%5BLinux*%5D).</br>

Pocevsi od `SoC EDS Pro 19.3` i ` SoC EDS Standard 19.1` **bootloader source code** je izbacen iz **SoC EDS** paketa 
tako da se za izgradnju **bootloader**-a treba koristiti **source code** sa zvanicnog Altera repozitorijuma [u-boot-socfpga](https://github.com/altera-opensource/u-boot-socfpga).
**SoC EDS** zvanično postoji samo do verzije 20.1. i izbacuje se iz upotrebe za novije verzije **Quartus**-a.</br>

Trenutno dostupne edicije [**Intel® SoC FPGA Embedded Development Suite**](https://www.intel.com/content/www/us/en/collections/products/fpga/software/downloads.html?edition=standard&platform=linux&download_manager=direct&f:os-rdc=%5BLinux*%5D) su
- *Intel SoC FPGA EDS **Standard** Edition Software (17.0 to 20.1)*
- *Intel SoC FPGA EDS **Pro** Edition Software (17.0 to 20.1)*</br>

<img width="1443" height="142" alt="image" src="https://github.com/user-attachments/assets/ab8b8ba4-e217-4ad0-acc7-7e805ff6fe48" /></br>
<p align="center"><i><b>Slika 1 </b>: Intel® SoC EDS edicije </i></p>

Kako smo za **Quartus** verziju izabrali **Quartus Prime Lite edition 24.01std**, **SoC EDS** nije podrzan za nasu verziju, ali nije ni neophodan jer su sve funkcionalnosti koje nama trebaju prebacene na zvanični [`u-boot-socfpga`](https://github.com/altera-opensource/u-boot-socfpga) repozitorijum.


Zvanicni *Intel SOCFPGA U-Boot* repozitorijum je lociran na [https://github.com/altera-opensource/u-boot-socfpga](https://github.com/altera-opensource/u-boot-socfpga) i trebamo ga klonirati. Kada je rijec o izboru grane na koju cemo se `checkout`-ovati treba voditi racuna o tome da su grane oznacene kao `RC` namijenjene je za internu aktivnu razvojnu upotrebu i rani pristup novim `feature`-ima, bez zvanicne korisničke podrske.
Grana na koju cemo mi raditi `checkout` je stabilna `2022.01`
```bash
git clone https://github.com/altera-opensource/u-boot-socfpga
cd u-boot-socfpga
git checkout socfpga_v2025.01
```
<p>
  <img width="848" height="447" alt="image" src="https://github.com/user-attachments/assets/1ee794ea-dc1b-435a-ae42-b7ed8878fccf">
</p>
<p align="center"><i><b>Slika 2 </b>: CycloneV build flow </i></p>

Nakon zavrsetka procesa kompilacije dizajna, *Intel Quartus* je generisao **handoff** folder `hps_isw_handoff/soc_system_hps_0`
sa `.h .c .xml` fajlovima. Fajlovi unutar tog **handoff** foldera ce biti ulaz za `cv_bsp_generator.py` skriptu iz [`u-boot-socfpga`](https://github.com/altera-opensource/u-boot-socfpga) repozitorijuma , a izlaz ce biti 4 u-boot kompatibilna fajla koja ce se kopirati u `/boards/terasic/de1-soc/qts/` direktorijum.
```bash
cd ~/u-boot-socfpga/arch/arm/mach-socfpga/cv_bsp_generator
python3 ./cv_bsp_generator.py -i ~/Desktop/meridian/hw/quartus/hps_isw_handoff/soc_system_hps_0 \
                              -o ../../../../board/terasic/de1-soc/qts
```
<img width="1627" height="131" alt="image" src="https://github.com/user-attachments/assets/596a118d-957a-4533-a134-a045aa77bba6" />

Nakon izvsenja `u-boot-socfpga/arch/arm/mach-socfpga/cv_bsp_generator/cv_bsp_generator.py` skripte, u 
`u-boot-socfpga/board/terasic/de1-soc/qts` direktorijumu ce se naci sledeci fajlovi:
- iocsr_config.h
- pll_config.h
- pinmux_config.h
- sdram_config.h











