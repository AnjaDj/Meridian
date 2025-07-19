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
  - Generisanje **BSP** fajlova 
    ```bash
    bsp-create-settings --type spl --bsp-dir build --preloader-settings-dir hps_isw_handoff/soc_system_hps_0/ --settings build/settings.bsp
    ```
    <img width="1342" height="406" alt="image(2)" src="https://github.com/user-attachments/assets/5877df41-2644-4815-82cc-3f8ab52852bb" />

   
