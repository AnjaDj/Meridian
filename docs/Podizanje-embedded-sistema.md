### 1.  Power-On / Reset 
Kada se uređaj uključi ili resetuje, procesor dobija signal za **reset**.</br>
CPU postavlja sve registre u podrazumevano stanje i traži početnu adresu za izvršavanje koda koja je hardverski fiksirana na **BootROM**

### 2. Izvršavanje BootROM koda
**BootROM** kod je 'uprzen' u sam silicijum i sadrzi instrukcije koje obavljaju *najosnovnije inicijalizacione rutine* za periferne uredjaje koji cine **boot-source**
preko kojih ucitavamo **bootloader**.</br>

Zavisno od hardverske konfiguracije (podesavanjem odgovarajucih switch-eva) biramo iz kog izvora ce se ucitati **bootloader**, tj. koji nam je **boot-source**:
 - Flash memorija (NOR/NAND Flash)
 - SD kartica ili eMMC memorija
 - USB uređaj
 - Mreža (PXE Boot)

> [!NOTE] 
> Kod iz **BootROM**a se nikad ne ucitava u RAM.</br>

### 3. Ucitavanje SPL-a (preloader-a) i second-stage bootloadera u RAM
Nakon sto je **boot-source** periferija uspjesno inicijalizovana, **BootROM** instrukcije identifikuju particiju tipa **0xA2** i ucitavaju **SPL (preloader)** sa početka 0xA2 particije u SRAM.</br></br>
**BootROM** instrukcije ucitavaju 4 kopije **preloader**-a **(SPL)** u **SRAM**.

> [!NOTE]
> **SRAM** je interna memorija malog kapaciteta koja se nalazi na chip-u i u koju ce biti ucitan **preloader** sto znaci da on ne smije biti veci od kapaciteta **SRAM**a!

> [!NOTE]
> **BootROM** kod ocekuje da pronadje **SPL** na tacno definisanoj i unaprijed poznatoj lokaciji shodno izabranom **boot-source**-u!
> Ako se na primjer koristi SD kartica kao **boot-source**, ne mozemo bilo gdje na njoj smjestiti SPL!
> Tacno se zna na kojoj particiji i pocevsi od koje adrese se SPL mora nalaziti

Vise o particionisanju i organizaciji SD kartice se moze naci na [stranci](./04:Organizacija_particija_na_SD.md)

Nakon sto je **4xSPL** ucitan u **internu SRAM** izvrsavaju se instrukcije u okviru **preloadera (SPLa)**. </br>
Ove **preloader** instrukcije se odnose na inicijalizaciju *DDR kontrolera* kako bi se omogucila komunikacija sa *eksternom DDR memorijom* i 
kako bismo na raspolaganju imali memoriju veceg kapaciteta za ucitavanje ostatka sistema.</br></br>

Nakon konfiguracije hardvera, **preloader** ucitava sa **0xA2** particije **binarnu sliku U-Boot-a** u **eskternu DRAM**, tj. ucitava **second-stage bootloader** u **eskternu DRAM**! </br>
![image](https://github.com/user-attachments/assets/d5e0350d-c0a7-4f7d-a298-edb4ffd85a49)

Vise o konfiguraciji i kompajliranju U-Boot-a se moze naci na [stranici](./04:Konfiguracija_i_kompajliranje_U-Boot-a.md)

>[!IMPORTANT]
> **SPL** se učitava i izvršava iz interne SRAM.</br>
> **U-Boot** se učitava i izvrsava iz eksternu DRAM nakon što **SPL** inicijalizuje DRRC.

### 4. Ucitavanje ostatka sistema
**Secon-stage bootloader** tj. U-Boot u nasem slucaju preko mreze ili sa SD kartice ucitava u **DRAM** Linux kernel i ostatak sistema koji dalje preuzima kontrolu nad sistemom.</br></br>

Vise o kroskompajliranju **Linux kernela** i njegovom ucitavanju preko mreze u **DRAM** targeta na [stranici](./05:Linux-kernel.md)
