U Linux source kodu (poput https://github.com/altera-fpga/linux-socfpga/tree/socfpga-6.1.38-lts) se unutar direktorijuma `drivers/` nalazi veliki broj `.h .c` fajlova koji predstavljaju 
source kod Linux kernel drajvera za neke od poznatih cesto koristenih periferija.
```
linux-socfpga
├── drivers
│   ├── i2c
│   └── i3c
|   └── spi
│   └── iio
|   ...
```

Kad konfigurišeš kernel (`make menuconfig`), za svaki drajver imaš tri opcije:
- **Isključen** (`< >`)  neće biti u kernelu cak ni kao modul

- **Ugrađen** (`[*]` ili `[y]`)  drajver se kompajlira direktno u kernel image (zImage)
    - Prednost: uređaj će biti dostupan čim se kernel podigne (bitno za uređaje potrebne pri boot-u, npr. early serial konzola)
    - Mana: povećava veličinu kernela, ne možeš ga dinamički zamijeniti bez recompila

- **Modul** (`<M>`) drajver se kompajlira kao zaseban `.ko` fajl (kernel object).
   - Nalazi se u `/lib/modules/$(uname -r)/...` na targetu.
   - Učitaš ga ručno `insmod` ili `modprobe`
   - Prednost: fleksibilnost, možeš ga update-ovati bez rekompajliranja cijelog kernela
   - Mana: uređaj neće biti odmah dostupan u very-early fazi boot-a (npr. kad ti treba rootfs)


Evo kako mozemo podesiti konfiguraciju Linux kernela sa ADXL345 akcelerometrom kao drajver modulom
```
cd linux-socfpga
source setup.sh
make menuconfig
```
**Device Drivers→Industrial I/O support→Accelerometers→Analog Devices ADXL345 3-Axis Digital Accelerometer I2C Driver** postavimo na `<M>` kako bi drajver bio definisan
kao moduo a ne da bude ugradjen u sliku kernela.
Nakon konfiguracije, možemo da ponovo kroskompajliramo kernel komandom `make`.

Drajver za akcelerometar ADXL345 kompajliran kao **kernel modul**. Da bi učitali ovaj kernel modul, potrebno je da pronađemo njegov *alias*, koji se nalazi u fajlu `modules.alias`. Izlistavanjem sadržaja ovog fajla dobijamo sljedeće informacije:
```
~ # cat /lib/modules/6.1.38-etfbl-lab+/modules.alias
# Aliases extracted from modules themselves.
alias platform:altera_ilc altera_ilc
alias of:N*T*Caltr,ilc-1.0C* altera_ilc
alias of:N*T*Caltr,ilc-1.0 altera_ilc
[...]
alias i2c:adxl375 adxl345_i2c
alias i2c:adxl345 adxl345_i2c
alias of:N*T*Cadi,adxl375C* adxl345_i2c
alias of:N*T*Cadi,adxl375 adxl345_i2c
alias of:N*T*Cadi,adxl345C* adxl345_i2c
alias of:N*T*Cadi,adxl345 adxl345_i2c
alias acpi*:ADS0345:* adxl345_i2c
```
Iz prikazane liste se jasno vidi da naš drajver ima alias `i2c:adxl345`, koji koristimo pri učitavanju kernel modula komandom `modprobe`.
```
modprobe i2c:adxl345
```
Da je drajver bio konfigurisan kao dio Linux kernela (`<*>`), onda ne bi bilo potrebe za ucitavanjem jer bi on vec bio ucitan u radnu memoriju.


Jednom kada je Linux kernel drajver ucitan u radnu memoriju (bilo kao Linux kernel moduo ili ugradjen u kernel image), dolazimo do filozofije Linuxa: **sve je fajl**.
Kada je drajver ucitan u radnu memoriju, kernel registruje uredjaj kroz **device model** (najčešće kao char device, block device ili preko nekog subsistema tipa net, v4l2, input, hwmon…). Kernel tada u /dev/ napravi odgovarajući fajl uređaja (device node) poput
- `/dev/spidevX.Y`
- `/dev/2c-{bus}`
- `/dev/ttyS0`
- 

