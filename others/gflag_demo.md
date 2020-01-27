# [gflags](https://gflags.github.io/gflags/)简单入门的demo

## 一. [下载与安装](https://github.com/gflags/gflags/blob/master/INSTALL.md)
这里直接使用包管理器安装:
```
sudo apt install libgflags-dev
```

## 二. gflags的简单使用
### 1. 定义需要的类型  
**格式:** DEFINE\_类型名(变量名, 默认值, 描述语)

|类型|定义格式|
|:---:                  |:---:         |
|bool类型               |DEFINE\_bool  |
|32位的int类型          |DEFINE\_int32 |
|64位的int类型          |DEFINE\_int64 |
|64位的unsigned int 类型|DEFINE\_uint64|
|double类型             |DEFINE\_double|
|string类型             |DEFINE\_string|

例子：
- 定义一个名为name的string类型的变量
```
DEFINE_string(name, "xiaoming", "this is the name who you love! ");
```
- 定义一个名为uppercase的bool类型的变量
```
DEFINE_bool(uppercase, true, "Whether the output characters are in Uppercase format! ");
```
- 定义一个名为count的int类型的变量
```
DEFINE_int32(count, 10, "Number of times the output is repeated! ");
```

### 2. 在命令行中给定义好的变量进行赋值操作：
```
--uppercase=true   或者   --uppercase
--uppercase=false  或者   --nouppercase
--name="china"     或者   --name "China"
--count=10         或者   --count 10
```

### 3. 在代码中使用定义好的变量
在代码中使用之前定义好的变量时，在每一个变量名前加FLAGS\_的前缀就可以了.

|定义的变量名|代码中使用的变量名|
|:---:|:---:|
|name|FLAGS\_name|
|uppercase|FLAGS\_uppercase|
|count|FLAGS\_count|

## 三. 小小的demo
### 1. demo.cpp文件的编写
```
#include <iostream>
#include <gflags/gflags.h>

using namespace std;

// 定义三个变量
DEFINE_string(name, "xiaoming", "this is the name who you love! ");
DEFINE_bool(uppercase, true, "Whether the output characters are in Uppercase format! ");
DEFINE_int32(count, 10, "Number of times the output is repeated! ");

// 绑定对变量name和count的值合法性的检测函数
static bool ValidateName(const char* flagname, const string& value);
DEFINE_validator(name, &ValidateName);
static bool ValidateCount(const char* flagname, int value);
DEFINE_validator(count, &ValidateCount);

/** @brief 主函数 */
int main(int argc, char* argv[])
{
    // 进行解析命令行参数,true表示会修改argc和argv的值, 把相应的命令行参数去除掉。
    gflags::ParseCommandLineFlags(&argc, &argv, true);

    if (FLAGS_uppercase)
    {
        for (int i = 0; i < FLAGS_count; ++i)
            cout << "I LOVE " << FLAGS_name << endl;
    }
    else
    {
        for (int i = 0; i < FLAGS_count; ++i)
            cout << "i love  " << FLAGS_name << endl;
    }

    return 0;
}

/** @brief  定义对变量name值合法性的检测函数 */
static bool ValidateName(const char* flagname, const string& value)
{
    if (value.empty())
    {
        cout << "不应该输入空的参数值(" << flagname << " 的值为空) " << endl << endl;
        return false;
    }
    return true;
}

/** @brief 定义对变量count值的合法性检测函数。 */
static bool ValidateCount(const char* flagname, int value)
{
    if (value <= 0)
    {
        cout << "不应该输入小于或等于0的参数值(" << flagname << " 的值<= 0) " << endl << endl;
        return false;
    }
    return true;
}
```

### 2. CMakeLists.txt文件的编写
```
cmake_minimum_required(VERSION 3.10.2)
project(gflag_demo VERSION 1.0.0)
add_executable(demo.out demo.cpp)
find_package(gflags REQUIRED)
target_link_libraries(demo.out gflags)

```

### 3. 编译
```
mkdir build
cd build
cmake ..
make
```
### 4. 运行
```
./demo.out --uppercase=false --name="China" --count=10

输出为：

i love  China
i love  China
i love  China
i love  China
i love  China
i love  China
i love  China
i love  China
i love  China
i love  China
```
