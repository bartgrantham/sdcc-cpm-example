This appears to work:

```
#rm -rf build
export APP=minboop
if [ ! -d build ]; then mkdir build; fi

/Users/bart/bin/sdcc/bin/sdasz80 -plosff  build/cpm0.o ../../src/cpm/cpm0.s
cp ../../src/cpm/cpm0.rel build/cpm0.rel

for i in syslib/cprintf.c cpm/cpmbdos.c syslib/ansi_term.c syslib/cpm_sysfunc.c hw/common/hw_common.c hw/modprn02/hw_modprn02.c; do sdcc -c -mz80 -D__SDCC__=1 -I../../src/include -I../../src/ -o build/ ../../src/$i; done
sdcc -c -mz80 -D__SDCC__=1 -I../../src/include -I../../src $APP.c -o build/
cat << ++END++ > build/$APP.arf
-mjx
-i build/$APP.ihx
-k /Users/bart/bin/sdcc/share/sdcc/lib/z80/
-l z80
build/cpm0.rel
build/cpmbdos.rel
build/cprintf.rel
build/cpm_sysfunc.rel
build/ansi_term.rel
build/hw_common.rel
build/hw_modprn02.rel
build/$APP.rel
-e
++END++
sdldz80 -nf build/$APP.arf
../../lbin/load build/$APP
cpmrm -T raw -f brads8mb ../../../vcf-2017/compiletest.dsk 0:$APP.com
cpmcp -T raw -f brads8mb ../../../vcf-2017/compiletest.dsk build/$APP.com 0:$APP.com
```



Note: This still doesn't qork right.  It creates binaries that hang CP/M.  :-/
I think the problem is the includes for sdcc.  If run from the upper level directory it works, but in esrc or minboop it bombs.  I think there's a hidden include happening, like "./lib/" or something, that is failing from the sub directories.  Although, -I.. didn't seem to help.

* `sdcc -c -mz80 -D__SDCC__=1 -I../../src/include -I../../src minboop.c -o tmp/`
  * Directory argument **must have a trailing slash**!
  * Generates `.sym` (symbol), `.rel` (relocatable? object), `.lst` (list), `.asm` (assembly) files
  * This also calls the assembler with the command `sdasz80 -plosgffw tmp/minboop.rel tmp/minboop.asm`
    * Flags for sdasz80 are: "disable automatic listing pagination", "create .lst (list) file", "create .rel (object) file", "create .sym (symbol) file", "undefined symbols made global", "flag relocatable references by mode in listing file", "wide listing format for symbol table"
* `for i in cpm0.rel cpmbdos.rel cprintf.rel cpm_sysfunc.rel ansi_term.rel hw_common.rel hw_modprn02.rel; do cp ../../bin/$i tmp/; done`
* 
```
cat << ++END++ > tmp/minboop.arf
-mjx
-i tmp/minboop.ihx
-k /Users/bart/bin/sdcc/share/sdcc/lib/z80/
-l z80
tmp/cpm0.rel
tmp/cpmbdos.rel
tmp/cprintf.rel
tmp/cpm_sysfunc.rel
tmp/ansi_term.rel
tmp/hw_common.rel
tmp/hw_modprn02.rel
tmp/minboop.rel
-e
++END++

```

`sed 's/REPLACE_ME_PLEASE/minboop/' ../../bin/generic.arf | sed 's/bin\//tmp/' > tmp/minboop.arf`
* `sdldz80 -nf tmp/minboop.arf`
  * "-nf" means "no echo of commands, use command file as input"
  * Generates `.noi`, `.map`, `.ihx` files
  * File inlcudes:
    * "-mjx" : generate `.map` output, generate `.noi` (NoICE debugger) output, generate hexadecimal output
    * "-i tmp/minboop.ihx" : Generate `.ihx` (Intel Hex) output, also forces other files to be generated in same directory
    * "-k /Users/bart/bin/sdcc/share/sdcc/lib/z80/" : library path specification (contains `crt0.rel` and `z80.lib`)
    * "-l z80" : library file specification => includes `/Users/bart/bin/sdcc/share/sdcc/lib/z80/z80.lib`
    * A bunch of .rel files, including the one created by `sdcc` in the previous step
    * "-e" : allow a null line to terminate output
* `../../lbin/load tmp/minboop`
  * Takes a .ihx (Intel hex) text file and outputs a .com binary.

From actual, working make:
```
/Users/bart/bin/sdcc/bin/sdcc -c -mz80 -D__SDCC__=1 -Isrc//include -Isrc/ -o bin/ esrc//minboop/minboop.c
sed 's/REPLACE_ME_PLEASE/minboop/' bin//generic.arf > bin//minboop.arf
/Users/bart/bin/sdcc/bin/sdldz80  -nf bin//minboop.arf
lbin//load bin//minboop
```

```
boopoaat-empty: $(BIN_DIR)/boopoaat.com

$(BIN_DIR)/boopoaat.com:        tools $(BIN_DIR)/boopoaat.ihx
        $(LBIN_DIR)/load $(BIN_DIR)/boopoaat

$(BIN_DIR)/boopoaat.ihx:        libraries $(BIN_DIR)/boopoaat.rel $(BIN_DIR)/boopoaat.arf
        $(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/boopoaat.arf

$(BIN_DIR)/boopoaat.rel: $(ESRC_DIR)/boopoaat/boopoaat.c
        $(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/boopoaat/boopoaat.c

$(BIN_DIR)/boopoaat.arf:        $(BIN_DIR)/generic.arf
        $(QUIET)$(SED) 's/$(REPLACE_TAG)/boopoaat/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/boopoaat.arf
```
```
CCC == c compiler: /Users/bart/bin/sdcc/bin/sdcc
CCC_FLAGS == "-c -mz80 -D__SDCC__=1
CLD == sdld Linker: /Users/bart/bin/sdcc/bin/sdldz80
CLD_FLAGS == (blank)
load == takes a .ihx and assembles it into a .com  (why?  Can't sdcc do this, or is it too CP/M-specific?)
SRC_DIR = src/  (also SYSLIB_... = src/syslib; CPM_... = src/cpm; HWLIB_... = src/hw)
INCLUDE_DIR = "-Isrc/include -Isrc"
```


