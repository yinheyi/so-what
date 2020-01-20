## ubunbu系统下google protobuf的安装

**说明:** 使用protobuf时需要安装两部分:  
> 第一部分为\*.proto文件的编译器，它负责把定义的\*.proto文件生成对应的c++类的.h和.cpp文件;
> 第二部分是protobuf的c++动态库(由protobuf的源码编译生成)，该部分在生成链接生成可执行文件时需要使用到。

#### 1. 安装编译google protobuf源文件时需要的依赖文件
```
sudo apt-get install autoconf automake libtool curl make g++ unzip
```

#### 2. 下载google protobuf 的c++对应的源码,并解压至当前目录中
```
wget https://github.com/protocolbuffers/protobuf/releases/download/v3.11.2/protobuf-cpp-3.11.2.tar.gz  
tar -xf protobuf-cpp-3.11.2.tar.gz   
```

#### 3. 进入解压后的目录，并安装
```
./configure
make 
make check
sudo make install
sudo make ldconfig
```

## google protobuf的使用

#### 1. 新建一个表示电话薄的addressbook.proto文件
```
touch addressbook.proto
echo 'syntax = "proto2";
package tutorial;

message Person {
    required string name = 1;
    required int32 id = 2;
    optional string email = 3;

    enum PhoneType {
        MOBILE = 0;
        HOME = 1;
        WORK = 2;
    }

    message PhoneNumber {
        required string number = 1;
        optional PhoneType type = 2 [default = HOME];
    }

    repeated PhoneNumber phones = 4;
}

message Addressbook {
    repeated Person people = 1;
}
' > addressbook.proto
```
#### 2. 使用porotc编译器生成address.proto对应的\*.cpp和\*.h文件,运行以下命令生成了addressbook.pb.cc和addressbook.pb.h文件。
```
protoc addressbook.proto
```
#### 3. 创建两个读与写电话薄的\*.cpp文件，使用google protobuf完成写与读的功能。  
- 写文件：
```
touch write_message.cpp
echo '#include <iostream>
#include <fstream>
#include <string>
#include "addressbook.pb.h"

using namespace std;

void PromptForAddress(tutorial::Person* person) {
    cout << "Enter person ID number: ";
    int id;
    cin >> id;
    person->set_id(id);
    cin.ignore(256, '\n');

    cout << "Enter name: ";
    getline(cin, *person->mutable_name());

    cout << "Enter email address (blank for none): ";
    string email;
    getline(cin, email);
    if (!email.empty())
        person->set_email(email);

    while (true) {
        cout << "Enter a phone number (or leave blank for finish): ";
        string number;
        getline(cin, number);
        if (number.empty())
            break;

        tutorial::Person::PhoneNumber* phone_number = person->add_phones();
        phone_number->set_number(number);

        cout << "Is this a mobile, home, or work phone? ";
        string type;
        getline(cin, type);
        if (type == "mobile")
            phone_number->set_type(tutorial::Person::MOBILE);
        else if (type == "home")
            phone_number->set_type(tutorial::Person::HOME);
        else if (type == "work")
            phone_number->set_type(tutorial::Person::WORK);
        else
            cout << "Unkown phone type. Using default. " << endl;
    }
}

int main(int argc, char* argv[]) {
    GOOGLE_PROTOBUF_VERIFY_VERSION;

    if (argc != 2) {
        cerr << "Usage: " << argv[0] << "ADDRESS_BOOK_FILE " << endl;
        return -1;
    }

    tutorial::Addressbook address_book;
    
    fstream input(argv[1], ios::in | ios::binary);
    if (!input)
        cout << argv[1] << ": File not found. Creating a new file. " << endl;
    else if (!address_book.ParseFromIstream(&input)) {
        cerr << "Failed to parse address book. " << endl;
        return -1;
    }

    PromptForAddress(address_book.add_people());

    fstream output(argv[1], ios::out | ios::trunc | ios::binary);
    if (!address_book.SerializeToOstream(&output)) {
        cerr << "Failed to write address book. " << endl;
        return -1;
    }

    google::protobuf::ShutdownProtobufLibrary();
    return 0;
}
' > write_message.cpp
```

- 读文件：
```
touch read_message.cpp
echo '#include <iostream>
#include <fstream>
#include <string>
#include "addressbook.pb.h"

using namespace std;

void ListPeople(const tutorial::Addressbook& address_book) {
    for (int i = 0; i < address_book.people_size(); ++i) {
        const tutorial::Person& person = address_book.people(i);

        cout << "Person ID: " << person.id() << endl;
        cout << "Name: " << person.name() << endl;
        if (person.has_email()) {
            cout << " E-mail address: " << person.email() << endl;
        }

        for (int j = 0; j < person.phones_size(); ++j) {
            const tutorial::Person::PhoneNumber& phone_number = person.phones(j);
            switch (phone_number.type()) {
                case tutorial::Person::MOBILE:
                    cout << " Mobile phone#: ";
                    break;
                case tutorial::Person::HOME:
                    cout << " Home phone#: ";
                    break;
                case tutorial::Person::WORK:
                    cout << " Work phone#: ";
                    break;
            }
            cout << phone_number.number() << endl;
        }
    }
}

int main(int argc, char** argv) {
    GOOGLE_PROTOBUF_VERIFY_VERSION;
    if (argc != 2) {
        cerr << "Usage: " << argv[0] << "ADDRESS_BOOK_FILE " << endl;
        return -1;
    }

    tutorial::Addressbook address_book;
    fstream input(argv[1], ios::in | ios::binary);
    if (!address_book.ParseFromIstream(&input)) {
        cerr << "Failed to parse address book. " << endl;
        return -1;
    }

    ListPeople(address_book);

    google::protobuf::ShutdownProtobufLibrary();
    return 0;
}
' > read_message.cpp
```

#### 4. 分别编译write_message.cpp文件和read_message.cpp文件(*其中pkg-config命令可以输出关于protobuf动态库相关的编译时的参数*)
```
g++ write_message.cpp addressbook.pb.cc -o write.out $(pkg-config --cflags --libs protobuf)
g++ read_message.cpp addressbook.pb.cc -o read.out $(pkg-config --cflags --libs protobuf)
```

#### 5. 分别运行write.out和read.out文件进行写与读操作
```
./write.out result.protobuf
./read.out result.protobuf
```
