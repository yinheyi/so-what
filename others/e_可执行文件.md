# ELF文件类型

> author: 殷和义  
> start time: 2020-10-08  
> last time: 2020-10-12  

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
````bash
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
````c
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

程序头表存在于可执行文件中, 位于ELF文件头后面, 在程序加载的时候会使用到程序头表. 对于ELF文件,可以从**链接角度**和**加载角度**两方面来看, 对应了链接视图与加载视图. 加载视图关心的是程序头表, 链接视图关心节头部表. 在链接生成可执行文件时, 会把多个节(section)合并对应一个段(segment). 所以节头部表中的数目少于程序头表的数目的. 引入程序头的原因是这样的: 方便程序的加载, 你想想啊,多个节可能具有相同的读写属性, 把相同属性的节合并成一个段,一次性加载入内存中, 并且节约内存,方便管理(从虚拟内存的分页机制与对齐方面考虑).

对于可重定位文件, 读取它的程序头表时, 显示不存在的.
````bash
yin@yin-Aspire-V5-471G:~/test$ readelf -l main.o

本文件中没有程序头。
````

对于可执行文件, 读取它的程序头表时,是这样的, 并且还输出了不同的section 到对应segment的映射关系.
````
yin@yin-Aspire-V5-471G:~/test$ readelf -l -W a.out 

Elf 文件类型为 DYN (共享目标文件)
Entry point 0x4f0
There are 9 program headers, starting at offset 64

程序头：
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  PHDR           0x000040 0x0000000000000040 0x0000000000000040 0x0001f8 0x0001f8 R   0x8
  INTERP         0x000238 0x0000000000000238 0x0000000000000238 0x00001c 0x00001c R   0x1
      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
  LOAD           0x000000 0x0000000000000000 0x0000000000000000 0x0007d8 0x0007d8 R E 0x200000
  LOAD           0x000df0 0x0000000000200df0 0x0000000000200df0 0x00022c 0x000248 RW  0x200000
  DYNAMIC        0x000e00 0x0000000000200e00 0x0000000000200e00 0x0001c0 0x0001c0 RW  0x8
  NOTE           0x000254 0x0000000000000254 0x0000000000000254 0x000044 0x000044 R   0x4
  GNU_EH_FRAME   0x000694 0x0000000000000694 0x0000000000000694 0x00003c 0x00003c R   0x4
  GNU_STACK      0x000000 0x0000000000000000 0x0000000000000000 0x000000 0x000000 RW  0x10
  GNU_RELRO      0x000df0 0x0000000000200df0 0x0000000000200df0 0x000210 0x000210 R   0x1

 Section to Segment mapping:
  段节...
   00     
   01     .interp 
   02     .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .init .plt .plt.got .text .fini .rodata .eh_frame_hdr .eh_frame 
   03     .init_array .fini_array .dynamic .got .data .bss 
   04     .dynamic 
   05     .note.ABI-tag .note.gnu.build-id 
   06     .eh_frame_hdr 
   07     
   08     .init_array .fini_array .dynamic .got 
````

- **节头部表**

section header table, 它保存了文件中所有节的信息, 包含下面要讲到的.data/.text/.bss/.dynamic等. 节头部表就是一个数组,第一个元素都是一个描述节信息的数据结构, 使用`objdump -h`或 `readelf -S`命令可以查看到. 节头部表位于文件的后半部分, 在所有section的后面, 为什么放到后面呢, 我也不知道啊. 在ELF文件头信息中给出来节节头部表在文件中的偏移位置(Start of section headers)

节头部表很有用的!!!!链接的时候要使用到它,在可可重定位文件中, 信息都是按节保存的.

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

该节保存的是就是程序指令.  使用`objdump -d`命令可以反汇编代码信息. 例如:

````
yin@yin-Aspire-V5-471G:~/test$ size main.o
   text	   data	    bss	    dec	    hex	filename
     79	     12	     20	    111	     6f	main.o
yin@yin-Aspire-V5-471G:~/test$ size a.out 
   text	   data	    bss	    dec	    hex	filename
   1415	    556	     28	   1999	    7cf	a.out
````

使用 `size`命令可以查看ELF文件的代码段/数据段/BSS段的长度.

- **.bss节**

在链接后的可执行文件中, 该节保存: **未初始化的全局变量**, **初始化为0的全局变量**, **未初始化的全局静态变量**, **初始化为0的全局静态变量**, **未初始化的局部静态变量**, **初始化为0的局部静态变量**. 总之吧, 只要它的初始值为0, 都保存在该节内. 无论全局变量还是静态变量,你不初始化它,它们默认就是0值.

