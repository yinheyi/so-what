# ELF文件类型

> author: 殷和义
> start time: 2020-10-08
> last time: 2020-10-08

----

[TOC]

----

## 一. ELF文件

### 1. ELF文件种类

ELF文件标准里面把系统中采用ELF格式的文件分为4类,如下所示. 使用linux下的`file`命令可以查看一个文件的类型.

- 可执行文件
- 可重定位文件: 包含了代码和数据的 .o文件, 静态链接库也归为它.
- 共享目标文件: 包含了代码和数据, 可能被动态链接的.so文件.
- 核心转储文件: 当进程意外终止时,系统可以将该进程的地址空间的内容及终止的一些其它信息保存为该文件类型.

### 2. 文件内部组成

总体来说,程序源代码被编译之后主要分成两种段,程序指令和程序数据. 另外还有一些其它的必要信息,用于对程序指令与程序数据进行处理或程序在内存加载之类的. 
- **ELF头**

ELF头(或者说文件头)描述了整个文件的的基本信息, 它位于文件的最开始部分, 大小一般为64个字节. 里面包含ELF文件类型,目标机器型号, 程序入口等. 使用命令 `readelf -h 文件名`可以查看ELF头.

可重定位文件的文件头信息如下所示:

````
yin@yin-Aspire-V5-471G:~/test$ readelf -h main.o
ELF 头：
  Magic：   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  类别:                              ELF64
  数据:                              2 补码，小端序 (little endian)
  版本:                              1 (current)
  OS/ABI:                            UNIX - System V
  ABI 版本:                          0
  类型:                              REL (可重定位文件)
  系统架构:                          Advanced Micro Devices X86-64
  版本:                              0x1
  入口点地址：               0x0
  程序头起点：          0 (bytes into file)
  Start of section headers:          960 (bytes into file)
  标志：             0x0
  本头的大小：       64 (字节)
  程序头大小：       0 (字节)
  Number of program headers:         0
  节头大小：         64 (字节)
  节头数量：         12
  字符串表索引节头： 11
````

可执行文件的文件头信息如下所示:

````
yin@yin-Aspire-V5-471G:~/test$ readelf -h a.out 
ELF 头：
  Magic：   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  类别:                              ELF64
  数据:                              2 补码，小端序 (little endian)
  版本:                              1 (current)
  OS/ABI:                            UNIX - System V
  ABI 版本:                          0
  类型:                              DYN (共享目标文件)
  系统架构:                          Advanced Micro Devices X86-64
  版本:                              0x1
  入口点地址：               0x4f0
  程序头起点：          64 (bytes into file)
  Start of section headers:          6680 (bytes into file)
  标志：             0x0
  本头的大小：       64 (字节)
  程序头大小：       56 (字节)
  Number of program headers:         9
  节头大小：         64 (字节)
  节头数量：         28
  字符串表索引节头： 27
````

ELF文件头结构信息的数据结构定义在`/usr/include/elf.h`文件中, 例如64位版本的如下:

````
#define EI_NIDENT (16)
typedef struct
{
  unsigned char	e_ident[EI_NIDENT];	/* Magic number and other info */
  Elf64_Half	e_type;			/* Object file type */
  Elf64_Half	e_machine;		/* Architecture */
  Elf64_Word	e_version;		/* Object file version */
  Elf64_Addr	e_entry;		/* Entry point virtual address */
  Elf64_Off	e_phoff;		/* Program header table file offset */
  Elf64_Off	e_shoff;		/* Section header table file offset */
  Elf64_Word	e_flags;		/* Processor-specific flags */
  Elf64_Half	e_ehsize;		/* ELF header size in bytes */
  Elf64_Half	e_phentsize;		/* Program header table entry size */
  Elf64_Half	e_phnum;		/* Program header table entry count */
  Elf64_Half	e_shentsize;		/* Section header table entry size */
  Elf64_Half	e_shnum;		/* Section header table entry count */
  Elf64_Half	e_shstrndx;		/* Section header string table index */
} Elf64_Ehdr;

````

- **程序头表**


- **节头部表**

section header table, 它保存了文件中所有节的信息, 包含下面要讲到的.data/.text/.bss/.dynamic等. 节头部表就是一个数组,第一个元素都是一个描述节信息的数据结构, 使用`objdump -h`或 `readelf -S`命令可以查看到. 节头部表位于文件的后半部分, 在所有section的后面, 为什么放到后面呢, 我也不知道啊. 在ELF文件头信息中给出来节节头部表在文件中的偏移位置(Start of section headers)

使用**objdump**工具显示的重定位文件中的节头部表的信息:

````bash
yin@yin-Aspire-V5-471G:~/test$ objdump -h main.o 

main.o：     文件格式 elf64-x86-64

