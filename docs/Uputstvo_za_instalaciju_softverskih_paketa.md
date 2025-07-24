# Instalacija softversih paketa

Na razvojnoj masini se koristi Linux **22.04.1-Ubuntu**. </br>
Za potrebe realizacije ovog projekta, bice nam potrebni [**Intel** softverski alati](https://www.intel.com/content/www/us/en/collections/products/fpga/software/downloads.html?edition=standard&platform=linux&download_manager=direct) i to u verziji 17.0
- **Intel Quartus Prime Lite**
- **Intel SoC FPGA EDS**



# Instalacija Intel Quartus Prime na Linux-u

1. [Download Quartus Prime Lite 17.0_](https://www.intel.com/content/www/us/en/software-kit/669553/intel-quartus-prime-lite-edition-design-software-version-17-0-for-linux.html)
   <img width="755" height="283" alt="image" src="https://github.com/user-attachments/assets/e555a0a4-a333-46fe-80f4-3566670643a2" /></br>


   Ako za downloads birate opciju **Individual Files**, potrebno je skinuti
   - *Intel® Quartus® Prime (includes Nios II EDS)*
   - *Intel® Cyclone® V device support*</br>
   
   <img width="755" height="283" alt="image" src="https://github.com/user-attachments/assets/da9e66a6-9fbd-404e-8ea3-1e81d6f75b36" /></br>

Nakon sto smo skinuli `Quartus-lite-17.0.0.595-linux.tar` arhivu potrebno ju je raspakovati i instalirati zeljene alate
   ```bash
   cd ~/Downloads
   tar -xvf Quartus-lite-17.0.0.595-linux.tar
   ./setup.sh
   ```
   Nakon sto je skripta pokrenuta dobicete interaktivni prozor gdje trebate odabrati lokaciju za instaltaciju **Quartus**-a
   te selektvati dodatne opcije za instalaciju</br>
   <img width="673" height="184" alt="Screenshot from 2025-07-24 14-19-20" src="https://github.com/user-attachments/assets/1f99baa4-fe6c-46d2-be16-cec23586418c" /></br>
   <img width="673" height="347" alt="Screenshot from 2025-07-24 14-20-09" src="https://github.com/user-attachments/assets/2a3fbe8b-9e93-48ee-9f3f-072f2b5542c3" />

Sada je **Quartus** instaliran i spreman za korsitenje, a pokrece se iz terminala kao
```bash
cd ~
./intelFPGA_lite/22.1std/quartus/bin/quartus
```

# Instalacija Intel SoC FPGA EDS v17.0 na Linux-u

- [Download Intel EDS 17.0](https://www.intel.com/content/www/us/en/collections/products/fpga/software/downloads.html?edition=standard&platform=linux&download_manager=direct)
  <img width="1408" height="84" alt="image" src="https://github.com/user-attachments/assets/1f927338-9a27-4fec-915a-d1a6046c72bf" />
  <img width="1170" height="410" alt="image" src="https://github.com/user-attachments/assets/0b133284-9260-42b6-8b10-77f31f1d7394" />

- Pokrenite sledece Linux shell komande
  ```bash
  cd ~/Downloads
  sudo chmod +x SoCEDSSetup-17.0.0.595-linux.run
  ./SoCEDSSetup-17.0.0.595-linux.run
  ```
  <img width="681" height="215" alt="image" src="https://github.com/user-attachments/assets/a12c4eb5-3bb9-4476-8f5f-a8937b54ceae" />

