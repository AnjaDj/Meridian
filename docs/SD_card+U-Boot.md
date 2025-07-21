
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

Dodajemo `raw` particiju tipa `0xA2` na kojoj će da se nalazi **SPL** i **U-Boot**. Proces započinjemo komandom `n` za dodavanje nove particije. Biramo primary tip particije (`p`), definišemo broj particije tako da bude `3`, prihvatamo podrazumijevanu vrijednost prvog sektora (pritiskom na taster `Enter` i definišemo posljednji sektor particije (`4095`). Na taj način dobijamo particiju veličine `1MB` (`2048` sektora veličine `512` bajtova). Interaktivna sesija za kriranje ove particije je prikazana ispod.
```bash
Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 3
First sector (2048-30228479, default 2048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-30228479, default 30228479): 4095

Created a new partition 3 of type 'Linux' and of size 1 MiB.
```
Vidimo da je pariticija podrazumijevano tipa `Linux`, što nama ne odgovara, jer treba da bude tipa `0xA2`. Da bismo to promijenili, pokrećemo komandu `t` za promjenu tipa aktuelne particije.
```bash
Command (m for help): t
Selected partition 3
Hex code or alias (type L to list all): a2
Changed type of partition 'Linux' to 'unknown'.
```
Ovim smo završili kreiranje particije `3`. Postupak ponavljamo za particiju `1` i `2`, s tim da treba da definišemo drugačije tipove (`0x0B` za `FAT32` i `0x83` za `EXT4` pariticiju). Za definisanje veličine particija ćemo koristiti kvalifikatore `+32M` i `+1G`, respektivno, čime definišemo veličine od `32MB` i `1GB`. Kompletna interaktivna sesija za kreiranje ovih particija data je ispod.
```bash
Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1,2,4, default 1): 1
First sector (4096-30228479, default 4096): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4096-30228479, default 30228479): +32M

Created a new partition 1 of type 'Linux' and of size 32 MiB.

Command (m for help): t
Partition number (1,3, default 3): 1
Hex code or alias (type L to list all): b

Changed type of partition 'Linux' to 'W95 FAT32'.

Command (m for help): n
Partition type
   p   primary (2 primary, 0 extended, 2 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2,4, default 2): 2
First sector (69632-30228479, default 69632): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (69632-30228479, default 30228479): +1G

Created a new partition 2 of type 'Linux' and of size 1 GiB.

Command (m for help): t
Partition number (1-3, default 3): 2
Hex code or alias (type L to list all): 83

Changed type of partition 'Linux' to 'Linux'.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```
Kao što vidimo, proces kreiranja particija kompletiramo komandom `w` koja fizički upisuje informacije o kreiranim particijama na disk.


Ostaje još da formatiramo `FAT32` i `EXT4` particiju. U tu svrhu koristimo sljedeće komande:
```bash
sudo mkfs.vfat -n boot /dev/sda1
sudo mkfs.ext4 -L rootfs /dev/sda2
```
