# Zadatak
Integrisati termalnu kameru [**Meridian-MI1602**](https://www.meridianinno.com/products) na infrastrukturu [**DE1-SoC**](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836) platforme.
Prilagoditi sistem na **FPGA** dijelu tako da se omogući povezivanje izmedju *kamere* 🔄 *I2C/SPI* periferija na **HPS**-u preko dostupnog *GPIO* konektora

## Realizacija hardvera
Koristićemo **I2C**/**SPI** periferije koje se nalaze u sklopu **HPS** dijela CycloneV chip-a, s tim da cemo signalima tih HPS periferija pristupati preko **GPIO** konektora koji je, kao sto vidimo na **Slici 1**,
povezan na **FPGA** dio CycloneV chip-a. Dakle, signali HPS periferija (konkretno I2C i SPI) ce kroz *FPGA Fabric* biti povezani na pinove *GPIO konektora*.

<figure style="text-align: left;">
  <img src="/docs/5CSEMA5F31C6_shema.jpg" alt="Description" width="400" height="350"/>
  <figcaption> <b>Slika 1 </b>: Shema 5CSEMA5F31C6 CycloneV SoC</figcaption>
</figure> </br></br>


Kako je neophodno da **HPS** ima pristup periferijama koje se nalaze na **FPGA Fabric**-u, instanciracemo komponentu *PIO (Parallel Input/Output)* koja ce obezbijediti konekciju sa *GPIO konektorom*.
Instanciranom *PIO* komponentom cemo pristupiti iz HPS-a preko *Lightweight HPS-to-FPGA* interfejsa
