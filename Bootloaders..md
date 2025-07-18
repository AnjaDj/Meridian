<img width="2514" height="995" alt="image" src="https://github.com/user-attachments/assets/724cfeed-50df-4b25-bb45-87047dc75462" />

# SPL/Preloader (Primary bootloader)

**SPL**
- se ucitava u **internu SRAM** koja je inicijalno operabilna
- konfigurise najosnovniji dio HPS-a DE1-SoC platforme
- inicijalizuje **DDR kontroler** kako bi se omogucila komunikacija sa **eksternom DDR** memorijom
- nakon sto se SPL ucita u internu SRAM, izvrsice se osnovna konfiguracija HPS-s a zatim ce
**secondary stage bootloader (U-Boot)** biti ucitan u eksternu DRR

  Za bildanje SPL-a koristicemo alat **BSP-Editor** koji dolazi uz **Intel Embedded Development Suite (EDS)**.

   
