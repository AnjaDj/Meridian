# Konfiguracija i kompajliranje U-Boot-a

Ukoliko koristite **Quartus Prime Pro 19.2**, **Quartus Prime Standard 18.1** ili starije verzije, za razvoj 
**preloader**-a bice vam potreban [**Intel® SoC FPGA Embedded Development Suite**](https://www.intel.com/content/www/us/en/collections/products/fpga/software/downloads.html?edition=standard&platform=linux&download_manager=direct&f:os-rdc=%5BLinux*%5D).</br>

Pocevsi od `SoC EDS Pro 19.3` i ` SoC EDS Standard 19.1` **bootloader source code** je izbacen iz **SoC EDS** paketa 
tako da se za izgradnju **bootloader**-a treba koristiti **source code** sa zvanicnog Altera repozitorijuma [u-boot-socfpga](https://github.com/altera-opensource/u-boot-socfpga).
**SoC EDS** zvanično postoji samo do verzije 20.1. i izbacuje se iz upotrebe za novije verzije **Quartus**-a.</br>

Trenutno dostupne edicije [**Intel® SoC FPGA Embedded Development Suite**](https://www.intel.com/content/www/us/en/collections/products/fpga/software/downloads.html?edition=standard&platform=linux&download_manager=direct&f:os-rdc=%5BLinux*%5D) su
- *Intel SoC FPGA EDS **Standard** Edition Software (17.0 to 20.1)*
- *Intel SoC FPGA EDS **Pro** Edition Software (17.0 to 20.1)*</br>

<img width="1443" height="142" alt="image" src="https://github.com/user-attachments/assets/ab8b8ba4-e217-4ad0-acc7-7e805ff6fe48" /></br></br></br>

Kako smo za **Quartus** verziju izabrali **Quartus Prime Lite edition 24.01std**, **SoC EDS** nije podrzan za nasu verziju, ali nije ni neophodan jer su sve funkcionalnosti koje nama trebaju prebacene na zvanični [`u-boot-socfpga`](https://github.com/altera-opensource/u-boot-socfpga) repozitorijum.


