
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

**MBR** (Master Boot Record) koji kaze odakle pocinje prva particija
