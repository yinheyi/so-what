## [glog](https://github.com/google/glog)

### 一. 下载与安装
```
git clone https://github.com/google/glog.git
cd glog
./autogen.sh
./configure
make
make check
make install
```
### 二.glog简单的使用说明
#### 1. log的严重等级

|等级描述|对应的等级数字|
|:---:|:---:|
|INFO|0|
|WARNING|1|
|ERROR|2|
|FATAL|3|

- 每一个等级都有一个对应的log输出文件，默认文件名为(包含文件路径) 为：`/tmp/<program name>.<hostname>.<user name>.log.<severity level>.<date>.<time>.<pid>`
- 对于高严重的等级，不仅会把相应的log信息输出到对应到等级文件中，还会输出到比它更的log文件中, 例如对于ERROR等级的log,不仅会输出到ERROR的文件中，还会输出到INFO和WARNING的文件中。
- 对于ERROR和FATAL等级，不仅仅会把相关的log信息输出到对应的文件中，还会把log信息输出到standard error中, 默认就是屏幕上。
- 在release模式下，当产生了FATAL等级的log信息时，程序会被终止掉，在debug模式下，会自动把FATAL等级降至到ERROR等级, 也就是不会终止程序。

使用方法：
```
// 输出INFO等级的log信息。
LOG(INFO) << "This is INFO severity log information. ";
// 输出WARNING等级的log信息。
LOG(WARNING) << "This is WARNING severity log information. ";
// 输出ERROR等级的log信息。
LOG(ERROR) << "This is ERROR severity log information. ";
// 输出FATAL等级的log信息。
LOG(FATAL) << "This is FATAL severity log information. ";
```

#### 2. 使用gflags在命令行中设置一些flag位.
在安装glog时，如果你的电脑中已经安装了gfalgs库的话， 在编译时，它会自动使用gflags库，然后呢，当你使用glog库时，就可以使用gflags库的命令行特性了。（需要在main函数的开始处加上对gflags的初始化代码`gflags::ParseCommandLineFlags(&argc, &argv, true)`). 常使用到flags包含(更详细看一下logging.cc文件)： 
- logtostderr(bool类型): 把日志信息输出到stderr中，而不是文件中。 （在命令行中使用`--logtostderr=true 或 --logtostderr=false`)
- stderrthreshold(int类型): 把严重等级>=指定等级的log信息额外输出到stderr中(默认为2,即ERROR和FATAL)
- minloglevel (int 类型): 只有当严重等级>=指定等级时，会进行log的输出。 

#### 3. Conditional/Occasional Logging 
- LOG_IF(等级描述, 条件) << "日志信息";             当条件满足时，才会打印日志。
- LOG_EVERY_N(等级描述, n) << "日志信息";           每n次会打印一条日志。
- LOG_IF_EVERY_N(等级描述, 条件, n) << "日志信息."; 当条件成立时，每n次打印一条日志。
- LOG_FIRST_N(等级描述, n) << "日志信息。";         当打印前n次的日志信息。

#### 4. debug 模式的支持
下面定义的宏只会在debug模式下起作用，在release模式下无效，这样可以避免在release版本下打印日志影响运行速度。
- DLOG(等级描述) << "日志信息。";
- DLOG_IF(等级描述, 条件) << "日志信息";
- DLOG_EVERY_N(等级描述, n) << "日志信息";

#### 5. CHECK 宏的使用
CHECK宏提供了一种机制：当条件不满足时，程序直接终止掉, 类似于ASSERT宏。

|宏的名字|作用|
|:---:|:---:|
|CHECK_EQ(a,b)|检测a与b是否相等|
|CHECK_NE(a,b)|检测a与b是否不相等|
|CHECK_LE(a,b)|检测a是否小于或等于b|
|CHECK_LT(a,b)|检测a是否小于b|
|CHECK_GE(a,b)|检测a是否大于或等于b|
|CHECK_GT(a,b)|检测a是否大于b|
|CHECK_NOTNULL(指针)|检测指针不为空，它的返回值是传给它的指针. 该宏不能像c++的输出流那样使用|

使用方法:
```
CHECK_EQ(a,b) << " 当a与b不相等时，程序会中止运行，并打印出该条目志信息。";
```
**特别注意:**当指针与NULL进行比较时，编译器会报错，因为把NULL认为是0。 如果不想报错，需要把NULL强转换为指针类型(static_cast<指针类型>(NULL).

#### 6. 用户自己定义Failure Function
当产生FATAL的日志信息或CHECK宏检测失败时，程序就会终止掉，默认情况下glog会dump出堆栈的相关信息并以错误码1退出程序的运行，我们可以注册自定义的函数来运行你想要的函数。
```
// 第一步：定义自己的Failure函数
void MyFailureFunction()
{
    /*
     添加自己的代码。
     */
    exit(1);
}

// 第二步，在main函数的开始部分，加入一行如下代码:
int main(int argc, char* argv[])
{
    /*
       其它初始化代码。
     */
    google::InstallFailureFunction(&MyFailureFunction);
}
```

#### 7. Failure Signal Handler
可以自定义一些信号捕捉函数，然后通过`google::InstallFailureSignalHandler()`函数来注册一下。具体没有深入研究。

### 三. 运行小小的demo
#### 1. 创建文件glog_demo.cpp文件,内容如下：
```
#include <glog/logging.h>

int main(int argc, char** argv) {
    gflags::ParseCommandLineFlags(&argc, &argv, true);
    google::InitGoogleLogging(argv[0]);
    LOG(INFO) << "This is INFO log information";
    LOG(WARNING) << "This is WARNING log information";
    LOG(ERROR) << "This is ERROR log information";
    //LOG(FATAL) << "This is FATAL log information";

    LOG_IF(INFO, 1 < 2) << "This is true: 1 < 2. ";
    for (int i = 0; i < 100; ++i)
    {
        LOG_EVERY_N(INFO, 10) << "Log every 10 times. ";
    }

    CHECK(1 < 2) << "The world is end, because one is not less than  2. ";
    return 0;
}
```

#### 2. 编译并运行
```
g++ glog_demo.cpp -o a.out -pthread -lgflags -lglog
./a.out glog_demo.cpp --logtostderr=true
```
