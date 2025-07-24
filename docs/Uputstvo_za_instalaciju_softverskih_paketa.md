# Instalacija softversih paketa

Na razvojnoj masini se koristi Linux **22.04.1-Ubuntu**. </br>
Za potrebe realizacije ovog projekta, bice nam potrebni [**Intel** softverski alati](https://www.intel.com/content/www/us/en/collections/products/fpga/software/downloads.html?edition=standard&platform=linux&download_manager=direct) i to **Intel Quartus Prime Lite 24.1_std**</br>
<img width="1321" height="109" alt="image" align="left" src="https://github.com/user-attachments/assets/d1a7b638-65c2-472e-89ce-37c3de4c67bc" /></br></br></br></br>


## Instalacija Intel Quartus Prime na Linux-u

[Download Quartus Prime Lite 24.1](https://www.intel.com/content/www/us/en/software-kit/849769/intel-quartus-prime-lite-edition-design-software-version-24-1-for-linux.html)
<img width="1321" height="400" alt="image" align="left" src="https://github.com/user-attachments/assets/bda07bd0-e457-4201-aca2-a291f885927e" /></br>


Ako za downloads birate opciju **Individual Files**, potrebno je skinuti
- *Intel® Quartus® Prime (includes Nios II EDS)*
- *Intel® Cyclone® V device support*</br>
   

Nakon sto smo skinuli `qinst-lite-linux-24.1std-1077.run` potrebno je da promijenimo permisije za `.run` fajl te da ga pokrenemo 
```bash
cd ~/Downloads
sudo chmod +x qinst-lite-linux-24.1std-1077.run
./qinst-lite-linux-24.1std-1077.run
```
