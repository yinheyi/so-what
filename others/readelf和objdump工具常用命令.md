## file 工具

file 工具可以显示给定文件的类型, 常用的命令记住一个就可以: `file 文件名`, 例如:

````
yin@yin-Aspire-V5-471G:~/test$ file a.out 
a.out: ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 3.2.0, BuildID[sha1]=224ceb289ef6f22bca10f0d215d832ed6ccd2b17, not stripped
yin@yin-Aspire-V5-471G:~/test$ file main.c
main.c: C source, ASCII text
yin@yin-Aspire-V5-471G:~/test$ file main.o
main.o: ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
````

## readelf 工具



## objdump 工具

|命令|功能|
|:---:|:---|
|objdump -s|将所有段的内容以十六进制的方式打印出来.|
|objdummp -d| 将包含指令的段进行反汇编,显示出来|
|objdummp -h| 显示文件中包含的节头部表信息,也就是显示出所有的节信息|

## size 工具

使用size命令可以查看ELF文件中的代码段/数据段/BSS段的长度. 例如:

````bash
#以面dec和hex表示十进制与十六进制的长度总和.

yin@yin-Aspire-V5-471G:~/test$ size main.o
   text	   data	    bss	    dec	    hex	filename
     79	     12	     20	    111	     6f	main.o
yin@yin-Aspire-V5-471G:~/test$ size a.out 
   text	   data	    bss	    dec	    hex	filename
   1415	    556	     28	   1999	    7cf	a.out

````
