# KMP算法
----

[TOC]

----

## 一.  应用场景

给定原字符串A, 查找字符串A中是否包含字符串B. 例如:

> 在字符串A"aassddaassffaa"中查找是否包含字符串B"aassf" ?

## 二.  KMP算法

核心思想: 略 (去百度,写出来太浪费时间了)

## 三.  代码实现

````c++
// 第一步：求模式字符串的最长公共前后缀。
void GetPublicPrePostFix(const string& str, vector<int>& output) {
    output.resize(str.size(), 0);
    for (size_t i = 1; i < str.size(); ++i) {
        // 找到那一个可能的最长公共前后缀
        int preFixLength = output[i - 1];
        while (preFixLength != 0 && str[preFixLength] != str[i]) {
            preFixLength = output[output[preFixLength - 1]];
        }
        output[i] = preFixLength + (str[preFixLength] == str[i] ? 1 : 0);
    }
}

// 第二步：在原字符串中查找是否存在模式串
bool hasSubStr(const string& origin, const string& pattern) {

    vector<int> table;
    GetPublicPrePostFix(pattern, table);

    int index = 0;
    for (size_t i = 0; i < origin.size(); ++i) {
        // 找到那个与第i元素相同的下标index, 或者index=0
        while (index > 0 && origin[i] != pattern[index]) {
            index = table[index - 1];
        }
        // 更新index,变成下一轮要对比位置下标。
        if (origin[i] == pattern[index]) {
            index += 1;
        }
        if (index == pattern.size()) {
            return true;
        }
    }
    return false;
}
````

