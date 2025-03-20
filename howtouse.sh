docker build --platform linux/amd64 -t nasm-dev-i386-asm-main .
docker run -it --rm -v $(pwd):/workspace nasm-dev-asm-main
sudo apt install nasm
sudo apt-get install libc6-dev-i386
sudo apt-get install libx32gcc-4.8-dev
sudo apt-get install gcc-multilib
sudo apt-get install gcc-6-multilib
nasm -f elf -d ELF_TYPE asm_io.asm
nasm -f elf quicksort.asm
gcc -m32 -c driver.c
nasm -f elf quicksort.asm
gcc -m32 driver.o quicksort.o asm_io.o
./a.out