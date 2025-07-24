## Sadržaj
1. [Opis](#Zadatak)
2. [Instalacija potrebnih softverskih paketa](/docs/Uputstvo_za_instalaciju_softverskih_paketa.md)
3. [Realizacija hardverskog dijela sistema](/docs/Realizacija_hardverskog_dijela_sistema.md)</br>
  3.1.   [Kreiranje Quartus projekta](/docs/Realizacija_hardverskog_dijela_sistema.md#kreiranje-quartus-projekta)</br>
  3.2.   [Kreiranje Qsys projekta](/docs/Realizacija_hardverskog_dijela_sistema.md#kreiranje-qsys-projekta)</br>
  3.3.   [Kompajliranje dizajna](/docs/Realizacija_hardverskog_dijela_sistema.md#proces-kompajliranja-dizajna)</br>
4. [Generisanje FPGA konfiguracionog fajla](docs/Generisanje_FPGA_konfiguracionog_fajla_iz_QuartusPrime_projekta.md)
5. [Priprema SD kartice](docs/Particionisanje_SD_kartice.md)
  
# Zadatak
Integrisati termalnu kameru [**Meridian-MI1602**](https://www.meridianinno.com/products) na infrastrukturu [**DE1-SoC**](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836) platforme.
Prilagoditi sistem na **FPGA** dijelu tako da se omogući povezivanje izmedju *kamere* 🔄 *I2C/SPI* periferija na **HPS**-u preko dostupnog *GPIO* konektora.</br>

Koristićemo **I2C**/**SPI** periferije koje se nalaze u sklopu **HPS** dijela CycloneV chip-a, s tim da cemo signalima tih HPS periferija pristupati preko **GPIO** konektora koji je, kao sto vidimo na [**Slici 1**](docs/5CSEMA5F31C6_shema.jpg),
povezan na **FPGA** dio CycloneV chip-a. Dakle, signali HPS periferija (konkretno I2C i SPI) ce kroz *FPGA Fabric* biti povezani na pinove *GPIO konektora*.

<p align="center">
  <img src="/docs/5CSEMA5F31C6_shema.jpg" alt="Description" width="500" height="450"/>
</p>
<p align="center"><i><b>Slika 1 </b>: Sema 5CSEMA5F31C6 CycloneV SoC</i></p>

## [Realizacija-hardvera](/docs/Realizacija_hardverskog_dijela_sistema.md) 💻⚙️

Prvi korak jeste da realizujemo hardverski dio sistema i to pomocu ***Qsys*** alata u okviru ***Quartus Prime***-a, a nas sistem ce se sastojati od:
1. **Clock Source** izvora takst signala od *50MHz*
2. **AlteraV/CycloneV HPS**
3. **System Peripheral ID**

Kompletan vodac za kreiranje hardverskog dijela sistema u okviru **Qsys-a/Quartus-a** dat je [ovdje](/docs/Realizacija_hardverskog_dijela_sistema.md), a u nastavcu cemo se dotaci samo najbitnijih tacaka.</br>
<p align="center">
  <img src="https://github.com/user-attachments/assets/c6c00afe-a715-402d-a3eb-ae2d53a5833d"/>
</p>
<p align="center"><i><b>Slika 2 </b>: Sematski prikaz hardverskog sistema realizovanog u okviru Qsys alata</i></p>

### Podesavanje HPS dijela?

Analizirajuci [fajl](docs/DE1-SoC_schematic.pdf) podesili smo *PinMux* na sledeci nacin :

|   PIN   |               Funkcije PIN-a                   |    Selektovana funkcija   |
|---------|------------------------------------------------|---------------------------|
|   C25   |   TRACE_D1/SPIS0_MOSI/**UART0_TX**/HPS_GPIO50  |       UART0_TX            |
|   B25   |   TRACE_D0/SPIS0_CLK/**UART0_RX**/HPS_GPIO49   |       UART0_RX            |
|         |                                                |                           |
|    -    |      FPGA mode=Full                            |          I2C2             |
|    -    |      FPGA mode=Full                            |          SPIM0            |
|         |                                                |                           |
|    -    |      HPS I/O  RGMII                            |          EMAC1            |
|    -    |      HPS I/O  4-bit Data                       |          SDIO0            |


Kako **HPS** koristi eksternu DDR3, eksportujemo **hps_0_ddr** *Conduit* za pristup toj memoriji, te koristimo sledeci [preset](presets/de1-soc-hps-ddr.qprs) za efikasnije
podesavanje parametara SDRAM-a, dok smo za pristup periferijama povezanim na HPS eksportovali **hps_0_io** *Conduit*.
<p align="center">
  <img src="https://github.com/user-attachments/assets/4b8efe33-9130-4fd5-876d-3a1d582d8ce0" alt="Description" width="500" height="250"/>
</p>
<p align="center"><i><b>Slika 4 </b>: HPS DDR3 SDRAM</i></p>

Nakon sto smo ispratili sve korake navedene u [vodicu](/docs/Realizacija_hardverskog_dijela_sistema.md) za realizaciju hardverskod dijela sistema, trebalo bi da je uspjesno zavrsen proces 
kompilacije **Processing->Start compilation**. 


Nakon kompilacije dizajna, dobicemo **output_files/meridian_top.sof**, koji cemo konvertovati u **Raw Binary File (.rbf)** za konfiguraciju **FPGA Fabric**-a tokom procesa **boot**-anja sistema. Ovaj postupak je detaljno opisan u [vodicu](/docs/Generisanje_FPGA_konfiguracionog_fajla_iz_QuartusPrime_projekta.md) za generisanje **FPGA konfiguracionog fajla**.


## Izgradnja embedded Linux sistema

Sada je potrebno da izgradimo **embedded Linux sistem**. U sklopu ovog repozitorijuma objasnjena su 2 nacina
za kompletnu izgradjnu jednog embedded sistema i to:
- koristenjem **Buildroot**-a (istovremeno build-amo sve dijelove sistema)
- pojedinacnom izgradnjom svakog dijela sistema






