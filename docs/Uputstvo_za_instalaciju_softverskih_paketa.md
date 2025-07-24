# Instalacija Intel Quartus Prime na Linux-u

1. [Download Quartus Prime Lite 22.1_std](https://www.intel.com/content/www/us/en/software-kit/757261/intel-quartus-prime-lite-edition-design-software-version-22-1-for-linux.html)

   <img width="755" height="283" alt="image" src="https://github.com/user-attachments/assets/e29c339d-855c-4c0b-bd99-3e229504fb43" /></br>

   Ako za downloads birate opciju **Individual Files**, potrebno je skinuti
   - *Intel® Quartus® Prime (includes Nios II EDS)*
   - *Intel® Cyclone® V device support*</br>
   
   <img width="755" height="283" alt="image" src="https://github.com/user-attachments/assets/da9e66a6-9fbd-404e-8ea3-1e81d6f75b36" /></br>

2. **Nios® II EDS** zahtijeva manuelnu instalaciju  [**Eclipse IDE**](https://www.eclipse.org/downloads/packages/)
   
   <img width="755" height="283" alt="image" src="https://github.com/user-attachments/assets/9e0ac074-251c-4111-9f6a-79b590451846" />
   
   Posto smo skinuli **Eclipse IDE** u formatu `.tar.gz` porebno je raspakovati arhivu i spremiti **eclipse** za rad na nasem Linuxu
   ```bash
   cd ~/Downloads
   tar -xvzf eclipse-cpp-2025-06-R-linux-gtk-x86_64.tar.gz
   ```
   Prethodna komanda ce napraviti folder `eclipse` koji cemo premjestiti na sistemsko mjesto
   ```bash
   sudo mv eclipse /opt/eclipse
   ``` 

3. Nakon sto smo skinuli `Quartus-lite-22.1std.0.915-linux.tar` arhivu potrebno ju je raspakovati i instalirati zeljene alate
   ```bash
   cd ~/Downloads
   tar -xvf Quartus-lite-22.1std.0.915-linux.tar
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





--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


# Instalacija Intel EDS v17.0 na Linuxu

- [Download Intel EDS](https://www.intel.com/content/www/us/en/collections/products/fpga/software/downloads.html?edition=standard&platform=linux&download_manager=direct)
  <img width="1478" height="85" alt="image" src="https://github.com/user-attachments/assets/d7c25604-de62-4c08-901f-f5e7d3ad3457" />
- Pokrenite sledece Linux shell komande
  ```
  chmod +x SoCEDSSetup-17.X.X.XXX-linux.run
  sudo ./SoCEDSSetup-17.X.X.XXX-linux.run
  ```
- Na kraju instalacije pojavice se prozor *Launch DS-5 installation* koji nije obavezan da se check-ira
  <img width="674" height="177" alt="image" src="https://github.com/user-attachments/assets/b7439fa8-c277-4ee6-ab4a-52a9f42cb941" />