在可重定位文件中, 与可执行文件中有一处不同: **未初始化的全局变量**保存在.common节中. 原因是这样的: 未初始化的全局变量是弱符号, 链接器允许多个同名的弱符号存在, 并且链接的时候决定使用哪一个弱符号. 而在编译阶段,编译器在编译成可重写位文件时, 不能确定未初始化的全局变量是否会在链接成可执行文件时使用, 因为可能其它可重位文件中也存在同名的弱符号,所以呢, 就把所有未初始化的全局变量都放到.common节中,让链接器决定使用哪一个弱符号. 当链接器确定了之后, 链接成可执行文件时,未初始化的全局变量又最终还是放到了.bss节中.

未初始化的全局静态变量, 因为它们的作用域只在当前文件内, 所以不可能用其它文件的未初始化的全局静态变量冲突, 所以它们保存在.bss节就可以了.

.bss节在文件中不占空间,真的是不占一点点的内存空间, 关于它的信息保存在 **节头部表**中. 当被加载到内存中时,操作系统会为它分配一块内存, 并且分配这块内存初始化为0值. 它的这种特性也就决定了它保存的变量的类型.

为什么叫bss呢, 引用自<<程序员的自我修养>>一书的说明.
> bss, block started by symbol, 这个词最初是UA-SAP汇编器的一个伪指令, 用于为符号预留一块内存空间. 后来BSS这个词被作为关键字引入一了FAP汇编器中,用于定义符号并且为该符号预留给定数量的未初始化空间.

- **.rel.text  和 .rel.data**

重定位表, 保存对目标文件的重定位信息, 也就是对代码段和数据段的绝对地址引用的位置描述. 在进行重定位时, 链接器会读取定位表来决定对给定符号在什么哪里进行重定位.

- **.symtab节**

符号表中保存了本文件中定义的所有符号信息, 符号是链接的接口. 在一个文件中即可能定义了一些符号,也可能引用了其它文件的符号, 它们的信息都会保存到符号表中. 函数是符号,变量名是符号. 

**全局符号:** 包含非静态函数, 全局变星, 对于链接过程,它只关心全局符号, 全局符号是对文件外可见的,它们会被重定位.
**局部符号:**, 包含静态函数, 全局静态变量, 局部静态变量, 这类符号只在文件内部可见. 我就想局部符号有什么用处呢??查了资料这么说: 调试器可以使用这些局部符号来分析程序或崩溃时的核心转储文件, 这些符号对链接过程没有作用, 链接器会忽略它们.

**extern c 关键字**
C++为了与C兼容, 在符号管理上,为了不按照C++的符号签名的方式对符号进行扩展(C++的名称修饰机制), C++编译器会将在"extern C"的大括号内的代码当作C语言来处理.

**强符号与弱符号**
强符号与弱符号的概念一般都是对全局符号才有用, 因为全局符号是对文件外可见的, 多个文件之间相同的符号名有可能冲突. 局部符号对文件外不可见, 只在文件内部可见, 链接的时候不可能冲突, 万一局部符号定义重复了,编译的时候就会报错了.
对于C/C++语言来说,编译器默认函数名与初始化的全局变量为强符号, 未初始化的全局变量是弱符号. 也可以通过GCC的 "__attribute__((weak))"来定义弱符号. 链接器按以下规则处理全局符号:
    1. 不允许强符号被以多次定义.
    2. 如果一个符号在某个目标文件中是强符号, 在其它文件中是弱符号,那么链接器选择弱符号.
    3. 如果一个弱号在所有目标文件中都是弱符号,选择其中占用空间最大的那个符号.

**强引用与弱引用**
强引用: 当没有在其它文件中找到对应符号的定义时,链接器报符号未定义的错误.
弱引用: 在处理弱引用时, 如果该符号未定义, 链接器不会对该引用报错,而是默认值为0. 在GCC中, 通过" __atrribute__((weakref))"扩展关键字来声明对一个符号的弱引用.

- **.strtab节**

字符串表, 保存ELF文件中所有的字符串. 是这样的: ELF文件中用到了很多字符串, 比如段名/变量名/字符串变量等. 因为字符串的长度往往不定,怎么保存呢? 一种常见的做法是把字符串集中起来存放到一个表中, 然后使用字符串在表中的偏移来引用字符串.

## 二. 静态链接

