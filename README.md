# Zadatak
Integrisati termalnu kameru [**Meridian-MI1602**](https://www.meridianinno.com/products) na infrastrukturu [**DE1-SoC**](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836) platforme.
Prilagoditi sistem na **FPGA** dijelu tako da se omogući povezivanje izmedju *kamere* 🔄 *I2C/SPI* periferija na **HPS**-u preko dostupnog *GPIO* konektora

## Realizacija hardvera

<figure style="text-align: left;">
  <img src="/docs/5CSEMA5F31C6_shema.jpg" alt="Description" width="400" height="350"/>
  <figcaption> <b>Slika 1 </b>: Shema 5CSEMA5F31C6 CycloneV SoC</figcaption>
</figure>
