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
  - Sada su **handoff** fajlovi generisani
