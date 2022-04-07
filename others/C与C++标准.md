[toc]

----

## 参考文档

1. https://en.cppreference.com 
2. http://www.cplusplus.com
3. http://www.open-std.org
4. 《C语言程序设计现代方法》
5. 《C++ primer 第五版》
6. 

## C语言的起源发展

C语言诞生于1972年，美国贝尔实验室。作者为：Dennis MacAlistair Ritchie(丹尼斯·里奇) &   Kenneth Lane Thompson（肯·汤普森）。
之所以叫C语言，是从B语言（肯·汤普森创建）基础上发展而来。 1978年，他们编写了《The C Programming Language》一书，成为C程序员的“圣经”，编程爱好者称为 “K&R".
随着C语言迅速普及， 1983年，美国国家标准协会（ANSI）开始推动制订C语言标准。

### C标准

#### C89标准 （ANSI C标准）

1989年，ANSI发布了第一个完整的C语言标准——ANSI X3.159—1989，简称“C89”，也被称其为“ANSI C”。C89在1990年被国际标准组织ISO(International Organization for Standardization)一字不改地采纳，ISO官方给予的名称为：ISO/IEC 9899。

#### 95 标准

扩展很少， 主要是技术勘误，bugfix.  主要的扩展为：   扩充了宽和多字节字符支持, 包含`wctype.h'、'wchar.h`。


#### C99 标准

引入的新特性，常见的包含：

- _Bool类型

  C语言中的布尔类型， C语言中中的bool 类型为 \_Bool类型的typedef.

- long long 类型：  至少为64位。

