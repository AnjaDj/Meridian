# Zadatak
Integrisati termalnu kameru [**Meridian-MI1602**](https://www.meridianinno.com/products) na infrastrukturu [**DE1-SoC**](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836) platforme.
Prilagoditi sistem na **FPGA** dijelu tako da se omogući povezivanje izmedju *kamere* 🔄 *I2C/SPI* periferija na **HPS**-u preko dostupnog *GPIO* konektora.</br>

Koristićemo **I2C**/**SPI** periferije koje se nalaze u sklopu **HPS** dijela CycloneV chip-a, s tim da cemo signalima tih HPS periferija pristupati preko **GPIO** konektora koji je, kao sto vidimo na [**Slici 1**](docs/5CSEMA5F31C6_shema.jpg),
povezan na **FPGA** dio CycloneV chip-a. Dakle, signali HPS periferija (konkretno I2C i SPI) ce kroz *FPGA Fabric* biti povezani na pinove *GPIO konektora*.

<p align="center">
  <img src="/docs/5CSEMA5F31C6_shema.jpg" alt="Description" width="500" height="450"/>
</p>
<p align="center"><i><b>Slika 1 </b>: Sema 5CSEMA5F31C6 CycloneV SoC</i></p>

## Realizacija hardvera 💻⚙️

Hardver realizujemo pomocu *Qsys* alata u okviru *Quartus Prime*-a, a nas sistem ce se sastojati od:
1. izvora takst signala od *50MHz*
2. CycloneV HPS
3. *PIO* komponente za povezivanje sa *GPIO* konektorom na *FPGA Fabric*-u

<p align="center">
  <img src="https://github.com/user-attachments/assets/9bd42640-037e-41ea-9cd5-945ec7a4414f"/>
</p>
<p align="center"><i><b>Slika 2 </b>: Sematski prikaz hardverskog sistema realizovanog u okviru Qsys alata</i></p>

### ➙ Podesavanje HPS dijela?

Analizirajuci [fajl](docs/DE1-SoC_schematic.pdf) podesili smo *PinMux* na sledeci nacin :

|   PIN   |               Funkcije PIN-a                   |    Selektovana funkcija   |
|---------|------------------------------------------------|---------------------------|
|   E23   |   TRACE_D7/SPIS1_MISO/**I2C0_SCL**/HPS_GPIO56  |       I2C0_SCL            |
|   C24   |   TRACE_D6/SPIS1_SS0/**I2C0_SDA**/HPS_GPIO55   |       I2C0_SDA            |
|         |                                                |                           |
|   H23   |   TRACE_D3/**SPIS0_SS0**/I2C1_SCL/HPS_GPIO52   |       SPIS0_SS0           |
|   A25   |   TRACE_D2/**SPIS0_MISO**/I2C1_SDA/HPS_GPIO51  |       SPIS0_MISO          |
|   C25   |   TRACE_D1/**SPIS0_MOSI**/UART0_TX/HPS_GPIO50  |       SPIS0_MOSI          |
|   B25   |   TRACE_D0/**SPIS0_CLK**/UART0_RX/HPS_GPIO49   |       SPIS0_CLK           |
|         |                                                |                           |
|   D22   |   I2C0_SCL/**UART1_TX**/SPIM1_MOSI/HPS_GPIO64  |       UART1_TX            |
|   C23   |   I2C0_SDA/**UART1_RX**/SPIM1_CLK/HPS_GPIO63   |       UART1_RX            |

U okviru *Qsys* alata, nakon selekcije funkcija pojedinih pinova, dobijamo sledecu *Peripherals Mux Table* za HPS:
![image](https://github.com/user-attachments/assets/d0179f78-c84d-4b29-b83e-7bf0879a9875)




**HPS** dio SoC-a koristi **AXI magistralu** dok **FPGA Fabric** koristi **Avalon magistralu**.
Kako je neophodno da **HPS** ima pristup periferijama koje se nalaze na **FPGA Fabric**-u, instanciracemo komponentu *PIO (Parallel Input/Output)* koja ce obezbijediti konekciju sa *GPIO konektorom*. Instanciranom *PIO* komponentom cemo pristupiti iz HPS-a preko *Lightweight HPS-to-FPGA* interfejsa.











