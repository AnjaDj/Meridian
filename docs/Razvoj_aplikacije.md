## MI48E4 Thermal Image Processor (TIP) Board

<p align="center">
  <img src="https://github.com/user-attachments/assets/6c013d57-1f88-454c-9bc4-fbac36245350" alt="Description">
</p>
<p align="center"><i><b>Slika 1 </b>: Panther EVK board </i></p>

Na Slici 1 je prikazan MI48E4 TIP Board sa **MI1602M5S Camera Module** i **MI48E4 Thermal Image Processor** na sebi.</br>
**MI1602M5S Camera Module** je termalni senzor za snimanje slika od 160x120x2B dugotalasnog infracrvenog zracenja.</br>
**MI48E4 Thermal Image Processor** je procesor za kontrolu *low-level* signala za snimanje sirovih podataka iz termovizijskog niza i obezbjedjuje standardne interfejse za komunikaciju sa *host*-om.</br>

**Panther EVK board** se moze povezati na</br>
a)  nezavisni kompjuterski sistem ili mobilni uredjaj preko **USB** interfejsa </br>
b)  embedded platformu preko **I2C** i **SPI** interfejsa </br>

<p align="center">
 <img width="578" height="431" alt="image" src="https://github.com/user-attachments/assets/47a873bf-d334-463a-83de-58c5cc0aee99" />
</p>
<p align="center"><i><b>Slika 2 </b>: Konceptualni dijagram 2 nacina povezivanja Panthera EVK board </i></p>

## MI48E4 TIP Registarska Mapa

| Registar | Adresa registra | Vrijednost | Opis |
|----------|-----------------|------------|------|
| MCU_RESET | 0X00 | 0x01 | softverski reset MI48E4 komponente |
| FRAME_MODE | 0xB1 | 0x21 | Single Frame Mode bez zaglavlja |
| FRAME_MODE | 0xB1 | 0x01 | Single Frame Mode sa zaglavljem |
| FRAME_MODE | 0xB1 | 0x22 | Continuous Capture Mode bez zaglavlja |
| FRAME_MODE | 0xB1 | 0x02 | Continuous Capture Mode sa zaglavljem |
| STATUS | 0xB6 | 0x02 | Readout too slow in Continuous Capture Mode |
| STATUS | 0xB6 | 0x04 | Error detected on the SenXor interface during power up of the MI48E4 |
| STATUS | 0xB6 | 0x08 | Communication error on the SenXor interface during thermal data capture |
| STATUS | 0xB6 | 0x10 |  |
| STATUS | 0xB6 | 0x20 | MI48xx is still booting up |

<p align="center">
 <img width="710" height="539" alt="image" src="https://github.com/user-attachments/assets/23f00d33-5469-45de-b53f-ded981e07cac" />
</p>
<p align="center"><i><b>Slika 3 </b>: Thermal Data Frame format </i></p>

<p align="center">
 <img width="697" height="701" alt="image" src="https://github.com/user-attachments/assets/87df0741-d897-423b-a97d-d0e251f415f2" />
</p>
<p align="center"><i><b>Slika 4 </b>: Status Register </i></p>

Jedan temperaturni frejm se sastoji od 160x120 rijeci tj. 160x120x2 bajtova (svaka rijec je 2B). Tokom transfera prvo se prenosi bit najvece tezine (BE).
Svaka rijec predstavlja temperaturu jednog piksela i predstavljena je kao 16-bit unsigned integer u jedinici 0.1K. Tako na primjer, ako primimo 16-bit rijec 0x0bc1 to ce odgovarati tepmeraturi 300.9K



## Testiranje I2C konekcije

Periferija i DE1-SoC sistem ce komunicirati preko I2C interfejsa s ciljem da se postave odgovarajuce konfiguracione vrijednosti u registrima periferije zarad njene konfiguracije i kontrole. S tim u vezi neophodno je provjeriti da li Linux sistem vidi nas I2C uredjaj ili ne.

Alatka `i2cdetect`  omogućava detekciju I2C uređaja na magistrali.
Mozemo izlistati sve I2C magistrale (kontrolera) koje kernel trenutno vidi
```bash
# i2cdetect -l
i2c-0   i2c             Synopsys DesignWare I2C adapter         I2C adapter
i2c-1   i2c             Synopsys DesignWare I2C adapter         I2C adapter
i2c-2   i2c             Synopsys DesignWare I2C adapter         I2C adapter

```
Nas periferni uredjaj je povezan na I2C2 magistralu sa adresom `0x40`, sto potvrdjujemo komandom
```bash
# i2cdetect -ry 2
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:                         -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: 40 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
70: -- -- -- -- -- -- -- --
```

## Testiranje SPI konekcije

SPI interfejs ce se koristiti za primanje frame-ova sa termalne kamere.

U Linuxu, **SPI uređaji** se obično koriste preko **kernel drajvera**. Ako periferija nema svoj **kernel drajver** ili prosto zelimo da direktno komuniciramo iz `user space` bez posebnog drajvera, koristi se `spidev`.</br>
`spidev` je **opšti SPI kernel drajver** koji omogućava da bilo koji SPI uređaj (koji nema svoj specifični kernel drajver) bude dostupan u **user space**-u. On izlaže SPI uređaj kao fajl u `/dev`, tako da aplikacije mogu da šalju i primaju podatke direktno, bez pisanja posebnog kernel drajvera za svaku periferiju.

Kada je `spidev` omogućen u kernelu i pravilno definisan u `Device Tree` trebali bismo dobiti fajl u `/dev/` poput:
```bash
/dev/spidev0.0
```
gde `0` znači SPI kontroler broj 0, a `.0` je chip select (CS) linija.

>[!NOTE]
> `spidev` nazivamo **opstim drajverom** jer on ne zna nista o specificnoj periferiji (da li je to senzor, DAC, flash memorija, ...) ali pruza mehanizam da
> se iz `user-space` citaju i salju podaci

Na Linux targetima se za testiranje SPI uređaja često koristi `spidev_test` program koji dolazi uz Linux kernel source kod.
Koristi se da bi se proverilo da li SPI drajver (`spidev`) i SPI magistrala rade ispravno.
spidev je Linux kernel drajver koji omogućava korisničkom prostoru (user-space) da komunicira sa SPI uređajima preko fajlova u /dev/.


## Razvoj aplikacije

Posto za **MI48E4** periferiju ne postoji Linux kernel drajver, necemo ga odmah ni pisati nego cemo prvo testirati kameru kroz `user-space` aplikaciju.
Koristicemo postojece opste Linux kernel drajvere 
- `spidev`   , opsti Linux kernel drajver koji izlaze I2C uredjaje kroz fajl `/dev/spidevX.Y`
- `i2c-dev`  , opsti Linux kernel drajver koji izlaze SPI uredjaje kroz fajl `/dev/i2c-{bus}`

