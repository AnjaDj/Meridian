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
```
make
```

