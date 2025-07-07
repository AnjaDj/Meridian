# Prilagodjavanje konfiguracije SPL-a

Konfiguraciju SPL-a prilagođavamo primjenom patch-a i potrebno ga je primjeniti na U-Boot prije kroskompajliranja.

## Preduslov

1. U *Quartus*-u pokrenuti alat *Tools->Qsys/Platform Designer* te ucitati prethodno kreirani **.qsys** fajl </br>
   ![image](https://github.com/user-attachments/assets/f0189792-c9e2-48d4-8f18-c5824b116364)

2. Ici na *Generate->Generate HDL* </br>
   ![image](https://github.com/user-attachments/assets/678c8495-581d-4306-8fa4-fcb587e4d85e)

Ovo ce generisati sve izlazne fajlove, uključujući handoff fajlove za HPS.

## Generisanje patch-a na osnovu Qsys dizajna

Nakon zavrsenog generisanja Qsys dizajna, pronaci direktorijum `hps_isw_handoff/soc_system_hps_0/`. Ovi fajlovi
