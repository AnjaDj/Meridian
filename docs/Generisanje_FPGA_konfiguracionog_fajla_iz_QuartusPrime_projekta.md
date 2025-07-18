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


Sada je fajl za **konfiguraciju FPGA Fabric**-a spreman i potrebno ga je kopirati na **na FAT particiju na SD kartici** i taj proces je opisan u odjeljku ispod. Medjutim,
kako jos uvijek nemamo spremnu **SD karticu**, ovdje cemo stati i prvo cemo pripremiti SD karticu i izbildati kompletan sistem, pa cemo se naknadno
vratiti na kopiranje **.rbf**-a na **FAT** particiju. 

Dakle, sada se prebacujemo na [izgradnju Linux sistema](Generisanje_sistema_koriscenjem_Buildroot_alata.md).
Kada zavrsimo sa time, vracamo se na [Kopiranje konfiguracionog rbf fajla na FAT particiju na SD kartici](#kopiranje-konfiguracionog-rbf-fajla-na-fat-particiju-na-sd-kartici)

## Kopiranje konfiguracionog rbf fajla na FAT particiju na SD kartici

Prije prelaska na korak kopiranja fajlova na specificnu particiju, korisno je upoznati se sa ocekivanom strukturom
SD kartice za nasu DE1-SoC platformu. Vise o tome sse moze naci u sledecem [vodicu](bla).
U nasem slucaju struktura particija na SD kartici je kao na slici:</br>
<img width="2514" height="995" alt="image" src="https://github.com/user-attachments/assets/17cf4f84-7979-4ec7-9ef3-997c8783763c" />
<p align="center"><i>Ocekivana organizacija particija na SD kartici sa ocekivanim sadrzajem</i></p>

Potrebno je kopirati **socfpga.rbf** fajl na **FAT32** particiju, gdje se nalaze i **zImage** i **DTB**.

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
