# Generisanje konfiguracionog .rbf fajla iz .sof fajla

Vodic za generisanje FPGA konfiguracionog fajla pomocu *Intel Quartus Prime* alata. Moguce je da se konfiguracija *FPGA Fabric*-a
izvrsi ili tokom procesa **boot**-anja sistema ili od strane **Linux** OS-a. Obije mogucnosti su opisane u nastavku teksta.

## Preduslov

- Kompajliran VHDL dizajn (**Processing->Start Compilation**), nakon cega ce biti izgenerisan **.sof** fajl.

## Koraci za generisanje .sof fajla

Ukoliko prethodno nije uradjeno, evo koraka za generisanje **.sof** fajla:
1. Otvoriti projekat u *Intel Quartus Prime* alatu (**File->Open Project->meridian.qpf**)
2. Pokrenuti kompletan proces kompilacije (**Processing->Start Compilation**)
3. Nakon uspjesne kompilacija (*100%*) Quartus kreira **.sof** fajl u folderu *output_files* (*output_files/meridian_top.sof*)

## Generisanje FPGA konfiguracionog fajla

Otvorite projekat u *Intel Quartus Prime* alatu (**File->Open Project->meridian.qpf**), te idite na **File->Convert Programming Files**.
- Za konfiguraciju FPGA Fabric-a tokom faze **boot**-ovanja sistema sa U-Boot-om:
    - **Type**: Raw Binary File (.rbf)
    - **Mode**: Passive Paralle x8
    - **Input files to convert->Add file->.sof**
    - Nakon podesavanja, idite na **Generate**
![image](https://github.com/user-attachments/assets/21c7e661-f2a2-48d7-a74e-1f938691d7eb)

- Za konfiguraciju FPGA Fabric-a iz **Linux**-a:
    - **Type**: Raw Binary File (.rbf)
    - **Mode**: Passive Paralle x16
    - **Input files to convert->Add file->.sof**
    - Nakon podesavanja, idite na **Generate**
![image](https://github.com/user-attachments/assets/1f75236a-f734-4ee5-ab87-8b87045ae8be)

## Kopiranje konfiguracionog .rbf fajla na FAT32 particiju na SD kartici

U nasem slucaju struktura particija na SD kartici je kao na slici:</br>
![image](https://github.com/user-attachments/assets/5819590a-5373-4360-9b6c-a1139b69cff8) </br>
![image](https://github.com/user-attachments/assets/5cc6c31e-3e93-4347-af61-3d3f9b98b8e4) </br>

Proces kopiranja fajla na **FAT32** je sledeci:
1. Umetnite SD karticu u citac za PC
2. Napravicemo **mount point** - folder gdje cemo montirati particiju  `sudo mkdir /mnt/mydisk`
3. Montiramo particiju ***/dev/sda1*** na ***/mnt/mydisk***. Sada ce sadržaj particije ***/dev/sda1*** biti dostupan kroz ***/mnt/mydisk***</br>`sudo mount /dev/sda1 /mnt/mydisk`
4. Kopiramo fajl `sudo cp socfpga.rbf /mnt/mydisk/`
5. Odmontiramo particiju `sudo umount /mnt/mydisk`

Ukoliko zelimo da provjerimo da li je kopiranje zaista i izvrseno, mozemo umetnuti SD karticu nazad u plocu, pokrenuti je i uci u U-Boot konzolu:
1. Koritimo komandu `fatls` kojoj moramo proslijediti naziv uređaja (`mmc`), broj uređaja (`0`), broj particije (`1`) i putanju do foldera čiji sadržaj želimo da izlistamo (u našem slučaju to je korjeni folder /)</br>
`fatls mmc 0:1 /`
2. Ako fajl nije prikazan ili ne može da se učita, pokrecemo `mmc rescan` a zatim ponovo `fatls mmc 0:1 /`
3. Sada ćemo učitati ovaj tekstualni fajl u RAM na lokaciju 0x01000000 </br>
`fatload mmc 0:1 0x01000000 socfpga.rbf`
4. Koristimo komandu md (memory dump) koja nam prikazuje sadržaj memorije na specificiranoj lokaciji</br>
`md 0x01000000`

## Reference
[link1](https://stackoverflow.com/questions/28799960/how-to-generate-rbf-files-in-altera-quartus) </br>
[link2](https://github.com/robseb/rsyocto/blob/rsYocto-1.041/doc/guides/6_newFPGAconf.md)