静态链接的过程相对简单, 也就大概说一下过程啊. 链接过程是指由可重定位文件链接生成可执行文件. 在可重定位文件中,程序的地址都是从0x0000开始的, 生成可执行文件时, 程序的地址对应了程序加载时的真实虚拟地址,在linux下是从0x400000的之后的某个位置开始的, 静态链接过程大致包含两个大的过程:空间与地址分配, 符号解析与重定位.

### 1. 空间与地址分配

一句话,链接静态器把所有的可重定位文件的内容合成到一个文件内, 采用的策略就是相似的section 合并. 合并之后,为程序代码段与数据段分配虚拟地址空间. 虚拟地址空间分配之后, 所有的全局符号的绝对地址信息也就确定了, 为接下来的符号解析与重定位作好了准备.

### 2. 符号解析与重定位

在一个文件中可能定义了一个全局符号,也可能引用了其它文件定义的全局符号. 符号解析过程就是找到引用的外部符号的在哪里, 去哪里查找呢? 那就要用的之前说过了符号表了, 所有符号的信息都在符号表里保存着. OK, 找到符号之后,也就能知道该符号对应的虚拟地址空间了. 接下来就进行重定位了.

问题来了,我怎么知道对哪个位置进行重定位呢?  这就用于了之前说的重定位表了, 该表里保存了所有的需要进行重定位的信息. 知道了重定位的位置,也知道了重定位到的引用符号所有的虚拟地址空间, 这个工作就可以搞定了.

真实情况是符号解析过程是伴随着重定位过程进行的, 在重定位过程中,需要使用到哪一个符号,才对那个符号进行解析.

重定位的方式有两种: 绝对地址寻址和相对地址寻址. 反正吧, 关于如何重定位的所有信息都在重定位表中保存着呢, 都可以搞定,不是问题.细节先不写了. 没有大多必要细说吧,了解就OK了, 咱们很少人会写链接器的.

**COMMON块**: 之前说过在可重定位文件中,全局未初始化的变量作为弱符号处理, 保存在COMMON块中. 因为可能多个相同弱符号的存在, 编译器并不能确定该弱符号最终占的空间大小,也就没有办法在BSS段中分配空间. 但是链接器在链接过程中可以确定符号的大小(因为它拿到了所有同名的弱符号,它决定了要使用哪一个弱符号),所以链接器在生成可执行文件时又把弱符号放到了BSS段中,为它分配空间.

### 3. 静态库及链接过程

使用`gcc -c`命令可以生成重定位文件, 然后进行静态链接过程, 例如:
````bash
yin@yin-Aspire-V5-471G:~/test$ gcc -c main.c  -o relo.o
yin@yin-Aspire-V5-471G:~/test$ gcc relo.o -o a.out
yin@yin-Aspire-V5-471G:~/test$ ls
a.out  main.c  relo.o
````

静态库就是把多个可重定位文件打包放一起了, 使用ar压缩工具把目标文件压缩在一起,生成静态库, 通常以.a后缀结尾. 举个例子哈, 生成一个新的静态库libnew:
````bash
yin@yin-Aspire-V5-471G:~/test$ cat a.c
int add(int a, int b)
{
    return a + b;
}
yin@yin-Aspire-V5-471G:~/test$ cat b.c
int sub(int a, int b)
{
    return a - b;
}
yin@yin-Aspire-V5-471G:~/test$ gcc -c a.c b.c
yin@yin-Aspire-V5-471G:~/test$ ar -qs libnew.a a.o b.o
yin@yin-Aspire-V5-471G:~/test$ ls
a.c  a.o  b.c  b.o  libnew.a
````

使用`ar -t`命令可以显示给定的静态库包含了哪些目标文件:
````
yin@yin-Aspire-V5-471G:~/test$ ar -t libnew.a 
a.o
b.o
````
具体链接器如何使用静态库来解析引用的, 参考一下<<深入理解计算机系统>>一书, 不想写了,没有啥意思.

**其它**
对于C++代码, 链接器还会做: 
    1. 重复代码的消除工作, 因为内联函数/虚函数表/模板等机制都有可能导致在不同的编译单元中生成相同的代码. 消除的方法之一是把它们放到一个对应特性名称的单独段中, 链接器进行过滤.  
    2. 全局构造与析构. 在linux下,一般程序的入口为start, 这个函数是glibc的一部分, 它会完成一系列的初始化过程,然后调用main函数, main函数执行完成之后,对回到初始的部分,做一些清理工作. c++的全局对象的构造与构造函数是典型的例子. 在ELF文件中是这样实现的, 它定义了两个特殊的段: **.init**和**.fini**段.里面保存了main函数执行前与执行后的相关代码信息.

## 三. 动态链接