- restrict 关键字

  该关键字仅有指向[对象类型](type.html)的指针，它告诉[编译器](https://baike.baidu.com/item/编译器)，所有修改所指向内存的操作都必须通过该指针来修改,而不会通过其它途径。

  该关键字的目的是为了促进编译器的优化，生成更有效率的汇编代码。

- // 注释

- stdint.h头文件

  类型： int8_t, int16_t, int32_t, uint8_t, uint16_t, uint32_t, intptr_t(可以保存void*类型指针）, uintptr_t 等。

  宏定义：INT8_MIN, INT16_MIN, INT32_MIN, INT64_MIN, 

  ​               INT8_MAX, INT16_MAX, INT32_MAX, INT64_MAX,

  ​                UINT8_MAX, UINT16_MAX, UINT32_MAX, UINT64_MAX等。

- inttypes.h 头文件

- 变长数组VLA

  变量长度的数组，可以在栈上使用变量定义数组长度。 如下所示：

  ```c
  
  
  // C99引入的VLA
  int main() {
      int a = 10;
      int array[a];  // 数组的大小为变量
      for (int i = 0; i < a; ++i) {
          array[i] = i;
      }
      return 0;
  }
  ```
  
  该特性在C11标准中退化为编译器的可选功能， 微软的MSVC一直不支持该特性，原因见：https://devblogs.microsoft.com/cppblog/c11-and-c17-standard-support-arriving-in-msvc/。 C++标准中也不支持VLA特性（很困惑的是：我使用g++的c++98标准编译类似的代码可以编译通过，不清楚为什么！）
  
- 声明与代码混合

  大家有时候看老代码，它们的写法就是上来就声明一堆变量，随后才业务逻辑代码， 就是因为`C89标准`规定变量必须在函数一开始进行初始化，到了`C99标准`中约束就放开了，代码可读性就好多了。

- for 循环的 init 子句中的声明

  下面这种写法，在`C99标准`之前是非法的，而`C99标准`允许这种方便的写法。

  ```c
  int sum = 0;
  for (int i = 0; i < 100; ++i) {
      sum += i;
  }
  ```

- 复合字面量

  就地构造一个指定类型的无名对象，在只需要一次数组、结构体或联合体变量时使用。 复合字面量的值类别是[左值](value_category.html)（能取其地址）。

  若复合字面量出现于文件作用域，则其求值所得的无名对象拥有静态[存储期](storage_duration.html)，若复合字面量出现于块作用域，则该对象拥有自动[存储期](storage_duration.html)（此情况下对象的[生存期](lifetime.html)结束于外围块的结尾）。

  ```c
  struct Info {
      int age;
      char* name;
  };
  
  int main() {
      // 数组类型
      int* array = NULL;
      array = (int[]){1, 4, 6, 7, 9};		// 复合字面量
      array[1] = 10;		// 该语句体现了左值特性，在C++中是不允许的, C++中不允许对临时变量取地址。
      
      // 结构体
      struct Info a = {10, "xiaohong"};
      a = (struct Info) {15, "xiaoming"};  // 复合字面量
  }
  ```

- 伸缩的数组成员

  即，我们通常说的变长数组， 空数组。  伸缩型数组成员必须是最后一个数组成员， 并且结构中必须至少有一个其他成员。https://www.ibm.com/docs/en/i/7.1?topic=declarations-flexible-array-members

  ```c
  // 业务代码中常见的所谓变长数组
  struct CellInfo {
      uint8_t cellNum;
      int info[];    // 定义空的数组长度
  };
  int cellNum = 100;
  cellInfo* pCellInfo = (cellInfo*)malloc(sizeof(CellInfo) + cellNum * sizeof(int));
  
  ```

- 指派初始化器

  可以通过指定数组下标或者结构体（联合体）字段的形式，以任意的顺序初始化数组或结构体变量。  未指定的下标或字段默认初始化为0。https://gcc.gnu.org/onlinedocs/gcc/Designated-Inits.html

  ```c
  int array[5] = {[3] = 100, [1] = 200};  // [0, 200, 0, 100, 0]
  
  struct Info {
      int a;
      int b;
      int c;
  }
  struct Info value = {.b = 100, .a = 200, .c = 2899};
  ```

- 变参数宏

  ```c
  #define 标识符( 形参, ... ) 替换列表	
  #define 标识符( ... ) 替换列表
  ```

  能用 `__VA_ARGS__` 标识符访问额外实参，然后该标识符被实参替换。

- \__func__

  在每一个函数体内，都预定义了一个变量`__func__`, 表示该函数的名字，该变量具有块作用域涉及静态存储期。等价于：

  ```c
  static const char __func__[] = "function name";
  ```

- 枚举的尾逗号

  下面枚举值的定义，在c89标准中是错误的，c99标准允许这么定义：

  ```c++
  enum Color {
      RED,
      BLUE,
      BLACK,    // 此处有一个逗号
  };
  ```

- 函数宏的空参数

- inline声明符

#### C11 标准

引入的新特性，常用的有：

- _Alignas 和 _Alignof  的字节对齐

  `_Alignas`用于作为修改声明对象对齐要求的说明符, `_Alignof` 用于查询其运算数类型的对齐要求。

  ```c
  int main() {
      _Alignas(8) int a;
      _Alignas(int) char b;
      size_t offset = _Alignof(double);	// 获取double类型的对齐的字节大小。
      return 0;
  }
  ```

- _Noreturn 声明符

  _Noreturn函数说明符用于告知编译器该函数将不返回任何内容。关于该关键字有什么作用的问题： 可能对阅读代码的人涉及编译器有些帮助吧。	

- _Static_assert编译期静态检查

  这个很有用，可以把一下安全检查放到编译期进行！例如：`_Static_assert(sizeof(int) == 4, "error: type INT is not 4 bytes.")`

- 匿名结构体和联合体

  在 C 语言中，可以在结构体中声明某个联合体（或结构体）而不用指出它的名字，如此之后就可以像使用结构体成员一样直接使用其中联合体（或结构体）的成员。 GCC对该特性的描述： https://gcc.gnu.org/onlinedocs/gcc/Unnamed-Fields.html#Unnamed-Fields

  ```c
  struct Info {
      int a;
      char b;
      struct {
          double x;
          double y;
      };
  } Object;
  Object.x = 100.2;	// 直接使用
  ```

- 泛型函数（\_Generic关键字）

  \_Generic关键字提供了一种在 **编译时** 根据 **赋值表达式** 的类型在 **泛型关联表** 中选择一个表达式的方法，因此可以将一组不同类型却功能相同的函数抽象为一个统一的接口，以此来实现泛型。

  说明1： 关联列表中的表达式仅仅是普通的宏替换。 

  说明2： default列表不是必须的。

  ```c
  void intFunc(int x) {
      printf("this is int func.\n");
  }
  void doubleFunc(double x) {
      printf("this is double func.\n");
  }
  void otherFunc(void x) {
      printf("this is other func.\n");
  }
  
  #define MYFUNC(x) _Generic((x), int: intFunc(x), double: doubleFunc(), default: otherFunc(x))
  
  int main() {
      int a = 10;
      double b = 20;
      char c = 'h';
      MYFUNC(a);
      MYFUNC(b);
      MYFUNC(c);
  }
  ```

  输出为：

  ```bash
  yin@yin-VirtualBox:~$ ./a.out 
  this is int func.
  this is double func.
  this is other func.
  
  ```

- 线程的内存模型、涉及`stdatomic.h`和`threads.h`头文件

  引入了`_Thread_local`关键字， 表示线程存储类限定符。存储期是创建对象的线程的整个执行过程，在启动线程时初始化存储于对象的值。每个线程拥有其自身的相异对象。

#### C17 标准

bugFix,  无新特性。

#### C23标准

下个主要 C 语言标准版本...

### 关键字

#### C89标准引入

auto、break、case、char、const、continue、default、do、double、else、enum、extern、float、for、goto、if、int、long、register、return、short、signed、sizeof、static、struct、switch、typedef、union、unsigned、void、volatile、while， 共计32个关键字。

补充说明：

- auto关键字，是存储类说明符，表示自动存储， 与C++标准引入的`auto`的含义不同。

- 掌握extern、static和votatile关键字的各种作用。

#### C99标准引入

restrict、inline 、\_Bool、\_Complex、\_Imaginary

#### C11标准引入

\_Alignas、\_Alignof、\_Atomic、\_Generic、\_Noreturn、\_Static_assert、\_Thread_local

#### C23标准引入

### 类型支持

#### void 类型

#### 基本类型

- char 类型

  表示字符类型， 大多数编译器认为是有符号的， 自己可以验证一下：把0xFF的char类型赋值给int类型， 看看结果为255不是-1。gcc的结果为-1。

- 布尔类型

  _Bool, C99标准引入的。 对应的取值：true与false为宏定义。

- 有符号类型

   signed char, short, int, long, long long（C99标准引入的）

- 无符号类型

  unsigned char,  unsigned short,  unsigned int , unsigned long , unsigned long long(C99标准引入)

- 浮点类型

  float 、 double 、 long double， 复数、虚数

#### 枚举类型 

- enum

#### 派生类型

- 数组类型

- 结构体类型

- 联合体类型

- 函数类型

- 指针类型

- 原子类型

  \_Atomic 关键字， C11标准引入的。

### 内存管理

申请内存的四大金刚函数：

- malloc函数

  最常用的内存分配函数，线程完全的。意味着会加锁，多线程有效率问题。另外，它是不可重入的，原因是：malloc通常为它所分配的存储区维护一个链接表和一些锁，在malloc执行过程中，如果遇到信号中断处理函数时， 并再一次调用malloc时，会破坏它维护的全局变量的信息。这也侧面说明了信号处理函数必须是可重入的。

- calloc函数

  与malloc的区别是：它分配内存之后， 会执行清零操作。 线程安全

- realloc函数

  该函数实现的功能不单一，不建议使用它，不介绍。

- aligned_alloc函数（C11标准引入）

  它可以分配对齐的内存空间， 线程安全。

- free函数

### 内联汇编

内联汇编（常由 \__asm__关键词引入）给予在 C 程序中嵌入汇编语言源代码的能力。

不同于 C++ 中，内联汇编在 C 中被当作扩展。它是条件性支持及由实现定义的，意思是它可以不存在，而且即使实现有所提供，它也并不拥有固定的含义。

因为不是标准，不同的 C 编译器拥有差异巨大的汇编声明规则，和与周围的 C 代码之间交互的不同约定.

## C++语言的起源与发展

1979年，Bjame Sgoustrup到了Bell实验室，开始从事将C改良为带类的C（C with classes）的工作。1983年该语言被正式命名为C++。

### C++标准

#### 标准之前

- 1979年， 支持的特性，包括：类，成员函数，派生类，公开与私有访问控制，友元，默认实参，内联函数，重载赋值运算符，构造函数，析构函数等。
- 1985年，Cfront 1.0编译器， 新增加特性：虚函数，函数与运算符的重载，引用， new 和 delete 运算符， const 关键词，作用域解析运算符。
- 1989年，Cfront 2.0编译器， 新增加特性：多继承，成员指针，受保护访问，类型安全的连接，抽象类，静态和 const 成员函数，类特有的 new 和 delete
- 1990年，新增加特性：命名空间，异常处理，嵌套类，模板。

#### C++98标准

- RIIT(运行时类型识别)

  1. dynamic_cast类型转引说明符: 只能用于转换多态的类对象。 当由**基类的指针或引用**转换到**子类型的指针或引用**时，会进行**运行时检查**。 当转换失败时，如果是指针类型，返回空指针，如果是引用类型，抛出异常。

  2. typeId运算符， 查询类型的信息， 使用时需要包含`<typeinfo>`头文件。当应用于多态类型的表达式时，typeid 表达式的求值可能涉及运行时开销（虚表查找），其他情况下 typeid 表达式都在编译时解决。 typeId运算符返回的类型为`std::type_info`类型。

- 转型运算符

  允许从类类型到其他类型的隐式转换或显式转换（C++11引入的explicit关键字，指定必须进行显示转换）， 隐式转换函数没有参数或显式返回类型。

  ```c++
  class A {
  public:
      // 从A类型转换为int类型
      operator int() const {
          return value;
      }
  private:
      int value;
  }
  ```

- 协变返回类型

  虚函数重载时，要求子类与基类函数的返回类型必须相同或者协变。  例如：

  ```c++
  class Base {
  public:
      virtual Base* Get() {
          return this;
      }
  };
  
  // 虚函数的返回值为协变场景。
  class Derived : public Base {
  public:
      Derived* Get() override {
          return this;
      }
  };
  ```

  具体的协变返回类型的定义如下：

  1. 两个类型均为到类的指针或引用（左值或右值）。不允许多级指针或引用。
  2. `Base::f()` 的返回类型中被引用/指向的类，必须是 `Derived::f()` 的返回类型中被引用/指向的类的无歧义且可访问的直接或间接基类。
  3. `Derived::f()` 的返回类型必须有相对于 `Base::f()` 的返回类型的相等或较少的 cv 限定。

- mutable关键字

  用于修饰类或结构体内的非const非引用的成员变量， 当类或结构体被修饰为const时， 也可以修改这些被mutable修饰的成员变量。  例如：

  ```c++
  struct Info {
      int a;
      mutable int b;
  };
  const Info i;
  i.b = 100;
  ```

- 成员模板

  模板声明可以定义在任何非局部类内部， 例如：成员函数模块、类内的类模板、using声明等。

  ```c++
  class Demo {
  public:
      template<typename T>
      void Get();
      
      template<typename T>
      struct A;
      
      template<typename T>
      using Func = Set<T&>;
  };
  ```

- export  （C++11之后，不使用了， 在c++20中，引入模块之后又了新的含义）

- bitset库

- auto_ptr  （应该是在C++17标准中删除掉，太危险！）

- iostream库

- complex库

#### C++03标准

- 值初始化

  使用()或者{}构造一个对象时，执行值初始化。 标准中介绍的比较绕，见(). 

  自己总结如下：

  1. 内置类型，执行零初始化。
  2. 类对象， 如果是聚合类型，使用{}时，执行聚合初始化（如果此时类的构造函数声明为删除的(=delete), 类对象也是可以被构造出来）。
  3. 类对象，如果**编译器隐式提供** 或者 **在类内部声明的同时使用=default显示让编译器提供**，先对成员变量进行清零，再调用成员变量的构造函数进行初始化。
  4. 类对象，有用户自定义的构造函数（在类外部使用=dafault定义的构造函数属于用户自定义），执行该构造函数进行初始化。
  5. 数组成员，以每一个变量执行值初始化。

#### C++11标准

##### auto关键字

类型的自动推导， auto的自动类型推断发生在编译期，所以使用auto并不会造成程序运行时效率的降低。使用场景举例：

- 函数尾置返回类型中的auto 占位符（c++14标准允许了使用auto用于推导函数返回类型）

  ```c++
  // 例子一：
  auto GetFunc() -> int(*)() {  // 这样写，代码更清晰
      return nullptr;
  }
  // 例子二：函数模板中返回值依赖模板参数
  template<typename T, typename U>
  auto Accumulate(T x, U y) -> decltype(x * y) {
      return x * y;
  }
  ```

- 变量的类型推导， 有以下几点细节要多多注意：

  1. 在进行变量类型推导过程中， 会自动去除**引用**语义、**顶层const**语义、**volatile**语义，保留**底层const**。
  2. 在推导过程中，变量会隐式执行数组名到指针类型转换，如果带了引用号， 肯定还会保留数组类型。
  3. 类似`auto *p`的写法个人感觉没有太大意义，反而让代码阅读者更疑惑， auto本身就会推导出**指针类型**。

  ```c++
  int a = 100;
  const int* pA = &a;
  const int& refA = a;
  
  auto b1 = a;        // 类型为int
  auto b2 = refA;     // 类型为int
  
  const auto b3 = a;  // 类型为const int
  auto& b4 = a;       // 类型为int&
  auto& b5 = refA;    // 类型为const int&
  auto b6 = pA;       // 类型为const int*
  
  int array[4] = {1, 2, 3, 4};
  auto c1 = array;    // 类型为int*
  auto& c2 = array    // 类型为int(&)[4];
  ```

##### decltype操作符

decltype操作符用于查询表达式或者实体变量的数据类型。在难以或不可能以标准写法进行声明的类型时，`decltype` 很有用，例如 lambda 相关类型或依赖于模板形参的类型。并不会实际计算表达式的值，编译器分析表达式并得到它的类型。 另一个应用就是：使用尾置返回时，推断返回值的类型。

对于表达式，当表达式的值类别为将亡值时， delctype的结果为右值引用T&&；当值类别为左值时，产生左值引用T&；当值为纯右值时，产生类型T。

对于变量，decltype会完整的返回变量的类型，包含顶层的const以及引用（auto做不到这一点）。 如果对象的名字带有括号，则它被当做通常的左值表达式，从而 decltype(x) 和 decltype((x)) 通常是不同的类型。

**注意点**：decltype对数组进行操作时，它的返回结果仍然为数组类型，而非指针。

```c++
int& a = 10;
const int& b = 100;
int c = 1;
int *p = c;
int array[10] = {0};

decltype(a) a1 = a;    // 推导类型为:int&
decltype(b) b1 = b;    // 推导类型为：const int& b
decltype(c) c1 = 10;   // 推导类型为：int
decltype((c)) c2 = c;  // 推导类型为：int&
decltype(*p) p1 = c;   // 推导类型为：int&
decltype(array) A = {0}; // 推导类型为：int[10]

auto f = [] () -> int {return 0;}
decltype(f) ff = f;     // 推导类型为：lambda表达式的函数类型
```

##### = default 预置函数

可以强制编译器自动自成以下特殊成员函数， 即可以在声明的时候使用，也可以在类外部使用，当在类外面使用时，认为是用户自定义的，而非编译器自动生成的。`= default` 也只能对下面的特殊成员函数使用。

- 默认构造函数
- 复制构造函数
- 移动构造函数
- 复制赋值运算符
- 移动赋值运算符
- 析构函数

##### = delete 弃置函数

它的作用是把函数被定义为*弃置的（deleted）*。任何弃置函数的使用都是非良构的（程序无法编译）。这包含调用，包括显式（以函数调用运算符）及隐式（对弃置的重载运算符、特殊成员函数、分配函数等的调用），构成指向弃置函数的指针或成员指针，甚或是在不求值表达式中使用弃置函数。`= delete`只能出现在函数声明时，若函数被重载，则首先进行[重载决议](overload_resolution.html)，且仅当选择了弃置函数时程序才非良构。

 可以用于对除了**析构函数**之外的任何的函数进行指定`= delete `，不仅仅是类成员函数，还可以是普通函数。 尤其是在引导函数匹配过程中， 删除的函数非常有用。

```c++
template<typename T>
void Get() = delete;

template<>
void Get<int>() {
    cout << "int" << endl;
};
template<>
void Get<double>() {
    cout << "double" << endl;
};

int main() {
    Get<int>();
    Get<double>();
    Get<long>();   // 该行编译报错
    return 0;
}
```

##### final 关键字

首先说一点，`final`不是C++中的关键字， 只 是在成员函数声明或类头部中使用时有特殊含义的标识符。其他语境中它未被保留，而且可用于命名对象或函数。

`final`用于指定某个**虚函数**不能在子类中被覆盖，或者某个类不能被子类继承,。 只能用在类的成员函数声明时使用， 并且只能用于虚函数。

##### override关键字

指定一个虚函数覆盖另一个虚函数。 `override` 是在成员函数声明符之后使用时拥有特殊含义的标识符：其他情况下它不是保留的关键词。

##### 尾随返回类型

```c++
// 例子一
auto func(int i) -> int(*)[10];
// 例子二, lambda表达式
auto func = []() ->int {return 10;}
// 例子三：模板
template <typename T>
auto func(It beg, It end) -> decltype(*beg) {
    return *beg;
}
```

##### 右值引用: &&

##### 移动构造函数和移动赋值运算符

```c++
Class A {
public:
    A(A&& rhs) {}
    A& operator=(A&& rhs) {}
};
```

##### 指定枚举类型的底层类型

C++11之前，声明枚举类型，其底层类型不固定。底层类型是某个能表示所有枚举项值的整型类型，此类型不大于 `int`。 C++11及之后，可以指定枚举类型的底层类型。

```c++
// C++11 之前
enum Color {
	RED,
	GREEN,
	YELLOW,
};
// C++11 之后
enum Color : uint8_t {
	RED,
	GREEN,
	YELLOW,
};
```

##### 强枚举类型

标准C++中，枚举类型不是类型安全的, 枚举值可以隐式地转换为整数类型。C++11引入枚举类，即有作用域的枚值类型，为类型安全，枚举类型不可以隐式转换为整数类型，否则，编译器会报错。另外，声明有作用域枚举类型时，底层类型默认为`int`.

```c++
enum class Color {
	RED,
	GREEN,
	YELLOW,
};
// 使用是必须指定作用域
Color value = Color::RED;
```

##### constexpr 修饰符： 

用于修饰编译器就可以确定下来的值。让代码开发人员很开心， 让编译器开发人员很恶心！

##### 范围for

##### static_assert 声明

编译期的静态检查！

##### 列表初始化 

从花括号初始化器列表初始化对象。 具体地，根据不同的使用场景，执行不同的初始化效果。

##### 列表初始化返回值

c++新标准规定，函数可以返回花括号包围的值的列表。即使用列表对函数返回的临时变量进行初始化。

##### std::initializer_list 类

它是一个类模板， 定义于头文件<initializer_list>中，底层是一个const T<N>的临时数组，占用栈空间，类似于std::array. 在以下场景，会自动构造`std::initializer_list`对象：

- 用*花括号初始化器列表*[列表初始化](../language/list_initialization.html)一个对象，其中对应构造函数接受一个 `std::initializer_list` 参数
- 以*花括号初始化器列表*为[赋值](../language/operator_assignment.html#.E5.86.85.E5.BB.BA.E7.9A.84.E7.9B.B4.E6.8E.A5.E8.B5.8B.E5.80.BC)的右运算数，或[函数调用参数](../language/overload_resolution.html#.E5.88.97.E8.A1.A8.E5.88.9D.E5.A7.8B.E5.8C.96.E4.B8.AD.E7.9A.84.E9.9A.90.E5.BC.8F.E8.BD.AC.E6.8D.A2.E5.BA.8F.E5.88.97)，而对应的赋值运算符/函数接受 `std::initializer_list` 参数
- 绑定*花括号初始化器列表*到 `auto`，包括在范围 for 循环中。

**特别注意**： 复制一个 `std::initializer_list` 不会复制其底层对象，即**浅拷贝**。

源代码实现大致如下：

```c++
  /// initializer_list
  template<class _E>
    class initializer_list
    {
    public:
      typedef _E 		value_type;
      typedef const _E& 	reference;
      typedef const _E& 	const_reference;
      typedef size_t 		size_type;
      typedef const _E* 	iterator;
      typedef const _E* 	const_iterator;

    private:
      iterator			_M_array;
      size_type			_M_len;

      // The compiler can call a private constructor.
      constexpr initializer_list(const_iterator __a, size_type __l)
      : _M_array(__a), _M_len(__l) { }

    public:
      constexpr initializer_list() noexcept
      : _M_array(0), _M_len(0) { }

      // Number of elements.
      constexpr size_type
      size() const noexcept { return _M_len; }

      // First element.
      constexpr const_iterator
      begin() const noexcept { return _M_array; }

      // One past the last element.
      constexpr const_iterator
      end() const noexcept { return begin() + size(); }
    };
```

##### 统一初始化

在c++11之后，内置类型与类对象都可以使用{}进行初始化，即做到了统一初始化。

1. 当{}初始化内置类型时，  不允许有精度丢失的问题，例如：`int a = 10, short b{10};`

2. 当{}初始化类对象时，编译器会构造一个临时的std::initializer_list<T>的对象，然后一 一 赋值给构造函数的参数。例如：

   ```c++
   struct Data {
       Data(int a, int b, int c)
       {
       }
   }
   Data value{1, 2, 3};   // 1--->a, 2---->b, 3----->c.
   ```

   

##### 委托的构造函数

一句话总结，当一个类有多个构造函数时，其中一个构造函数的工作可以委托给另一个来做。举例：

```c++
class A {
public:
    A(int a, int b, int c) {
        a_ = a;
        b_ = b;
        c_ = c;
    }
    A(int b) : A(10, b, 100) {}   // 它的工作委托给第一个构造函数来做。
private:
    a_ = 0;
    b_ = 0;
    c_ = 0;
};
```

##### 继承的构造函数

一句话总结，当子类仅仅是为了透传参数，为了构造基类时，子类可以使用`using 基类名字`继承基类的构造函数，避免重复写了。

具体来说，using 声明语句只是令某个名字在当作用域内可见，而当作用于构造函数时，using声明语句将令编译器代码。

和普通成员的using 声明不同的是：一个构造函数的using声明不会改变该构造函数的访问级别。

```c++
class A {
public:
    A(int a, int b) {}
};
class B {
public:
    using A::A;
}
```

##### nullptr

##### 类型别名 using 

它的作用是替换typedef, 它能做到typedef做不到的事情。例如：

```c++
using otherName = int;

template<typename T>
using Array = vector<T>;    // typedef做不到吧。
```

##### 变参模板与形参包

关于该特性，最重要的是理解两点：**参数包**和**包展开**, 在此基础上，就可以很轻松学会使用递归或继承的手法对具体的参数进行操作了。

参数包，分为模板参数包和函数参数包， 其它模板参数包又可以分为类型模板参数包和非类型模板参数包。举例说明：

```c++
template <typename... Args>   // Args为类型模板参数包
void Func(Args... t)          // t为函数参数包
{}

template <int... indexs>     // indexs为非类型模板参数包
void Func() {
    int array[] = {indexs...};
}
```

包展开， 格式为： `模式 ... `,    看着比较抽象，举例说明：

```c++
/************   函数实参列表时的包展开    ***************/
template <typename... Args>
Func(Args... args)     // 这里其实是对Args形参包的展开
{
    f(args...);  // 展开模式为参数本身T， 展开后为：arg0, arg1, arg2, arg3, ....
    f(&args...);  // 展开模式为&T,  展开后为：&arg0, &arg1, &arg2, &arg3, ...
    f(++args...); // 展开模式为++T, 展开后为： ++arg0, ++arg1, ++arg2, ++arg3, ...
    f(2 + args...); // 情节模式为2+T, 展开后为：2+arg0, 2+arg1, 2+arg2, 2+arg3, ...
    f(sum(5+args)...);  // 展开模式为：sum(5+T), 展开后为：5+arg0, 5+arg1, 5+arg2, 5+arg3, ...
    f(std::forward<Args>(100+args)...);   // 类型与参数一起展开，类型展开为Arg0, Arg1, Arg2, ...., 
    								      // 参数展开为：10+arg0, 100+arg1, 100+arg2, ... 
    f(const_cast<const Args*>(&args)...)  // 展开模式与上面类似。
    
    // 借用列表初始化，对args中的每一个参数进行打印输出。 展开后的样子为：
    // int dummy[] = {(cout << arg0, 0), {cout << arg1, 0}, ...., };
    int dummy[] = {(cout << args, 0)... };
}

/************   类型模板实参的包展开    ***************/
template <Typename... Args>
class MyData {
    tuple<Args...> t1;    // 类型展开为： arg0, arg1, arg2, ...
    tuple<int, Args..., double> t2;  // 类型展开为：int, arg0, arg1, arg2, ..., double
}

/************   更复杂的包展开    ***************/
f(h(args...) + args...); // 展开成： f(h(E1,E2,E3) + E1, h(E1,E2,E3) + E2, h(E1,E2,E3) + E3)

template<typename ...Ts, int... N>
void g(Ts (&...arr)[N]) {}  // Ts (&...)[N] 不被允许，因为 C++11 语法要求带括号的省略号形参拥有名字
int n[1];
g<const char, int>("a", n); // Ts (&...arr)[N] 展开成 const char (&)[2], int(&)[1]


// 包展开可以用于指定类声明中的基类列表。典型情况下，这也意味着其构造函数也需要在成员初始化器列表中使用包展开，以调用这些基类的构造函数
template<class... Mixins>
class X : public Mixins... {
 public:
    X(const Mixins&... mixins) : Mixins(mixins)... { }
};

// 包展开可以出现于 lambda 表达式的捕获子句中
template<class ...Args>
void f(Args... args) {
    auto lm = [&, args...] { return g(args...); };
    lm();
}
```

sizeof...   运算符， 它用于获取参数包的数目，而非 参数包的sizeof的总和哦。使用举例：

```c++
template <typename... Args>
Func(Args... args)
{
    cout << sizeof...(Args) << endl;
    cout << sizeof... (args) << endl;
}
Func(10, 15.6, 'a', "hello");   // 输出结果都为4.
```

使用递归或继承对具体的每一个参数进行操作

```c++
// 递归式展开
template <typename T>
void MyPrint(T t) {
    cout << t << endl;
}

template <typename Head, typename... Tail>
void MyPrint(Head first, Tail... others) {
    cout << first << endl;
    MyPrint(others...);
}

int main() {
    MyPrint(10, 20.4, 'a', "sting");
    return 0;
}

// 继承式展开
template <typename... T>
class Manager;

template<typename T>
class Manager<T> {        // 偏特化
public:
    Manager(T t) {
        cout << t << endl;
    }
};

template<typename Head, typename... Tail>
class Manager<Head, Tail...> : public Manager<Tail...> {
public:
    Manager(Head first, Tail... others) : Manager<Tail...>(others...) {
        cout << first << endl;
    }
};

int main() {
    // 下面的输出，是反着的， v~^~v
    Manager<int,double, char, string> my(10, 12.4, 'a', "hello");
    return 0;
}
```

##### lambda表达式

说明以下几点：

1. 在c++11中，可以显示捕获列表可以捕获`this`, 但是不可以显示捕获`*this`.
2. 当出现任一默认捕获符（`= ` 或者`&`)时，都能隐式捕获当前对象（`*this`）。当它被隐式捕获时，始终被以引用捕获，即使默认捕获符是 `=` 也是如此。 如果想要以复制的方式显示捕获`*this`， 只能等到c++17了。

##### noexcept

##### alignof 和 alignas

##### 线程局域存储 _thread

##### 静态断言

##### bind 函数

##### emplace 操作

#### C++14标准

##### 变量模板

格式为： `template <形参列表> 变量声明`。使用举例：

```c++
template<typename T>
string Type{"I do not know."};

int main() {
    Type<int> = "int";
    Type<long> = "long";
    Type<char> = "char";
    Type<double> = "double";
    cout << Type<int> << " " << Type<long> << " " << Type<char> << " " << Type<double> << " " << Type<float> << " " << endl;
    return 0;
}

```

特别注意以下几点：

1. 实例化后的的作用域为：是变量模板声明的位置， 而不是变量模板实例化的位置。

##### auto关键字：  

- 在c++14标准中，使用`auto`可以推导函数的return 语句中推导出它的返回类型。

  ```c++
  auto Get() {
      return 10.5;
  }
  ```

- decltype(auto)：实际推导出来的类型就是 decltype(expr)的类型， 推导结果比auto 更准确！ 举例说明：

  ```c++
  int a = 10;
  int& refA = a;
  auto b = refA;    // b的类型为int
  decltype(auto) c = refA;    // c的类型为int&
  ```

##### 泛型lambda表达式

当lambda表达式中的参数类型为auto时， 它就是一个泛型状态，对外表现类型于函数模板。例如：

```c++
int main() {
    auto sumFunc = [](auto a, auto b){ return a + b;};    // 泛型lambda表达式
    double c1 = sumFunc(1.5, 2.3);
    int c2 = sumFunc(1, 2);
    return 0;
}

// 上面的泛型lambda表达式与下面的函数模板是等价的
template<typename T, typename Y>
auto sumFunc(T a, Y b) {
    return a + b;
}
```

##### lambda 捕获列表的初始化

在c++11的版本，lambda的捕获列表只能捕获lambda表达式所在作用域的局部变量或全局变量，无法初始化自己的局部变量。c++14允许在捕获列表中初始化自定义的局部变量，与函数的参数初始化参数类似。举例：

```c++
int x = 10;
auto Func = [a = 100, b = x](){ return a + b;};

unique_ptr<int> myPtr = make_unique<int>(100);
auto func = [ptr = std::move(myPtr)](){cout << *ptr << endl;};
```

##### constexpr函数的条件放松

具体放松到什么程度，记不住，反正比c++11的约束条件少了一些。 constexpr函数平时几乎不使用，不多研究。

##### 二进制字面量

对于该特性，我一直不太明白，  c++14之前，也支持这样的写法啊`int a = 0b1010101`，怎么就变成c++14的新特性了呢。

##### 单引号作为数位分隔符

这个特性，有时候使用起来还不错，比如： `long long num = 1000'000'000'000'000`.

##### [[deprecated 属性]]

指示一个实体已经被弃用，虽然还可以使用但是不鼓励。  它可以修饰类、变量、函数、命名空间枚举、模板特化等。具体的使用原则为： 

- [class/struct/union](../classes.html)：struct [[deprecated]] S;，
- [typedef 名](../typedef.html)，也包括[别名声明](../type_alias.html)：[[deprecated]] typedef S* PS;、using PS [[deprecated]] = S*;，
- 变量，包括[静态数据成员](../static.html)：[[deprecated]] int x;，
- [非静态数据成员](../data_members.html)：union U { [[deprecated]] int n; };，
- [函数](../function.html)：[[deprecated]] void f();，
- [命名空间](../namespace.html)：namespace [[deprecated]] NS { int x; }，
- [枚举](../enum.html)：enum [[deprecated]] E {};，
- 枚举项：enum { A [[deprecated]], B [[deprecated]] = 42 };，
- [模板特化](../template_specialization.html)：template<> struct [[deprecated]] X<int> {};。

使用举例：

```c++
[[deprecated("本函数已经弃用")]]
int myFunc() {
    return 10;
}

[[deperacated]]
int global = 100;

int main() {
    myFunc();
    global = 10;
    return 0;
}

// 编译时的输出为：
D:\programs\msys2\mingw64\bin\g++.exe -g D:\myCode\main.cpp -o D:\myCode\main.exe
D:\myCode\main.cpp:16:5: warning: 'deperacated' attribute directive ignored [-Wattributes]
   16 | int global = 100;
      |     ^~~~~~
D:\myCode\main.cpp: In function 'int main()':
D:\myCode\main.cpp:19:12: warning: 'int myFunc()' is deprecated: 本函数已经弃用 [-Wdeprecated-declarations]
   19 |     myFunc();
      |            ^
D:\myCode\main.cpp:11:5: note: declared here
   11 | int myFunc() {
      |     ^~~~~~

生成已完成，但收到警告。
```

##### 标准库的新特性

- std::make_unique

- std::integer_sequence

  见源码：

  ```c++
  // integer_sequence
  template<typename _Tp, _Tp... _Idx>
  struct integer_sequence
  {
      typedef _Tp value_type;
      static constexpr size_t size() noexcept { return sizeof...(_Idx); }
  };
  
  // make_integer_sequence
  using make_integer_sequence = integer_sequence<_Tp, __integer_pack(_Num)...>;
   
  // index_sequence
  template<size_t... _Idx>
  using index_sequence = integer_sequence<size_t, _Idx...>;
  
  // make_index_sequence
  template<size_t _Num>
  using make_index_sequence = make_integer_sequence<size_t, _Num>;
  ```

- std::exchange

- std::quoted

- std::shared_timed_mutex 与 std::shared_lock

#### C++17标准

##### 移除的老特性

- auto_ptr
- register关键字
- 等等。 剩余的过时的那些特性，也没有使用过，不列出。

#####  折叠表达式

目的就是使对参数包的操作更加容易。使用递归和继承的方法展开参数包，确实有一些麻烦！折叠表达式可以分为四种形式：

1. 一元右折叠： `形参包 op ...`
2. 一元左折叠：`... op 形参包`
3. 二元右折叠： `形参包 op ... op 初始值`
4. 二元左折叠： `初始值 op ... op 形参包`

怎么理解呢？  把`...` 理解成**括号括起来的**一系列的表达式， `...` 在形参包的右边就是右折叠，在左边就是左折叠。

支持的操作符包括：`+ - * / % ^ & | = < > << >> += -= *= /= %= ^= &= |= <<= >>= == != <= >= && || , .* ->*`。在二元折叠中，两个 *op* 必须相同。

注意事项：

1. 特别注意求值顺序有要求的操作的操作符, 肯定是先求括号括起来的那一部分，再求最后一层，所以根据自己的要求，合理选择左折叠不是右折叠。
2. 将一元折叠用于零长包展开时，仅允许下列运算符：
   - 逻辑与（&&）。空包的值为 true
   - 逻辑或（||）。空包的值为 false
   - 逗号运算符（,）。空包的值为 void()

##### 类模板实参的推导

c++17, 扩展了一些场景下，类模板的类型参数可以通过构造函数的参数进行推导出来。 我感觉，实在价值确实不太大吧，只是写代码时方便了一些，我不深入了解。

##### 编译期的constexpr if 语句

以 `**if constexpr**` 开始的语句被称为*constexpr if 语句*。 特点是：编译期执行。

##### inline 变量

在c++17中，由于关键词 inline 对于函数的含义已经变为“容许多次定义”而不是“优先内联”，因此这个含义也扩展到了变量。inline 保证了**在多个翻译单元中定义，但最终只保留一个， 保证所有.cpp文件中的定义都是相同的**。

这个就厉害了， 可以定义一个变量放到头文件中，方便多了。

```c++
// 1.h
inline a = 10;

// a.cpp
void f1() {
    a = a - 100;
}

// b.cpp
void f2() {
    a = a + 100;
}
```

##### 结构化绑定

它的作用是使写代码更加方便。 可以绑定数组、绑定std:pair<T>, std::tuple<T>类型，还可以绑定public的类对象。使用方法：

`【c-v限定符】 auto 【&】 [参数名1， 参数名2] = 表达式`.  

里面可能会有很多小的语言成面的注意事项，通常写代码中，这些细节我们都不需要关心的，理解常用的方法就够了！

该新特性， 确实可以大大方便写代码，不还是非常有价值的。 举例说明：

```
// 举例1: 绑定数组
int a[2] = {1, 2};
auto [x, y] = a;    // 修改x,y 不会影响到数组a
auto &[x, y] = a;   // 修改x,y 会影响到数组a.

// 举例2： 绑定struct
struct Point {
	int x;
	int y;
};
Point p{100, 200};
auto[x0, y0] = p;
auto& [x0, y0] = p;

struct Point2 {
	const int x = 100;
	const int y = 200;
};
Point2 p2;
auto [x1, y1] = p2;
x1 = 10000;    // 编译报错，只读类型，不可以修改。

// 举例3： 绑定std::pair
std::set<string> mySet;
.....
auto [iter, success] = m.insert("heloo");

std::map<string, int> myMap;
...
for (auto [name, age] : myMap) {
    cout << name << age << endl;
}
```

##### if 和 switch 语句中的初始化器

在if语句 和switch 语句中，可以引入一个局部变量并进行初始化， 使用**分号**进行隔离。  举例：

```c++
if (int i = 200; i > 20) {
    cout << "OK" << endl;
}

switch(int a = GetValue; a + 10) {
    case 1: ....
    case 2: ...
    break;
}
```

##### 简化的嵌套命名空间

##### using 声明语句可以声明多个名称

##### 新的求值顺序规则

##### noexcept 作为类型系统的一部分

##### lambda表达式捕获 *this

c++17,增加了lamba表达式的捕获列表中，可以显示捕获`*this`， 表现为：当前对象的简单以复制捕获。 

```c++
class Demo {
public:
  auto GetFunc() {
      auto f = [*this]() {      // c++17之前，这样写是错误的！1
          cout << a << endl;
      }
  } 
private:
    int a = 100;
};
```

##### [[fallthrough]]

用于switch语句中，表示第上一个case语句，直落到下一个case语句，是有意而为之，编译器不需要给出警告。

##### [[nodiscard]]

一句话：用于修饰函数、类、或枚举值，调用声明为 `nodiscard` 的函数，或调用**按值返回**声明为 `nodiscard` 的枚举或类的函数，并且忽略了这些函数返回值时（即充值表达式），让励编译器发布警告。

想要避免给出警告，把函数返回值使用`void`转型一下就可以了， 即： `(void)Func(10);`

##### [[maybe_unused]]

在`.cpp`文件中，如果定义了未使用的变量或函数时， 编译器会告警。怎么办？那就使用该声明告诉编译器别发警告。

##### __has_include

 预处理器常量表达式，若**找到**文件名则求值为 1，而若找不到则求值为 0。 通常用于检查一下要包含的头文件是否存在，如果存在，就include 它。

```c++
#if __has_include(<optional>)
#  include <optional>
#endif
```

##### any 库

又称为万能容器，可以存放任意类型的单一对象。 

1. 它是一个名为 `any`的类，而非类模板。
2. 它本质上，就是对具体类型的封装，它来管理具体对象的内存、生命周期。
3. 获取它管理的具体对象，只能通过 非成员函数`any_cast`获取。
4. c++17为什么引入它？ 价值在哪里？

贴一些any类具体实现的一些源码， 加深理解：

1. any类的对象的内存管理， 小块内存（具体是<= sizeof(void*))使用栈空间，大块内存使用堆空间。

   ```c++
   // 内存存储
   union _Storage
   {
       constexpr _Storage() : _M_ptr{nullptr} {}
   
       // Prevent trivial copies of this type, buffer might hold a non-POD.
       _Storage(const _Storage&) = delete;
       _Storage& operator=(const _Storage&) = delete;
   
       void* _M_ptr;   // 指向堆空间
       aligned_storage<sizeof(_M_ptr), alignof(void*)>::type _M_buffer;   // 栈空间内存
   };
   
   // 小块内存管理类
   template<typename _Tp>
       struct _Manager_internal
       {
   static void
   _S_manage(_Op __which, const any* __anyp, _Arg* __arg);
   
   template<typename _Up>
       static void
       _S_create(_Storage& __storage, _Up&& __value)
       {
       void* __addr = &__storage._M_buffer;
       ::new (__addr) _Tp(std::forward<_Up>(__value));
       }
   
   template<typename... _Args>
       static void
       _S_create(_Storage& __storage, _Args&&... __args)
       {
       void* __addr = &__storage._M_buffer;
       ::new (__addr) _Tp(std::forward<_Args>(__args)...);
       }
       };
   
   // 大块内存管理类
   template<typename _Tp>
       struct _Manager_external
       {
   static void
   _S_manage(_Op __which, const any* __anyp, _Arg* __arg);
   
   template<typename _Up>
       static void
       _S_create(_Storage& __storage, _Up&& __value)
       {
       __storage._M_ptr = new _Tp(std::forward<_Up>(__value));
       }
   template<typename... _Args>
       static void
       _S_create(_Storage& __storage, _Args&&... __args)
       {
       __storage._M_ptr = new _Tp(std::forward<_Args>(__args)...);
       }
       };
   };
   ```

 2.  any类中的成员变量：

    ```c++
    void (*_M_manager)(_Op, const any*, _Arg*);
    _Storage _M_storage;
    ```

3. any_cast的实现：

   ```c++
   template<typename _ValueType>
   inline _ValueType any_cast(const any& __any)
   {
       using _Up = __remove_cvref_t<_ValueType>;
       static_assert(any::__is_valid_cast<_ValueType>(),
       "Template argument must be a reference or CopyConstructible type");
       static_assert(is_constructible_v<_ValueType, const _Up&>,
       "Template argument must be constructible from a const value.");
       auto __p = any_cast<_Up>(&__any);
       if (__p)
   return static_cast<_ValueType>(*__p);
       __throw_bad_any_cast();
   }
   template<typename _ValueType>
   inline _ValueType any_cast(any& __any)
   {
       using _Up = __remove_cvref_t<_ValueType>;
       static_assert(any::__is_valid_cast<_ValueType>(),
       "Template argument must be a reference or CopyConstructible type");
       static_assert(is_constructible_v<_ValueType, _Up&>,
       "Template argument must be constructible from an lvalue.");
       auto __p = any_cast<_Up>(&__any);
       if (__p)
   return static_cast<_ValueType>(*__p);
       __throw_bad_any_cast();
   }
   
   template<typename _ValueType>
   inline _ValueType any_cast(any&& __any)
   {
       using _Up = __remove_cvref_t<_ValueType>;
       static_assert(any::__is_valid_cast<_ValueType>(),
       "Template argument must be a reference or CopyConstructible type");
       static_assert(is_constructible_v<_ValueType, _Up>,
       "Template argument must be constructible from an rvalue.");
       auto __p = any_cast<_Up>(&__any);
       if (__p)
   return static_cast<_ValueType>(std::move(*__p));
       __throw_bad_any_cast();
   }
   ```

##### optional库

1. 类模板。
2. 管理一个*可选*的对象。

##### variant库

##### memory_resource库

##### string_veiw库

##### as_const特性

##### not_fn

#### C++20标准

### 关键字

const:  在未声明为 `extern` 的非局部非 volatile 非[模板](variable_template.html) (C++14 起)非 [inline](inline.html) (C++17 起)变量声明上使用 `const` 限定符，会给予该变量[内部连接](storage_duration.html#.E8.BF.9E.E6.8E.A5)。这有别于 C，其中 const 文件作用域对象拥有外部连接。

### 类型支持

### 模板与范型

### 元编程

## 区别与联系 