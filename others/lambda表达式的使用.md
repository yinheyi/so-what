从c++11开始，可以使用lambda表达式，介绍一下使用方法以及事项, 你可以把它当作一个无名重载了operator()运算符的类对象。

## 目录

[TOC]

## 知识背景

### 尾置返回类型
C++11标准中，引入定义函数时的一种新的方法，使用**尾置返回类型**.这种形式对于返回类型比较复杂的情况很有效。
通常情况下，我们定义或声明一个函数时，是这样的：
````c++
int add(int a, int b);
````

尾置返回类型的定义是这样的：
````
auto add(int a, int b) -> int;
````

当我们定义一个返回指向10个元素的int数组指针的函数时，按正常形式是这样的：
````c++
int (*func())[10];
````

当我们使用尾置返回类型时，它是这样的：
````c++
auto func() -> int(*)[10];
````

## lambda表达式

### 定义格式
lambda采用尾置返回类型，它完整的const声明形式为:  `[] (参数列表) -> 返回值类型 {函数体} `, const是指在捕获列表内通过值捕获的参数在lambda内部是不可以改变的。
````c++
int func(vector<int> array)
{
    auto func = [](int a, int b) ->bool { return a < b;}
    std::sort(array.begin(), array.end(), func);
}

void sample ()
{
    int a = 10;
    auto func1 = [a] () {++a;};             // 编译错误， 变量a的类型在lambda体内为const的。
    auto func2 = [a] () mutable {++a;};     // 没有问题
    auto func3 = [&a] () {++a;};            // 没有问题
}
````

参数列表与返回值类型可以根据是否需要，进行省略掉, 规则如下：
- 当定义的lambda表达式的参数为空时，可以省略掉： ` [] -> 返回值类型 {函数体 } `
- 当定义的lambda表达式的函数体**仅有一条** `return  ****` 的语句时，返回值类型也可以省略，编译器会根据返回值的类型自动推断。 但是如果函数体是多条语句而你省略了返回值类型，编译器认为返回类型是void. 例如下面的lambda表达式的返回值类型默认为void, 一看就不对啊,所以此时你别省略返回值类型：
    ````c++
    auto Addfunc = [] (int a, int b) { int c = a + b; return c;}
    ````
- 捕获列表与函数体任何时候都不可以省略。

### 捕获列表

捕获列表只需要捕获lambda所在作用域内常规的局部变量，对于非局部变量以及局部的静态变量不需要捕获，可以直接使用。 例如：
````c++
int g_value = 100;
void sample()
{
    int value1 = 10;
    static value2 = 100;
    auto func = [value1]() {cout << g_value << value1 << value2; };
}
````

#### 值捕获
**方式一:** 使用 `[=]` 隐式捕获lambda内所有使用到的变量的值。
**方式二:** 使用 `[val1, val2, val3, ...]` 显示捕获lambda内使用到的变量的值。 
````c++
void sample()
{
    int value1 = 10;
    int value2 = 10;
    int value3 = 10;
    auto func1 = [=] () -> int {return value1 + value2 + value3;};
    auto func2 = [value1, value2, value3] () {value1 + value2 + value3;};
}
````

#### 引用捕获
**方式一:** 使用 `[&]` 隐式捕获lambda内所有使用到的变量的值。
**方式二:** 使用 `[&val1, &val2, &val3, ...]` 显示捕获lambda内使用到的变量的值。 
````c++
void sample()
{
    int value1 = 10;
    int value2 = 10;
    int value3 = 10;
    auto func1 = [&] () -> int {return value1 + value2 + value3;};
    auto func2 = [&value1, &value2, &value3] () {return value1 + value2 + value3;};
}
````

#### 混合捕获
**方式一:** 使用 `[val1, &val2, val3, ...]` 随意的组合值捕获和引用捕获来获取lambda内使用到的变量的值。 
**方式二:** 使用 `[=, &val1, &val2, ...]` 表示除了手动指出来的变量通过引用捕获之外，其它的变量都是通过值进行捕获。
**方式三:** 使用 `[&, val1, val2, ...]` 表示除了手动指出来的变量通过值捕获之外，其它的变量都是通过引用进行捕获。
````c++
void sample()
{
    int value1 = 10;
    int value2 = 10;
    int value3 = 10;
    auto func1 = [value1, &value2, value3] () {return value1 + value2 + value3;};
    auto func2 = [=, &value2] () {return value1 + value2 + value3;};
    auto func3 = [&, value3] () {return value1 + value2 + value3;};
}
````

**注意事项:**
> 1. 当lambda表达式定义在类内的成员函数时，如果在lambda表达式内部要访问类的成员函数或成员变量(无论public/protected/private)时，要么显示捕获this指针，要么通过[=]或[&]进行隐式捕获。
> 2. 使用引用捕获时，特别注意这些参数实体的生存期,保证调用lambda时这些实体是有意义的，避免悬垂引用的产生。

### 使用mutable关键字修饰的lambda
默认的lamba的声明方式是const声明，通过值获取的参数在lambda内是无法修改的，如果要改变该值，在参数列表后面加上mutable关键字。
````c++
void sample ()
{
    int a = 10;
    auto func1 = [a] () {++a;};             // 编译错误
    auto func2 = [a] () mutable {++a;};     // 没有问题
}
````

lambda表达式本身是纯右值表达式(你不可能对它的结果取地址的), 它的类型独有的无名非联合非聚合类类型，被称为闭包类型(closure type),  它可以有以下两个成员函数：
````c++
ret-type operator() (参数列表) const {函数体}     // 未使用关键字mutable时，默认情况
ret-type operator() (参数列表) {函数体}           // 使用了mutable 关键字时
````

**友情提示:** 
> mutable 关键字只对值捕获参数有影响，对引用捕获的参数无影响。原因是：引用参数能否修改为参数本身是否为const类型决定。即使一个类的成员函数有 const 声明(该const就是修改this指针的)，照样可以通过该成员函数修改一个引用类型的成员变量,例如：
> ````c++
> class Test {
> public:
>     Test(int& value) : a(value) {}
>     void Increase() const {++a;}
> private:
>     int& a;
> };
> ````
