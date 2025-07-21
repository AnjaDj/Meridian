
## Priprema SD kartice

Da bi sistem mogao ispravno da se pokrene na **DE1-SoC** ploči sa SD kartice,
potrebno je da obezbijedimo da organizacija particija na kartici odgovara onoj koju očekuje
**BootROM** kod **Cyclone V** čipa.

<p align="center">
  <img width="500" height="300" alt="image" src="https://github.com/user-attachments/assets/432c1639-7754-4778-af14-cc7d98619365" />
</p>
<p align="center"><i><b>Slika 1 </b>: Organizacija SPL-a na SD/MMC kartici</i></p>



**BootROM** kod ce provjeriti da li postoji **MBR**:
- Ako ne postoji smatrace da se radi o **Raw mode** i da se **first-stage bootloader** nalazi ondmah na pocetku tj. da se nalazi na nultoj pocetnoj adresi.
- Ako postoji smatrace da se radi o **Partition mode** te ce do **first-stage bootloadera** doci na osnovu inforamcija u **MBR**-u.

> [!NOTE]
**MBR** (Master Boot Record) pokazuje odakle pocinje prva particija

U nasem slucaju, organizacija particija sa ocekivanim tipom i sadrzajem na svakoj od particija ce biti kao na slici ispod
<img width="2514" height="995" alt="image" src="https://github.com/user-attachments/assets/64a544b4-8357-41a3-8121-0ed78d8c7a50" />

Prvi korak jeste da se umetne SD kartica u citac te da se `unmount`-uju sve particije
```bash
lsblk
sudo umount /dev/sda1
sudo umount /dev/sda2
sudo umount /dev/sda3
```
Sada ćemo da obrišemo sadržaj **MBR**, kako bismo mogli da kreiramo sopstvene particije u skladu sa prethodno opisanom strukturom SD kartice. U tu svrhu nam služi komanda koja briše prvi sektor od 512 bajtova u kojem se nalazi MBR
```
sudo dd if=/dev/zero of=/dev/sda bs=512 count=1
```
Sljedeći korak je kreiranje particija. Pokrećemo fdisk alatku za željeni uređaj
```
sudo fdisk /dev/sda
```
U našem slučaju, interesantne su nam sljedeće komande:
- `n` kojom dodajemo novu particiju,
- `t` kojom definišemo tip particije i
- `w` kojom se kreirana tabela upisuje na disk i završava proces njegovog particionisanja</br>

Dodajemo `raw` particiju tipa `0xA2` na kojoj će da se nalazi **SPL** i **U-Boot**. Proces započinjemo komandom `n` za dodavanje nove particije. Biramo primary tip particije (`p`), definišemo broj particije tako da bude `3`, prihvatamo podrazumijevanu vrijednost prvog sektora (pritiskom na taster `Enter` i definišemo posljednji sektor particije (`4095`). Na taj način dobijamo particiju veličine 1MB (`2048` sektora veličine `512` bajtova). Interaktivna sesija za kriranje ove particije je prikazana ispod.










