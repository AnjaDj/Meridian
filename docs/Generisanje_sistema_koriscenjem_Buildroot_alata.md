# 🧱 Šta je Buildroot?

**Buildroot** je alat (framework) koji se koristi za automatsko generisanje **celog Linux sistema** (toolchain + bootloader + kernel + root filesystem) za neku embedded platformu.

🔁 Šta Buildroot može da generiše?
- **toolchain**  (C/C++ kompajler, C/C++ libs, Kernel headers, binutils, ...)
- **Bootloader** (Obično U-Boot)
- **Linux kernel**
- **rootfs** (BusyBox + biblioteke + korisnicke aplikacije)
- **SD image** (Gotov .img fajl koji možeš flashovati na SD karticu)
