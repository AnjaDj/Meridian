# Instalacija softversih paketa

Na razvojnoj masini se koristi Linux **22.04.1-Ubuntu**. </br></br>
Za potrebe realizacije ovog projekta, bice nam potrebni [**Intel** softverski paketi](https://www.intel.com/content/www/us/en/collections/products/fpga/software/downloads.html?edition=standard&platform=linux&download_manager=direct) i to **Intel Quartus Prime Lite 24.1std**</br>
<img width="1321" height="109" alt="image" align="left" src="https://github.com/user-attachments/assets/d1a7b638-65c2-472e-89ce-37c3de4c67bc" /></br></br></br></br>
<p align="center"><i><b>Slika 1 </b>: FPGA Software Download Center</i></p>


## Instalacija Intel Quartus Prime na Linux-u

Sa stranice [Download Quartus Prime Lite 24.1](https://www.intel.com/content/www/us/en/software-kit/849769/intel-quartus-prime-lite-edition-design-software-version-24-1-for-linux.html) preuzmite 
**Intel Quartus Prime Installer** kao na slici ispod


<img width="1321" height="400" alt="image" align="left" src="https://github.com/user-attachments/assets/bda07bd0-e457-4201-aca2-a291f885927e" /></br></br></br></br>
<p align="center"><i><b>Slika 2 </b>: Zvanicni Intel sajt za preuzimanje Quartus Prime softverskog paketa</i></p>


Ako za downloads birate opciju **Individual Files**, potrebno je preuzeti
- *Intel® Quartus® Prime (includes Nios II EDS)*
- *Intel® Cyclone® V device support (DE1-SoC ploca koristi CycloneV)*</br>
   

Nakon sto smo preuzeli `qinst-lite-linux-24.1std-1077.run` potrebno je da promijenimo permisije za `.run` fajl te da ga pokrenemo 
```bash
cd ~/Downloads
sudo chmod +x qinst-lite-linux-24.1std-1077.run
./qinst-lite-linux-24.1std-1077.run
```
Pojavice se interaktivni prozor u kome treba da
- selektujemo sve alate za instalaciju
- navedemo direktorijum za instalaciju selektovanih alata
<img width="1321" height="600" alt="image" src="https://github.com/user-attachments/assets/8de7c022-bd21-4613-af8e-c2089cd7b22a" /></br>
<p align="center"><i><b>Slika 3 </b>: Intel Quartus Prime Installer prozor</i></p>

Nakon zavrsetka procesa instalacije, *Quartus* softverski paket je spreman za koristenje a sam **Quartus Prime** pokrecemo iz terminala komandom 
```bash
cd ~
./intelFPGA_lite/24.1std/quartus/bin/quartus
```
