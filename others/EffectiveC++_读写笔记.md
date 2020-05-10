# **定制new和delete**

## **第49条：了解new_handler的行为**
- ### 什么是new_handler??
1. new_handler是一个函数指针类型，定义在<new>头文件中，它为函数std::set_new_handler()与std::get_new_handler()所使用. 原型定义如下所示:
    ````c++
    typedef void (*new_handler)()
    ````

2. 使用new_handler定义了一个全局new的处理函数指针对象，例如 `new_handler g_new_handle_func = nullptr`. 设计该函数的作用是:当new操作符进行内存分配失败时会调用该函数, 希望它可以做下面三件事之一:
    >  sdf;
     sadfds;
     sadfsa;
     asdfds;
    sdfds

3. std::set_new_handler()函数定义在<new>头文件中, 它的作用是设置新的全局new的处理函数并返回先前安装的new处理函数。

sadfdsads

> safdsfds
> safdsfsd
> sadfds

## **第50条：为什么有时需要替换c++原有的new与delete操作符呢？**

## **重载new与delete运行符时的注意事项**


