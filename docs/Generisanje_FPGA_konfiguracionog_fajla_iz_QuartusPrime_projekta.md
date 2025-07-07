# BLA BLA

## Preduslov

- Kompajliran VHDL dizajn (*Processing->Start Compilation*), nakon cega ce biti izgenerisan **.sof** fajl.

## Koraci za generisanje .sof fajla

Ukoliko prethodno nije uradjeno, evo koraka za generisanje **.sof** fajla:
1. Otvoriti projekat u *Intel Quartus Prime* alatu (*File->Open Project->meridian.qpf*)
2. Pokrenuti kompletan proces kompilacije (*Processing->Start Compilation*)
3. Nakon uspjesne kompilacija (*100%*) Quartus kreira **.sof** fajl u folderu *output_files* (*output_files/meridian_top.sof*)

## Generisanje FPGA konfiguracionog fajla

Otvorite projekat u *Intel Quartus Prime* alatu (*File->Open Project->meridian.qpf*), te idite na *File->Convert Programming Files*.
- Za konfiguraciju FPGA Fabric-a tokom faze boot-ovanja sistema sa U-Boot-om:
    - **Type**: Raw Binary File (.rbf)
    - **Mode**: Passive Paralle x8
    - **Input files to convert->Add file->.sof**
    - Nakon podesavanja, idite na **Generate**
![image](https://github.com/user-attachments/assets/21c7e661-f2a2-48d7-a74e-1f938691d7eb)



