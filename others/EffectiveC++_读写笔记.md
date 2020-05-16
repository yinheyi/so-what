
[TOC]

# **定制new和delete**

## **第49条：了解new_handler的行为**

### 什么是new_handler?

1. new_handler是一个函数指针类型，定义在<new>头文件中，它为函数std::set_new_handler()与std::get_new_handler()所使用. 原型定义如下所示:
````c++
typedef void (*new_handler)()
````
使用new_handler定义了一个全局new的处理函数指针对象，例如 `new_handler g_new_handle_func = nullptr`. 设计该函数的作用是:当new操作符进行内存分配失败时会调用该函数, 希望它可以做下面三件事之一:
- 该函数可以通过某些操作，获取更多可用的内存，从而使下一次new操作可能成功。
- 该函数可以选择终止程序， 因为内存不够使用了，再执行下去可能没有意义了。
- 该函数可以选择抛出 std::bad_alloc 的异常。
2. std::set_new_handler()函数定义在<new>头文件中, 它的作用是设置新的全局new的处理函数并返回先前安装的new处理函数。
3. std::get_new_handler()函数定义在<new>头文件中，它的作用是返回当前安装的new的处理函数，它有可能返回空指针的，表示没有处理函数。

### new_handler的处理过程

1. 当new操作符申请内存时，如果发现没有足够多的内存可以使用时，它会去检查new_handler处理函数是否为nullptr, 如果为空，则抛出异常;当不为空时，它会调用该处理函数。
2. 如果new处理函数抛出异常或终止程序时，程序就会终止掉了。
3. 如果new处理函数正常返回(例如它可以尝试通过一系列的努力从其它地方找出来一些内存),new操作符就会又继续重复一开始的内存申请操作了。

**特别说明:**如果你自定义的new处理函数没有做上面说的三件事之一，当内存不足时，你的代码就会进行死循环了. 

不合理的new处理函数说明：
````c++
#include <iostream>
#include <new>
using namespace std;

void my_new_handle()
{
    cout << "现在死循环中...\n" << endl;
}

int main()
{
    new_handler old_handle = set_new_handler(my_new_handle);
    unsigned int size = 1 << 31;
    long *p = new long[size];
    return 0;
}
````

## **第51条：为什么有时需要替换c++原有的new与delete操作符呢？**

1. 通过重载new/delete操作符可以用于检测一些关于内存操作的错误信息，例如可以实现内存泄漏的小工具。
2. 可以加强专属的new/delete的性能。标准库提供的new/delete具体通用性，对于某些场景可以定义自己的new/delete运算符。

## **第51条：重载new与delete运行符时的注意事项**

1. operator new内应该含有一个无穷循环，在循环内进行内存分配，如果内存不足时就应该调用new_handler处理函数。
2. c++规定安申请0字符的内存时也应该返回一个合法的指针，因此operator new操作符应该处理这种情况。
3. 重载operator delete操作符时，记住一点：c++保证**删除NULL指针永远是安全的**。 所以你要处理这种特殊情况。

## **第52条：placement new 与 palcement delete版本**

如果operator new 接受的参数除了一定会有的size_t之外，还有其它的参数，则认为这就是所谓的 placement new. 通常使用的placement new 是一个接受一个指针指向对象该被构造之处,表示从指针所指的地方进行内存申请。 这样版本的new已经纳入了c++标准程序库里了，它的格式如下所示：
````c++
void* operator new(std::size_t, void* pMemory) throw();
````
当然，也可以定义其它形式的placement new, 例如下面所示:
````c++
void* operator new(std::size_t size, const string& info) {
    cout << info;
    return ::operator new(size);
}
````

我们知道，当我们写一个new表达式时，共有两个函数被调用：一个是用于内存分配的operator new, 另一个是对象的构造函数。如果在第一步，内存申请成功了，然后在执行对象的构造函数时被抛出了异常，如果不处理申请到的内存就会造成内存泄漏问题。 编译器会这么做：它会查找到与oeprator new函数的参数相同的oeprator delete的函数，然后调用该operator delete进行内存的释放,如果没有找到对应的函数编译器什么也不做。 因此，如果你想自定义placement new函数的话，你也需要定义一个对应的placement delete函数，该函数**只会在new一个对象时如果内存申请成功但是构造失败的时候调用**，用于防止内存泄漏， 正常情况下是不会被调用的。举例说明：
````c++
#include <iostream>
#include <new>
#include <exception>

using namespace std;

void* operator new(std::size_t size, int)
{
    std::cout << "placement new is called. " << std::endl;
    return ::operator new(size);
}

void operator delete (void* ptr)
{
    std::cout << "regular operator delete is called." << std::endl;
}

void operator delete(void* ptr, int)
{
    std::cout << "placement delete is called. " << std::endl;
}

class Obj {
public:
    Obj() { throw std::bad_alloc(); };
};


class NoThrowObj {
public:
    NoThrowObj() {};
};

int main()
{
    try {
        // 在new Obj时，它的构造函数抛出异常，并且会调用placement delete 进行内存的释放。
        Obj* p = new (100) Obj;
    } catch (...) {
        std::cout << "已经捕获。" << std::endl;
    }

    // 在进行delete时，常规的operator delte 被调用。
    NoThrowObj* p = new (1000) NoThrowObj;
    delete p;

    return 0;
}
````

输出为：
````bash
placement new is called. 
placement delete is called. 
已经捕获。
placement new is called. 
regular operator delete is called.
````

# **在此添加**
