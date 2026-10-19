# kerakli instrumentlar

typst --version: typst 0.14.2 (b33de9de)

Hammasini birdan compile qilish uchun:
```cmd
set PROJECT=mexatron_modul_va_robotlarning_yuritlamari
git clone https://github.com/axmud/mexatron_modul_va_robotlarning_yuritlamari.git %PROJECT%
winget install typst -v 0.14.2
cd %PROJECT%
for %f in (*.typ) do typst compile "%f"
```
