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

# Instalacija Intel Quartus Prime Lite v17.0 na Linuxu
- [Download Quartus](https://www.intel.com/content/www/us/en/software-kit/669553/intel-quartus-prime-lite-edition-design-software-version-17-0-for-linux.html)
  <img width="1613" height="159" alt="image" src="https://github.com/user-attachments/assets/58cbda14-ec26-48c7-b39b-f0cdbe88412c" />
- Ako skidate *Individual files*, potrebno je izabrati
  - Intel® Cyclone® V Device Support
  - Intel® Quartus® Prime (includes Nios® II EDS)
- Pokrenite sledecu Linux shell komandu
  ```
  chmod +x *.run
  QuartusLiteSetup-17.X.X.XXX-linux./run
  ```
