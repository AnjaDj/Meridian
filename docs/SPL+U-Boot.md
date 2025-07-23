# Konfiguracija i kompajliranje U-Boot-a

Prvo je potrebno da preuzmemo *U-Boot* izvorni kod, koristicemo officijalni Intel SOCFPGA U-Boot repozitorijum
```bash
git clone https://github.com/altera-opensource/u-boot-socfpga
cd u-boot-socfpga
git checkout 2022.04
```

>[!NOTE]
> Treba voditi racuna na koju granu se radi `checkout`. Grane sa `RC` labelom u svom nazivu (poput
> `socfpga_agilex5-23.1_RC`) su razvojne grane, dok su one bez `RC` sufiksa stabilne.
