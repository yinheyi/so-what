# 整数溢出问题

## 一    提两个简单问题：

下面代码在64位系统下运行，short 类型占两个字节,int类型占4个字节，long类型占8个字节, 猜猜问题1与问题2的结果：
- 问题1:以下两个代码的输出结果相同吗
    - 代码一：
    ````c
    int main()
    {
        short a = 0x7fff;
        short b = a + 1;
        int c = b;
        printf("代码一的输出结果为：%d\n", c);
        return 0;
    }
    ````
    - 代码二：
    ````c
    int main()
    {
        short a = 0x7fff;
        int c = a + 1;
        printf("代码二的输出结果为：%d\n", c);
        return 0;
    }
    ````
- 问题2：以下的代码输出结果又是否相同？
    - 代码三：
    ````c
    int main()
    {
        int a = 0x7fffffff;
        int b = a + 1;
        long c = b;
        printf("代码三的输出结果为：%ld\n", c);
    }
    ````
    - 代码四：
    ````c
    int main()
    {
        int a = 0x7fffffff;
        long c = a + 1;
        printf("代码四的输出结果为：%ld\n", c);
    }
    ````

## 二    猜对答案了没？

1. 问题1内的代码一与代码二的输出结果不同，代码一在执行`short b = a + 1`语句时发生了short整型溢出问题, 代码二是安全的。它们的执行结果分别如下：
    - 代码一的输出结果：
    ````shell
    代码一的输出结果为：-32768
    ````
    - 代码二的输出结果:
    ````shell
    代码二的输出结果为：32768
    ````
2. 问题2内的代码三与代码四分别在执行`int b = a + 1`和`long c = a + 1`时都发生了整数溢出问题，它们的执行结果是相同的：
    - 代码三的输出结果：
    ````shell
    代码三的输出结果为：-2147483648
    ````
    - 代码四的输出结果:
    ````shell
    代码四的输出结果为：-2147483648
    ````
##三    原因分析：
- 代码一分析：
在代码一内，执行`short b = a + 1`时发生溢出应该是很容易理解，short最大表示的正整数为0x7fff,加一之后变为了0x8000, 即能表示的最大负整数-32768, 再转换为int类型时，符号位是要保留的，可以还是-32768, 看看它的汇编代码更容易理解:
    ````assembly
    subq    $16, %rsp
    movw    $32767, -12(%rbp)
    // 该指令操作之后，eax寄存器的高16位为0补上(movzwl中的z就表示zero)，低16的ax的值为32767.
    movzwl  -12(%rbp), %eax
    addl    $1, %eax
    // 关键: 这里只把ax的值(即相加之后的32768,0x8000)保存到了内存中。
    movw    %ax, -10(%rbp)
    // 下面是在执行short类型到int类型的转换，其中eax中的高16的值是使用符号位进行填充(movswl的s对应sign)，0x8000符号位为1.
    movswl  -10(%rbp), %eax
    movl    %eax, -8(%rbp)
    ````
- 代码二分析：
在代码二内，当执行`int c = a + 1`时没有发生short类型的溢出问题, 原因还得从汇编代码层次查找到：
    ````assembly
	subq	$16, %rsp
	movw	$32767, -6(%rbp)
	movswl	-6(%rbp), %eax      // 以符号位填充高16位的数式复制到eax寄存器
	addl	$1, %eax
	movl	%eax, -4(%rbp)
    ````
- 代码三分析：
在代码三中，当执行'int b = a + 1`时发生了int整数的溢出，它对应的汇编代码如下所示：
    ````assembly
	subq	$16, %rsp
	movl	$32767, -16(%rbp)
	movl	-16(%rbp), %eax     // 下面三个代码使用eax寄存器执行了加1操作
	addl	$1, %eax
	movl	%eax, -12(%rbp)
	movl	-12(%rbp), %eax
	cltq                        // 下面两行，使用rax寄存器执行了类型转换操作,
	movq	%rax, -8(%rbp)      // cltq执行符号位扩展，把eax扩展为rax,高32使用32位填充。
    ````
- 代码四分析：
在代码四中，当执行'long c = a + 1`时也发生了int整数的溢出，奇怪吧。来看看它对应的汇编代码:
    ````assembly
	subq	$16, %rsp
	movl	$32767, -12(%rbp)
	movl	-12(%rbp), %eax
	addl	$1, %eax            // 执行相加过程也是使用eax寄存器，因此就溢出了。
	cltq
	movq	%rax, -8(%rbp)
    ````

## 四    如何解决整数溢出问题?
**在对操作数执行运算之前，先进行类型转换，而不是执行了运算之后再执行类型转换**
例如针对代码四的整数溢出问题，代码修改如下：
````c
int main()
{
    int a = 0x7fffffff;
    long c = (long)a + 1;
    printf("代码四的输出结果为：%ld\n", c);
}
````
代码修改之后，它对应的汇编代码如下：
````assembly
subq	$16, %rsp
movl	$32767, -12(%rbp)
movl	-12(%rbp), %eax
cltq
addq	$1, %rax
movq	%rax, -8(%rbp)
````
从汇编代码就可以看出来，它不会发生整数溢出了！！
