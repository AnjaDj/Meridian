## Testiranje I2C
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

## Testiranje SPI

U Linuxu, SPI uređaji se obično koriste preko `kernel drajvera`. Ali ako nasa periferija nema svoj `kernel drajver` ili prosto zelimo da direktno komuniciramo iz `user space`-a bez posebnog drajvera, koristi se `spidev`.
`spidev` je **opšti SPI kernel drajver** koji omogućava da bilo koji SPI uređaj (koji nema svoj specifični kernel drajver) bude dostupan u user space-u. On izlaže SPI uređaj kao fajl u `/dev`, tako da aplikacije mogu da šalju i primaju podatke direktno, bez pisanja posebnog kernel drajvera za svaku periferiju.

Kada je `spidev` omogućen u kernelu i pravilno definisan u `Device Tree` trebali bismo dobiti fajl u `/dev/` poput:
```bash
/dev/spidev0.0
```
gde `0` znači SPI kontroler broj 0, a `.0` je chip select (CS) linija.

>[!NOTE]
> `spidev` nazivamo **opstim drajverom** jer on ne zna nista o specificnoj periferiji (da li je to senzor, DAC, flash memorija, ...) ali pruza mehanizam da
> se iz user-space citaju/salju podaci















Na Linux targetima se za testiranje SPI uređaja često koristi `spidev_test` program koji dolazi uz Linux kernel source kod.
Koristi se da bi se proverilo da li SPI drajver (`spidev`) i SPI magistrala rade ispravno.
spidev je Linux kernel drajver koji omogućava korisničkom prostoru (user-space) da komunicira sa SPI uređajima preko fajlova u /dev/.




