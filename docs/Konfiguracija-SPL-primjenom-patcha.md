Ukoliko uradite
```
git clone https://gitlab.denx.de/u-boot/u-boot
cd u-boot
git checkout  v2025.04
cd board/terasic/de1-soc/qts
```
vidjecete da se tu nalaze 4 fajla:
- **iocsr_config.h**
- **pinmux_config.h**
- **pll_config.h**
- **sdram_config.h**

Ovo su podrazumjevani fajlovi koji dolaze uz **U-Boot** za **DE1-SoC** ploču.
Oni su generisani od strane **Altera (Intel) Qsys HPS** konfiguracije, ali su već ubačeni u **U-Boot** repozitorijum kao primeri/defaulti za tu ploču.

>[!NOTE]
>Ako se koristi potpuno ista hardverska konfiguracija kao i originalni **Terasic** dizajn, ovi fajlovi su dovoljni.

Medjutim ako se u **Qsys**-u:
- dodalo ili promenilo nešto u HPS komponenti (npr. promjena pinmux, RAM, PLL, i.t.d.),
- onda se generisao novi **hps_isw_handoff** direktorijum (nakon Generate HDL)

