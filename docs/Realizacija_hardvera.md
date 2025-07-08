# Realizacija hardvera
![image](https://github.com/user-attachments/assets/96be3d69-59a2-4e7f-8a7d-c42f8ec897fa)

## Preduslov
- Instaliran [*Quartus Prime*](https://www.intel.com/content/www/us/en/software-kit/669553/intel-quartus-prime-lite-edition-design-software-version-17-0-for-linux.html) sa *Intel® Cyclone® V Device Support* i *Nios® II EDS*
- Instaliran [*SoC EDS*](https://www.intel.com/content/www/us/en/software-kit/669533/intel-soc-fpga-embedded-development-suite-soc-eds-standard-edition-software-version-17-0-for-linux.html)

## Kreiranje hardverskog sistema pomocu Quartus Prime alata

### Kreiranje Quartus projekta
Prvo je potrebno da kreiramo projekat **File->New Proect Wizard** </br>
![image](https://github.com/user-attachments/assets/32862dc9-652e-4638-97cb-cf21b400e574) </br>

Zatim biramo opciju **Empty Project**, te podesavamo parametre vezane za koristenu **DE1-SoC** plocu kao na slici ispod:
![image](https://github.com/user-attachments/assets/c008605a-fd0a-4a5c-a515-7b70b8dc6c0e)

Konacno dobijamo **meridian.qpf** sa [**meridian_top.vhd**](../vhd/meridian_top.vhd) kao krovnim VHDL dizajnom.

### Kreiranje Qsys projekta

U okviru prethodno kreiranom Quartus projekta, biramo opciju **Tools->Qsys** te mozemo odmah da sacuvamo **.qsys** fajl kao **soc_system.qsys** u okviru koga cemo dodavati komponente koje ce graditi nas hardverski sistem.

U okviru **IP Catalog** tab-a biramo da dodamo sledece kommponente:
- **Clock Source** (trebalo bi da je po default-u ukljucen u .qsys projekat)
- **Arria V/Cyclone V Hard Processor System**
- **System ID Peripheral**

Sada cemo podesiti neke od parametara **HPS**-a.

Ovdje smo omogucili sve **AXI Bridge**-eve i postavili ih kao **32bit**-ne, mada nije neophodno. Ali ako Linux aplikacija pokusa da pristupi disable-ovanom bridge-u desice se **Kernel panic**, tako da smo omogucili sva tri interfejsa.
![image](https://github.com/user-attachments/assets/08954620-0a9b-40fe-8e4a-112784d9e352)</br>

Dalje, prelazimo na **Peripheral Pins** tab, gdje biramo sledece:</br>
![image](https://github.com/user-attachments/assets/72a974f6-d8d9-4ad1-b1b2-d9b0c04a426b) </br>
Dodatno, selektujemo **QSPI_SS1** kao **GPIO_35** i **TRACE_D4/TRACE_D5** kao **GPIO_53/GPIO_54** u sklopu **Peripherals Mux Table**.

Nakon sto otvorimo **SDRAM** tab, idemo na **View->Presets**, odaberemo [de1-soc-hps-ddr](../presets/de1-soc-hps-ddr) te kliknemo **Apply**.


Konacan izgled sistema, nakon povezivanja bi trebao da izgleda kao na slici ispod</br>
![image](https://github.com/user-attachments/assets/917b4f16-de92-4d0e-813a-f75312560705) </br>

Ostaje nam jos samo da dodijelimo bazne adrese signalima pojedinih komponenata koje smo dodali u nas sistem, idemo na **System->Assign Base Addresses** i da generisemo 
nas hardverski sistem **Generate->Generate HDL**
![image](https://github.com/user-attachments/assets/e2ef0992-4ed6-4376-90ed-e4dadb21a72f)

Nakon zavrsetka procesa **Generisanja** dobili smo:
- **soc_system.sopcinfo**
  -   XML fajl sa kompletnim opisom sistema (komponente, konekcije, parametri)
  -   Koristi se za Device Tree (`sopc2dts`), generisanje drajvera, U-Boot konfiguraciju itd.
- **soc_system/synthesis/soc_system.qip**
  - Sadrži sve potrebne informacije da se integracija u **Quartus dizajn** automatizuje.
  - Koristi se u **Quartus Project Navigator → Project → Add Files**   
- (Opcionalno) Simulation fajlovi

Sada mozemo zatvoriti **Qsys** i nastaviti rad u okviru **Quartus Prime** softvera

### Proces kompajliranja dizajna

- Kako smo prethodno komandom **Generate** izgenerisali **synthesis** fajl potreban za proces kompilacije sistema u Quartus Prime projektu, moramo ga dodati
u sam projekat **Project->Add/Remove Files in Project->**
![image](https://github.com/user-attachments/assets/0c3527f9-e2bd-401d-98ef-f8fb437dbe58)


- Krovni VHDL dizajn je dao kao [meridian_top.vhd](../vhd/meridian_top.vhd), te cemo nakon pokretanja [Tcl skripte](../tcl/pin_assignment_de1_soc.tcl) pokrenuti samo proces **Analize i Sinteze**.
- Nakon sto je **Analysis & Synthesis** uspjesno zavrsena, pokrecemo drugu [Tcl skriptu](../tcl/hps_sdram_p0_pin_assignments.tcl)
- Sada pokrecemo cjelokupan proces kompilacije sa **Processing->Start compilation**


