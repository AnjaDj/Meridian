<img width="2514" height="995" alt="image" src="https://github.com/user-attachments/assets/724cfeed-50df-4b25-bb45-87047dc75462" />

# SPL/Preloader (Primary bootloader)

**SPL**
- se ucitava u **internu SRAM** koja je inicijalno operabilna
- konfigurise najosnovniji dio HPS-a DE1-SoC platforme
- inicijalizuje **DDR kontroler** kako bi se omogucila komunikacija sa **eksternom DDR** memorijom
- nakon sto se SPL ucita u internu SRAM, izvrsice se osnovna konfiguracija HPS-s a zatim ce
**secondary stage bootloader (U-Boot)** biti ucitan u eksternu DRR

  Za bildanje SPL-a koristicemo alat **BSP-Editor** koji dolazi uz **Intel Embedded Development Suite (EDS)**
  - pokrenite **embedded command shell**
    ```bash
    cd intelFPGA_lite/17.0/embedded
    ./embedded_command_shell.sh
    ```
  - Pozicionirajte se na direktorijum projekta
    ```bash
    $ cd path-to-project-dir
    ```
  - Generisanje **BSP handoff** fajlova 
    ```bash
    $ bsp-create-settings --type spl --bsp-dir build --preloader-settings-dir hps_isw_handoff/soc_system_hps_0/ --settings build/settings.bsp
    ```
    <img width="1342" height="406" alt="image(2)" src="https://github.com/user-attachments/assets/5877df41-2644-4815-82cc-3f8ab52852bb" />
  - U **embedded commans shell**-u pokrecemo **BSP-Editor**
    ```bash
    $ bsp-editor
    ```
  - Otvara se prozor u kom trebamo odabrati **File->Open->settings.bsp**
    <img width="1005" height="514" alt="image(3)" src="https://github.com/user-attachments/assets/29caaac5-7146-452d-be9f-653e090fa3e8" />
  - Potrebno je selektovati **BOOT_FROM_SDMMC, FAT_SUPPORT** ukoliko to vec nije uradjeno, te ici na Generate
    <img width="1263" height="673" alt="image(6)" src="https://github.com/user-attachments/assets/b82278ac-388b-4f4d-93cf-d5d5c265b9fa" />
  - Sada kada su **handoff** fajlovi generisani, koristimo **U-Boot** da bismo ih procesirali. Koristicemo `qts-filter.sh` skriptu iz `u-boot` repozitorijuma
    Prvo je potrebno da preuzmemo *U-Boot* izvorni kod i da se prebacimo na verziju `v2025.04`:
    ```
    git clone https://gitlab.denx.de/u-boot/u-boot
    cd u-boot
    git checkout v2025.04
    ```
  - Da bismo mogli ispravno da konfigurišemo i kroskompajliramo *U-Boot*, potrebno je da eksportujemo
    putanju do kroskompajlera i da postavimo varijablu `CROSS_COMPILE` da odgovara prefiksu našeg
    kroskompajlera. U tom smislu, najlakše je koristiti prethodno pomenutu skriptu `set-environment.sh`
    koja se nalazi u `scripts` folderu u repozitorijumu kursa
    ```
    source ./set-environment.sh`
    ```
  - Za *DE1_SoC* ploču već postoji predefinisana konfiguracija pod nazivom `socfpga_de1_soc_defconfig`,
    pa ćemo nju postaviti kao polaznu *U-Boot* konfiguraciju.
    ```
    make socfpga_de1_soc_defconfig`
    ```
  - Sada možemo pokrenuti komandu `make menuconfig` kako bismo definisali neke dodatne opcije u
    konfiguraciji. S obzirom da *DE1-SoC* ploča ne sadrži **EEPROM** zapohranjivanje fizičke **MAC adrese**,
    potrebno je da u konfiguraciji omogućimo opciju **Random ethaddr if unset** koja se nalazi u okviru **Networking support** kategorije
    
