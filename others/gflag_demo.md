# gflag 简单入门的demo

## 一. [下载与安装](https://github.com/gflags/gflags/blob/master/INSTALL.md)
```
sudo apt install libgflags-dev
```

## 二. gflags的简单使用
### 1. 定义需要的类型  
**格式:** DEFINE\_类型名(变量名, 默认值, 描述语);
|类型|定义格式|
|:--:                   |:--:          |
|bool类型               |DEFINE\_bool  |
|32位的int类型          |DEFINE\_int32 |
|64位的int类型          |DEFINE\_int64 |
|64位的unsigned int 类型|DEFINE\_nint64|
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
> - name变量对应了FLAGS_name;
> - uppercase变量对应了FLAGS_uppercase;
> - count变量对应了FLAGS_count;

## 三. 小小的demo
### 1. .cpp文件的编写
```

```
### 2. CMakeLists.txt文件的编写
```

```

### 3. 编译
```
```
### 4. 运行
```
```

