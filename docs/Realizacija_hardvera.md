# Realizacija hardvera

## Preduslov
- Instaliran [*Quartus Prime*](https://www.intel.com/content/www/us/en/software-kit/669553/intel-quartus-prime-lite-edition-design-software-version-17-0-for-linux.html) sa *Intel® Cyclone® V Device Support* i *Nios® II EDS*
- Instaliran [*SoC EDS*](https://www.intel.com/content/www/us/en/software-kit/669533/intel-soc-fpga-embedded-development-suite-soc-eds-standard-edition-software-version-17-0-for-linux.html)

## Kreiranje hardverskog sistema pomocu Quartus Prime alata

### Kreiranje Quartus projekta
Prvo je potrebno da kreiramo projekat **File->New Proect Wizard** </br>
![image](https://github.com/user-attachments/assets/32862dc9-652e-4638-97cb-cf21b400e574) </br>

Zatim biramo opciju **Empty Project**, te podesavamo parametre vezane za koristenu **DE1-SoC** plocu kao na slici ispod:
![image](https://github.com/user-attachments/assets/c008605a-fd0a-4a5c-a515-7b70b8dc6c0e)

Konacno dobijamo **meridian.qpf** sa [**meridian_top.vhd**](vhd/meridian_top.vhd) kao krovnim VHDL dizajnom.

### Kreiranje Qsys projekta

U okviru prethodno kreiranom Quartus projekta, biramo opciju **Tools->Qsys*** te mozemo odmah da sacuvamo **.qsys** fajl kao **soc_system.qsys** u okviu koga cemo dodavati komponente koje ce graditi nas hardverski sistem.
