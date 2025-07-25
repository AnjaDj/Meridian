# Konfiguracija i kompajliranje U-Boot-a

Ukoliko koristite **Quartus Prime Pro 19.2**, **Quartus Prime Standard 18.1** ili starije verzije, za razvoj 
**preloader**-a bice vam potreban [**Intel® SoC FPGA Embedded Development Suite**](https://www.intel.com/content/www/us/en/collections/products/fpga/software/downloads.html?edition=standard&platform=linux&download_manager=direct&f:os-rdc=%5BLinux*%5D).</br>

Pocevsi od `SoC EDS Pro 19.3` i ` SoC EDS Standard 19.1` **bootloader source code** je izbacen iz **SoC EDS** paketa 
tako da se za izgradnju **bootloader**-a treba koristiti **source code** sa zvanicnog Altera repozitorijuma [u-boot-socfpga](https://github.com/altera-opensource/u-boot-socfpga).
**SoC EDS** zvanično postoji samo do verzije 20.1. i izbacuje se iz upotrebe za novije verzije **Quartus**-a.</br>

Trenutno dostupne edicije [**Intel® SoC FPGA Embedded Development Suite**](https://www.intel.com/content/www/us/en/collections/products/fpga/software/downloads.html?edition=standard&platform=linux&download_manager=direct&f:os-rdc=%5BLinux*%5D) su
- *Intel SoC FPGA EDS **Standard** Edition Software (17.0 to 20.1)*
- *Intel SoC FPGA EDS **Pro** Edition Software (17.0 to 20.1)*</br>

<img width="1443" height="142" alt="image" src="https://github.com/user-attachments/assets/ab8b8ba4-e217-4ad0-acc7-7e805ff6fe48" /></br></br>

Kako smo za **Quartus** verziju izabrali **Quartus Prime Lite edition 24.01std**, **SoC EDS** nije podrzan za nasu verziju, ali nije ni neophodan jer su sve funkcionalnosti koje nama trebaju prebacene na zvanični [`u-boot-socfpga`](https://github.com/altera-opensource/u-boot-socfpga) repozitorijum.


Zvanicni *Intel SOCFPGA U-Boot* repozitorijum je lociran na [https://github.com/altera-opensource/u-boot-socfpga](https://github.com/altera-opensource/u-boot-socfpga) i trebamo ga klonirati
```bash
git clone https://github.com/altera-opensource/u-boot-socfpga
cd u-boot-socfpga
```
Kada je rijec o izboru grane na koju cemo se `checkout`-ovati treba voditi racuna o tome da su grane oznacene kao `RC` namijenjene je za internu aktivnu razvojnu upotrebu i rani pristup novim `feature`-ima, bez zvanicne korisničke podrske.
Grana na koju cemo mi raditi `checkout` je stabilna `2022.04`
```bash
git checkout socfpga_v2022.04
```
<p>
  <img width="848" height="447" alt="image" src="https://github.com/user-attachments/assets/1ee794ea-dc1b-435a-ae42-b7ed8878fccf" />
</p>

Nakon zavrsetka procesa kompilacije dizajna, *intel Quartus* je generisao **handoff** folder `hps_isw_handoff/soc_system_hps_0`