节：
Idx Name          Size      VMA               LMA               File off  Algn
  0 .text         0000000b  0000000000000000  0000000000000000  00000040  2^0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         0000000c  0000000000000000  0000000000000000  0000004c  2^2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000014  0000000000000000  0000000000000000  00000058  2^2
                  ALLOC
  3 .rodata       0000000c  0000000000000000  0000000000000000  00000058  2^2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 .comment      0000002a  0000000000000000  0000000000000000  00000064  2^0
                  CONTENTS, READONLY
  5 .note.GNU-stack 00000000  0000000000000000  0000000000000000  0000008e  2^0
                  CONTENTS, READONLY
  6 .eh_frame     00000038  0000000000000000  0000000000000000  00000090  2^3

````

使用**readelf**工具显示的重定位文件中的节头部表信息如下所示,好像更全一点吧.

````bash
yin@yin-Aspire-V5-471G:~/test$ readelf -S main.o 
There are 12 section headers, starting at offset 0x3c0:

节头：
  [号] 名称              类型             地址              偏移量
       大小              全体大小          旗标   链接   信息   对齐
  [ 0]                   NULL             0000000000000000  00000000
       0000000000000000  0000000000000000           0     0     0
  [ 1] .text             PROGBITS         0000000000000000  00000040
       000000000000000b  0000000000000000  AX       0     0     1
  [ 2] .data             PROGBITS         0000000000000000  0000004c
       000000000000000c  0000000000000000  WA       0     0     4
  [ 3] .bss              NOBITS           0000000000000000  00000058
       0000000000000014  0000000000000000  WA       0     0     4
  [ 4] .rodata           PROGBITS         0000000000000000  00000058
       000000000000000c  0000000000000000   A       0     0     4
  [ 5] .comment          PROGBITS         0000000000000000  00000064
       000000000000002a  0000000000000001  MS       0     0     1
  [ 6] .note.GNU-stack   PROGBITS         0000000000000000  0000008e
       0000000000000000  0000000000000000           0     0     1
  [ 7] .eh_frame         PROGBITS         0000000000000000  00000090
       0000000000000038  0000000000000000   A       0     0     8
  [ 8] .rela.eh_frame    RELA             0000000000000000  00000348
       0000000000000018  0000000000000018   I       9     7     8
  [ 9] .symtab           SYMTAB           0000000000000000  000000c8
       0000000000000210  0000000000000018          10    17     8
  [10] .strtab           STRTAB           0000000000000000  000002d8
       000000000000006c  0000000000000000           0     0     1
  [11] .shstrtab         STRTAB           0000000000000000  00000360
       000000000000005c  0000000000000000           0     0     1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  l (large), p (processor specific)
````

- **.data节**

该节就是用来保存可变数据的, 包含: **全局变量**, **全局静态变量**, **局部静态变量**.

- **.rodata节**

该节是用来保存只读数据的,包含: **只读的全局变量**, **只读的全局静态变量**, **只读的局部静态变量**.

- **.text节**

该节保存的是就是程序指令.

- **.bss节**

在链接后的可执行文件中, 该节保存: **未初始化的全局变量**, **初始化为0的全局变量**, **未初始化的全局静态变量**, **初始化为0的全局静态变量**, **未初始化的局部静态变量**, **初始化为0的局部静态变量**. 总之吧, 只要它的初始值为0, 都保存在该节内. 无论全局变量还是静态变量,你不初始化它,它们默认就是0值.

在可重定位文件中, 与可执行文件中有一处不同: **未初始化的全局变量**保存在.common节中. 原因是这样的: 未初始化的全局变量是弱符号, 链接器允许多个同名的弱符号存在, 并且链接的时候决定使用哪一个弱符号. 而在编译阶段,编译器在编译成可重写位文件时, 不能确定未初始化的全局变量是否会在链接成可执行文件时使用, 因为可能其它可重位文件中也存在同名的弱符号,所以呢, 就把所有未初始化的全局变量都放到.common节中,让链接器决定使用哪一个弱符号. 当链接器确定了之后, 链接成可执行文件时,未初始化的全局变量又最终还是放到了.bss节中.

未初始化的全局静态变量, 因为它们的作用域只在当前文件内, 所以不可能用其它文件的未初始化的全局静态变量冲突, 所以它们保存在.bss节就可以了.

.bss节在文件中不占空间,真的是不占一点点的内存空间, 关于它的信息保存在 **节头部表**中. 当被加载到内存中时,操作系统会为它分配一块内存, 并且分配这块内存初始化为0值. 它的这种特性也就决定了它保存的变量的类型.

为什么叫bss呢, 引用自<<程序员的自我修养>>一书的说明.
> bss, block started by symbol, 这个词最初是UA-SAP汇编器的一个伪指令, 用于为符号预留一块内存空间. 后来BSS这个词被作为关键字引入一了FAP汇编器中,用于定义符号并且为该符号预留给定数量的未初始化空间.

- **.retext节**


## 二. 可重定位文件


## 三. 共享目标文件


## 四. 可执行文件


