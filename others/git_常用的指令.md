这个git工具的常用指令,之前已经不止看过一次，看一遍忘一遍，忘一遍看一遍！！！ 俗话说，好记兴不如烂笔头，那就把它们记下来吧。
本文只记录一下我们经常会使用到的git指令，不深入扩展与研究它背后后了什么事情。记住这些，平常工作/学习就基本上够用了。

## git的配置与初始化

当我们通过指令配置git时，其实是把指定的配置内容写入到了配置文件中. git的配置文件分三个级别：
- 系统配置：etc/gitconfig文件, 包含系统上每一个用户及他们仓库的通用配置，如果使用带有 --system 选项的 git config 时，它会从此文件读写配置变量。
- 当前用户的全局配置：~/.gitconfig 或 ~/.config/git/config 文件：只针对当前用户。可以传递 --global 选项让 Git 读写此文件。
- 当前仓库的配置： 配置文件位于当前仓库的.git/config中，它里面的配置内容只对当前的git仓库生效。

现在使用命令行对git进行常规的配置：
````bash
# 配置用户名与邮箱
git config --global user.name "xiaoming"
git config --global user.email china@163.com
# 配置git中使用的编辑器
git config --global core.editor vim
````

上面使用命令行进行了git的global属性的配置，这时候打开~/.gitconig文件，它们是这样的：
````bash
[user]
	name = yinheyi
	email = chinayinheyi@163.com
[core]
	editor = vim
````

## 提交修改到git仓库的过程

### 第一步：新建一个git本地仓库
当在本地手动生成一个git仓库时，进入你要创建仓库的目录，执行以下命令就可以搞定. 对于clone一个已经存在的远程仓库情况，会在本地自动生成一个对应的git仓库,不需要新建. 
````
git init
````

### 第二步：添加至暂存区

跟踪新建的文件或把编辑的文件放到缓存区内，使用指令：
````bash
git add 文件名
````

删除新建的未跟踪文件或目录,使用以下指令：
````
# 删除给定的文件(-f 表示force的意思)
git clean -f 文件名
# 如果要删除目录，需要加上额外的-d参数, 这样即可以删除目录也可以删除文件了
git clean -df 文件名或目录名
# 删除全部文件或目录时，不需要指定文件名或目录名
git clean -d -f
# 如果想进行交互地执行删除操作，使用i参数代替f参数
git clean -d -i
````

取消对已经跟踪文件的修改操作
````bash
git checkout -- 修改的文件名
````

取消跟踪或取消添加到暂存区
````bash
git reset HEAD 文件名
````

### 提交到git仓库 
````bash
# 输入下面指令后会进入写注释信息的窗口，写入信息之后退出就可以
git commit
# 提交的同时写入注释信息
git commit -m "要注释的信息。"
# 省略了add操作，直接进行提交
git commit -a -m "注释信息"
````

## 远程仓库

### 查看远程仓库
- 查看拥有的全部远程仓库的列表：
````bash
git remote
git remote -v
````

- 查看某一个远程仓库的具体信息：
````bash
git remote show <远程仓库的缩写名>
````

### 添加/删除/重命名远程仓库
````bash
git remote add <远程仓库的缩写名>  <远程仓库的url>
git remote remove <远程仓库的缩写名>
````

## 本地分支和远程分支的管理

dssd


**参考资料:** [git在线手册](https://git-scm.com/book/zh/v2)
