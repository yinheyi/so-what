## 笑谈c++智能指针

c++的一切都是类或模板类, 万变不离其宗. 智能指针也是类,模板类. 不同的智能指针,就对应了不同的类实现了, 但是它们都利用了类对象有释放的时候会调用析构函数的原理. C++有以下几种智能指针:

- auto_ptr<T> : c++11之后就弃用了.
- unique_ptr<T> : 它代替了auto_ptr的位置.
- shared_ptr<T> : 它是不错, 但是用多了它,用效率问题的.
- weak_ptr<T> : 弱指针, 与shared_ptr配套使用, 它不会增加shared_ptr的引用计数.

### auto_ptr<T>

在c++11之后,它被弃用了,原因就是因为当把一个auto_ptr对象赋值给另一个变量时, 原有的对象的指针就为空了. 我们很容易实现它:
1. 在析构函数中释放它管理的指针.
2. 重载一个赋值运算符,处理一个赋值操作.

### unique_ptr<T>

unique_ptr与auto_ptr基本相似,有一点不一样: unique_ptr很聪明,它**不允许拷贝构造也不允许赋值操作**,**只允许移动构造和移动赋值操作**. 所以实现它也很容易:
1. 把拷贝构造函数与赋值操作符定义为deleted, 定义移动构造函数与移动赋值操作符.
2. ......(很常规的其它实现了)

其它:
- 构造该对象时,优先使用make_unique_ptr<T>函数(c++14引用的), 异常安全.
- 初始化时,可以指定删除器.

### shared_ptr<T>

它允许多个shared_ptr<T>对象共享一块内存, 与前两者有所不同. 本质是就是维护一个内存块的引用计数,引用计数什么时候变为0了,什么时候释放内存. 有几个注意点:

1. 它的实现效率不如unique_ptr<T>, 所以呢, 在使用权很明确时优先使用unique_ptr<T>.
2. 使用时避免循环引用的情况.

其它:
- 构造该对象时,优先使用make_shared_ptr<T>函数(c++11引用的), 异常安全.
- 初始化时,可以指定删除器.

### weak_ptr<T>

它依附于share_ptr<T>而活着, 请使用share_ptr<T>或weak_ptr<T>对象对它进行初始化. 生成一个weak_ptr对象不会增加share_ptr对象内的引用计数,所以是weak. 使用它时,一定要判断一下它指向的shared_ptr对象是否还存在(使用lock成员函数),然后再使用.


----

最后, 使用智能指针时,有一些坑,这里不想写了. 反正你明白了智能指针的本质,这些坑你就足踩不中了.
