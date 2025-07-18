Pokrenite ***embedded command shell*** koji bi trebao da se nalazi na putanji poput `/intelFPGA_path/17.0/embedded` </br>
<img width="734" height="139" alt="image" src="https://github.com/user-attachments/assets/abd04831-8dca-4be7-848f-ad26d49be9fd" /> </br>

Nakon sto je **embedded command shell** pokrenut, mozemo pristupiti generisanju neophodnih fajlova
```
$ cd path-to-project-dir
$ qsys-generate soc_system.qsys --synthesis=[VERILOG|VHDL]
$ quartus_sh --flow compile <project name>
```
