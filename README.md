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
|   C14   |   RGMII0_MDIO/USB1_D5/**I2C2_SDA**/HPS_GPIO6   |       I2C2_SDA            |
|   D15   |   RGMII0_MDC/USB1_D6/**I2C2_SCL**/HPS_GPIO7    |       I2C2_SCL            |
|         |                                                |                           |
|   A23   |   **SPIM0_CLK**/I2C1_SDA/UART0_CTS/HPS_GPIO57  |       SPIM0_CLK           |
|   C22   |  **SPIM0_MOSI**/I2C1_SCL/UART0_RTS/HPS_GPIO58  |       SPIM0_MOSI          |
|   B23   |   **SPIM0_MISO**/CAN1_RX/UART1_CTS/HPS_GPIO59  |       SPIM0_MISO          |
|   H20   |   **SPIM0_SS0**,BOOTSEL0/SPIM0_SS0/CAN1_TX/UART1_RTS/HPS_GPIO60   |       SPIM0_SS0          |
|         |                                                |                           |
|   D22   |   I2C0_SCL/**UART1_TX**/SPIM1_MOSI/HPS_GPIO64  |       UART1_TX            |
|   C23   |   I2C0_SDA/**UART1_RX**/SPIM1_CLK/HPS_GPIO63   |       UART1_RX            |

U okviru *Qsys* alata, nakon selekcije funkcija pojedinih pinova, dobijamo sledecu *Peripherals Mux Table* za HPS:
![image](https://github.com/user-attachments/assets/1ead44a2-35d4-4012-bd76-8fe7f8956c9a)
![image](https://github.com/user-attachments/assets/f499456e-fb63-4ce4-9431-6f16899afb55)
<p align="center"><i><b>Slika 3 </b>: Peripherals Mux Table</i></p>
</br>

Kako **HPS** koristi eksternu DDR3, eksportujemo **hps_0_ddr** *Conduit* za pristup toj memoriji, te koristimo sledeci [preset](presets/de1-soc-hps-ddr.qprs) za efikasnije
podesavanje parametara SDRAM-a, dok smo za pristup periferijama povezanim na HPS eksportovali **hps_0_io** *Conduit*.
<p align="center">
  <img src="https://github.com/user-attachments/assets/4b8efe33-9130-4fd5-876d-3a1d582d8ce0" alt="Description" width="500" height="250"/>
</p>
<p align="center"><i><b>Slika 4 </b>: HPS DDR3 SDRAM</i></p>


### ➙ Upravljanje periferijama povezanim na FPGA Fabric iz HPS-a?


**HPS** dio SoC-a koristi **AXI magistralu** dok **FPGA Fabric** koristi **Avalon magistralu**. </br></br>
Kako je neophodno da **HPS** ima pristup periferijama koje se nalaze na **FPGA Fabric**-u, instanciracemo komponentu *PIO (Parallel Input/Output)* koja ce obezbijediti konekciju sa *GPIO konektorom*. Instanciranom *PIO* komponentom cemo pristupiti iz HPS-a preko ***Lightweight HPS-to-FPGA*** interfejsa.

Vise o dostupnim interfejsima za medjukomunikaciju uzmedju *Hard Processor System*-a i *FPGA Fabric*-a se moze naci na [linku](https://haoxinshengic.com/interconnection-structure-between-fpga-and-hps/) .

<p align="center">
  <img src="https://github.com/user-attachments/assets/3a4e3280-7254-49fc-9a70-348a42c5ef2e" alt="Description" width="500" height="400"/>
</p>
<p align="center"><i><b>Slika 5 </b>: Interfejsi izmedju FPGA Fabric-a i HPS-a</i></p>










