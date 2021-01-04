数据结构之c++STL容器库

> 作者：殷和义
>
> 时间：2021年1月

----

[toc]

##  一、分类

在STL中把容器分成了三类，分别为：**顺序容器**、**关联容器**、**无序关联容器**。

- 顺序容器：array（c++11）、vector、deque、list、forward_list(单链表，c++11).
- 关联容器：set、multiset、map、multimap.
- 无序关联容器(c++11）：unordered_set、unordered_multiset、unordered_map、unordered_multimap.

另外，还有**容器适配器**， 包含stack、queue和priority_queue. 它们的底层实现基于顺序容器。

但是，我比较习惯根据底层的数据结构分成以下三类：**数组型容器**、**树型容器**和**哈希型容器**。

- 数组型容器：array、vector、deque.
- 树型容器: list、forward_list、set、multiset、map、multimap.
- 哈希型容器：unordered_set、unordered_multiset、unordered_map、unordered_multimap.



## 二、数组型容器

###  1. C风格数组

````c
int array[10];  // 一个连续的元素个数为10的的数组
````

### 2. c++的array（c++11起）

 静态的连续数组 ， 使用模板类对C风格的数组进行了封装，声明原型：

````c++
template<class T,std::size_t N> struct array;
````

#### 2.1 成员函数

- 元素访问

  ````c++
  .at
  .operator[]
  .front
  .back
  .data
  ````

- 迭代器

  ````c++
  .begin
  .end
  .cbegin
  .cend
  .rbegin
  .rend
  .crbegin
  .crend
  ````

  

- 容量

  ````
  .empty
  .size
  .max_size
  ````

### 3. vector

内存连续分布，迭代器类型为 RandomIterator、随机访问，快速尾部插入与删除，中间或头部插入与删除效率很低且迭代器失效。空间不足时，重新找一块空间，两倍扩展，内部元素变少时，空间不会自动缩减。**迭代器或元素指针非常容易失效，没事别保存**。

#### 3.1 空间布局

````c++
就是连续的内存布局：
[][][][][][][][][][][][][][][][]
````

1. 假如初始空间为4， 它的内存空间为4：

   `1 2 3 4`

2.  接下来，push_back进2个元素，它会重新找一块内存空间，大小扩展为8，拷贝原有数据，并添加新数据：

   ` 1 2 3 4 5 6 _ _`

3.  接下来，再push_back进入3个元素，它又会重新找一块内存空间，大小扩展为16，拷贝原有数据，并添加新数据

   `1 2 3 4 5 6 7 8 9 _ _ _ _ _ _ _ ` 

4.  接下来，pop_back掉8个元素，内存空间仍然为16，但是只保存了一个元素：

   `1 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _`

#### 3.2  成员函数

- 元素访问

  ````c++
  .at
  .operator[]
  .front
  .back
  .data
  ````

- 迭代器

  ````c++
  .begin
  .end
  .cbegin
  .cend
  .rbegin
  .rend
  .crbegin
  .crend
  ````

- 容量

  ````c++
  .empty
  .size
  .max_size
  .reserve
  .capacity
  .shrink_to_fit
  ````

- 修改

  ````c++
  .clear
  .insert
  .emplace(c++11)
  .erase
  .push_back
  .emplace_back
  .pop_back
  .resize
  .swap
      
  ````

### 4. deque

 内存分段连续分布，迭代器类型为 RandomIterator（实现有些复杂）、随机访问，允许在其首尾两段快速插入及删除 ，中间推入或删除元素效率很低，并且导致迭代器失效。与vector相比，访问deque内部元素时需要二次引用 ， 内存扩张时比vector更优，不涉及到复制既存元素到新内存位置.

#### 4.1 内存布局

内存呈现分段的连续分布，大致是这样的：

````c++
索引空间
|____|
|索引0|   ----->      [--------连续储存空间------------]
|索引1|   ----->      [--------连续储存空间------------]
|索引2|   ----->      [--------连续储存空间------------]
| .  |
| .  |
| .  |
|索引n|    ----->     [---------连续储存空间-----------]
|————|
````

#### 4.2 成员函数

- 元素访问

  ````c++
  .at
  .operator[]
  .front
  .back
  .data
  ````

- 迭代器

  ````c++
  .begin
  .end
  .cbegin
  .cend
  .rbegin
  .rend
  .crbegin
  .crend
  ````

- 容量

  ````c++
  .empty
  .size
  .max_size
  .reserve
  .capacity
  .shrink_to_fit
  ````

- 修改

  ````c++
  .clear
  .insert
  .emplace(c++11)
  .erase
  .push_back
  .emplace_back
  .pop_back
  .push_front      // 比vector多出来的
  .emplace_front   // 比vector多出来的
  .pop_front       // 比vector多出来的
  .resize
  .swap
  ````



## 三、二叉树

### 1. 普通二叉树

   ````c++
                     100
                     /  \
                   51    42
                   /    /  \
                  76   14   25
                         \
                          69
   ````

二叉树的前序、中序、后序遍历的递归与循环代码实现：

[https://github.com/yinheyi/introduction-to-algorithms/blob/master/数据结构/6-二叉树.cpp](https://github.com/yinheyi/introduction-to-algorithms/blob/master/%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/6-%E4%BA%8C%E5%8F%89%E6%A0%91.cpp)

### 2. 特殊的二叉树

  ```c++
                     100
                     / 
                    21 
                   /   
                  -3 
                 /
                4
               /
              45
       
  退化为链表：100--- 21 --- -3 --- 4 --- 45                  
  ```

### 3. 二叉搜索树

当二叉树的父结点大于等于左子树的任意节点，并且父结点小于等于右子树的任意节点，为二叉搜索树。插入与删除元素的时间复杂度为O(h)， 其中h表示树高。

  ````c++
                     100
                     /  \
                   51   142
                   /    /  \
                  16   101  225
                         \
                          133
                          /
                        120
  ````

二叉搜索树的查找、插入与删除操作的代码实现：

[https://github.com/yinheyi/introduction-to-algorithms/blob/master/数据结构/7-二叉搜索树.cpp](https://github.com/yinheyi/introduction-to-algorithms/blob/master/%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/7-%E4%BA%8C%E5%8F%89%E6%90%9C%E7%B4%A2%E6%A0%91.cpp)

  ### 4. 平衡二叉搜索树

  二叉搜索树的左右子树的高度差增加限制，防止左右子树高度差不受控，导致插入与删除元素的时间复杂度退化为O(n)。常见的平衡二叉搜索树有VAL树和红黑树。

  

### 5. AVL树

在二叉搜索树上增加了额外的平衡条件：**任何节的左右子树高度相差最多为1**.

  ````
                     100
                     /  \
                   51   142
                   /    /  \
                  16   101  225
                         \
                          133
  
  ````

与单纯的二叉搜索树相比，AVL树的插入与删除操作复杂一些，涉及到单旋与双旋操作用于修正不平衡性。

AVL树的查找、插入与删除操作的代码实现：

[https://github.com/yinheyi/introduction-to-algorithms/blob/master/数据结构/8-AVL树.cpp](https://github.com/yinheyi/introduction-to-algorithms/blob/master/%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/8-%E5%B9%B3%E8%A1%A1%E4%BA%8C%E5%8F%89%E6%90%9C%E7%B4%A2%E6%A0%91.cpp)


### 6. 红黑树

在二叉搜索树上,红黑树以下四条原则：

  1. 每一个节点不是红色就是黑色
  2. 根结点为黑色
  3. 如果节点为红色，子节点必须为黑色
  4. 任一节点到尾节点的任何路径中，所包含的黑节点必须相同。

  ````
                     100
                     /  \
                   51   142
                   /    /  \
                  16   101  225
                         \
                          133
  ````

与AVL二树相比，红黑树的插入与删除操作又复杂一些，不仅涉及到单旋与双旋操作，还增加了变色操作，用于修正不平衡性。红黑树的查找、插入与删除的代码实现：

[https://github.com/yinheyi/introduction-to-algorithms/blob/master/数据结构/红黑树/RBTree.cpp](https://github.com/yinheyi/introduction-to-algorithms/blob/master/%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E7%BA%A2%E9%BB%91%E6%A0%91/RBTree.cpp)


## 四、树型容器

###　1. list

双向链表，迭代器类型为Bidirectional Iterator,  支持常数时间从容器任何位置插入和移除元素的容器。不支持快速随机访问。 插入与删除操作不会使迭代器失效。

#### 1.1 空间布局

 ````c++
[元素0]   ------->   [元素1]   ------->  [元素1]  ------->  [元素2]
         <-------            <-------           <-------
 ````

#### 1.2 成员函数

- 元素访问

  ````c++
  .front
  .back
  ````
  
- 迭代器

  ````c++
  .begin
  .end
  .cbegin
  .cend
  .rbegin
  .rend
  .crbegin
  .crend
  ````

- 容量

  ````c++
  .empty
  .size
  ````
  
- 修改

  ````c++
  .clear
  .insert
  .emplace(c++11)
  .erase
  .push_back
  .emplace_back(c++11)
  .pop_back
  .push_front      // 比vector多出来的
  .emplace_front   // 比vector多出来的
  .pop_front       // 比vector多出来的
  .resize
  .swap
  ````

- 操作

  ````
  .merge
  .splice
  .remove
  .remove_if
  .reverse
  .unique
  .sort
  ````

###　2. forward+list

单向链表，迭代器类型为Forward Iterator,  支持常数时间从容器任何位置插入和移除元素的容器。不支持快速随机访问。 插入与删除操作不会使迭代器失效。

#### 2.1 空间布局

 ````c++
[元素0]   ------->   [元素1]   ------->  [元素2]  ------->  [元素3]
 ````

####　2.2 成员函数

- 元素访问

  ````c++
  .front
  ````
  
- 迭代器

  ````c++
  .before_begin
  .cbefore_begin
  .begin
  .cbegin
  end
  cend
  ````
  
- 容量

  ````c++
  .empty
  .size
  ````
  
- 修改

  ````c++
  .clear
  .insert_after
  .emplace_after
  .erase_after
  .push_front      // 比vector多出来的
  .emplace_front   // 比vector多出来的
  .pop_front       // 比vector多出来的
  .resize
  .swap
  ````
  
- 操作

  ````
  .merge
  .splice_after
  .remove
  .remove_if
  .reverse
  .unique
  .sort
  ````
  

### 3. set

底层实现为红黑树，红黑树的每一个节点中只保存了key值，并且key值不重复。使用红黑树时，与生俱带了一个特点：元素是有序的。查找、插入与删除的时间复杂度为O(nlogN).

#### 3.1 成员函数

- 迭代器

  ````c++
  .begin
  .cbegin
  .end
  .cend
  .rbegin
  .crbegin
  .rend
  .crend
  ````

- 容量

  ````
  .empty
  .size
  .max_size
  ````

- 修改

  ````c++
  .clear
  .insert
  .emplace
  .emplace_hint
  .erase
  .swap
  ````

- 查找

  ````c++
  .count
  .find
  .contains
  .equal_range
  .lower_bound
  .upper_bound
  ````

### 4. multiset

底层实现为红黑树，红黑树的每一个节点中只保存了key值，key值允许重复。元素有序.  查找、插入与删除的时间复杂度为O(nlogN).

#### 4.1 成员函数

- 迭代器

  ````c++
  .begin
  .cbegin
  .end
  .cend
  .rbegin
  .crbegin
  .rend
  .crend
  ````

- 容量

  ````
  .empty
  .size
  .max_size
  ````

- 修改

  ````c++
  .clear
  .insert
  .emplace
  .emplace_hint
  .erase
  .swap
  ````

- 查找

  ````c++
  .count
  .find
  .contains
  .equal_range
  .lower_bound
  .upper_bound
  ````

### 5. map

底层实现为红黑树，红黑树的每一个节点中保存了key值与value值，并且key值允许不重复。使用红黑树时，与生俱带了一个特点：元素是有序的。查找、插入与删除的时间复杂度为O(nlogN).

#### 5.1 成员函数

- 元素访问

  ````c++
  .at
  .operator[]
  ````

  

- 迭代器

  ````c++
  .begin
  .cbegin
  .end
  .cend
  .rbegin
  .crbegin
  .rend
  .crend
  ````

- 容量

  ````
  .empty
  .size
  .max_size
  ````

- 修改

  ````c++
  .clear
  .insert
  .emplace
  .emplace_hint
  .erase
  .swap
  ````

- 查找

  ````c++
  .count
  .find
  .contains
  .equal_range
  .lower_bound
  .upper_bound
  ````

### 6. multimap

底层实现为红黑树，红黑树的每一个节点中只保存了key值，key值允午重复。元素有序。查找、插入与删除的时间复杂度为O(nlogN).

#### 6.1 成员函数

- 迭代器

  ````c++
  .begin
  .cbegin
  .end
  .cend
  .rbegin
  .crbegin
  .rend
  .crend
  ````

- 容量

  ````
  .empty
  .size
  .max_size
  ````

- 修改

  ````c++
  .clear
  .insert
  .emplace
  .emplace_hint
  .erase
  .swap
  ````

- 查找

  ````c++
  .count
  .find
  .contains
  .equal_range
  .lower_bound
  .upper_bound
  ````



## 五、哈希型容器

哈希型空间底层实现使用hash函数对key进行散列成hash值，进而放入对应的哈希桶中进行存储。实现时间复杂度为O(1)的查找、查找与删除操作。unordered_set、unordered_multiset、unordered_map、unordered_multimap的底层实现原理都是相同的。与底层为红黑树的实现不同点是：元素无序，查找、插入与删除的时间复杂度为O(1).

### 1. unordered_set

#### 1.1 成员函数

- 迭代器

  ````c++
  .begin
  .cbegin
  .end
  .cend
  ````

- 容量

  ````c++
  .empty
  .size
  .max_size
  ````

- 修改

  ````c++
  .clear
  .insert
  .emplace
  .erase
  .swap
  ````

- 查找

  ````c++
  .count
  .find
  .contains
  .equal_range
  ````

- 桶接口

  ````c++
  .bucket_count
  .max_bucket_count
  .bucket_size
  .bucket
  ````

### 2. unordered_multiset

#### 2.1 成员函数

- 迭代器

  ````c++
  .begin
  .cbegin
  .end
  .cend
  ````

- 容量

  ````c++
  .empty
  .size
  .max_size
  ````

- 修改

  ````c++
  .clear
  .insert
  .emplace
  .erase
  .swap
  ````

- 查找

  ````c++
  .count
  .find
  .contains
  .equal_range
  ````

- 桶接口

  ````c++
  .bucket_count
  .max_bucket_count
  .bucket_size
  .bucket
  ````
  

### 3. unordered_map

#### 3.1 成员函数

- 迭代器

  ````c++
  .begin
  .cbegin
  .end
  .cend
  ````

- 容量

  ````c++
  .empty
  .size
  .max_size
  ````

- 修改

  ````c++
  .clear
  .insert
  .emplace
  .erase
  .swap
  ````

- 查找

  ````c++
  .at
  .operator[]
  .count
  .find
  .contains
  .equal_range
  ````

- 桶接口

  ````c++
  .bucket_count
  .max_bucket_count
  .bucket_size
  .bucket
  ````

### 4. unordered_multimap

#### 4.1 成员函数

- 迭代器

  ````c++
  .begin
  .cbegin
  .end
  .cend
  ````

- 容量

  ````c++
  .empty
  .size
  .max_size
  ````

- 修改

  ````c++
  .clear
  .insert
  .emplace
  .erase
  .swap
  ````

- 查找

  ````c++
  .count
  .find
  .contains
  .equal_range
  ````

- 桶接口

  ````c++
  .bucket_count
  .max_bucket_count
  .bucket_size
  .bucket
  ````

## 六、容器适配器

STL中有三种适配器，stack、queue和priority_queue. 它们的底层实现都是基于顺序容器（vector、list、deque等），仅提供不同的操口。

### 1. stack

栈，先进后出。底层基于vector、list、deque都可以实现。

#### 1.1 成员函数

- 元素访问

  ````c++
  .top
  ````

- 容量

  ````c++
  .empty
  .size
  ````

- 修改

  ````
  .push
  .emplace
  .pop
  ````

### 2. queue

队列，先进先出，底层基于list、deque可以实现。

#### 2.1 成员函数

- 元素访问

  ````
  .front
  .back
  ````

- 容量

  ````
  .empty
  .size
  ````

- 修改

  ````
  .push
  .emplace
  .pop
  ````

### 3. priority_queue

优先队列， 它提供常数时间的最大（小）元素查找，对数代价的插入与释出。 底层实现基于vector容器 + 最大（小）堆数据结构。

#### 3.1 最大（小）堆

最大（小）堆，可以看作一个完全二叉树，父节点大于等于左右子节点的值。底层使用array或vector来存储。

````c++
                                 16
                               /    \
                             14      10
                           /    \    /  \
                          8      7  9    3
                         / \   /
                        2   4  1
                        
    对应的vector为： 16、14、10、8、7、9、3、2、4、1.
````

堆中父子节点的索引关系：

- leftChild = parent * 2 + 1
- rightChild = parent * 2 + 1
- parent = (child - 1) / 2

最大（小）堆的操作包含建堆、插入、删除以及获取堆顶元素，不复杂。代码实现：
[https://github.com/yinheyi/introduction-to-algorithms/blob/master/数据结构/红黑树/5-最大堆和最小堆.cpp](https://github.com/yinheyi/introduction-to-algorithms/blob/master/%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/5-%E6%9C%80%E5%A4%A7%E5%A0%86%E5%92%8C%E6%9C%80%E5%B0%8F%E5%A0%86.cpp)


#### 3.2 成员函数

- 元素访问

  ````
  .top
  ````

- 容量

  ````
  .empty
  .size
  ````

- 修改

  ````
  .push
  .emplace
  .pop
  ````

  
