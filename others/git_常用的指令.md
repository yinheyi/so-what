这个git工具的常用指令,之前已经不止看过一次，看一遍忘一遍，忘一遍看一遍！！！ 俗话说，好记兴不如烂笔头，那就把它们记下来吧。
本文只记录一下我们经常会使用到的git指令，不深入扩展与研究。记住这些，平常工作/学习就基本上够用了。

## git的配置与初始化

当我们通过指令配置git时，其实是把指定的配置内容写入到了配置文件中. git的配置文件分三个级别：
- etc/gitconfig文件, 包含系统上每一个用户及他们仓库的通用配置，如果使用带有 --system 选项的 git config 时，它会从此文件读写配置变量。
- ~/.gitconfig 或 ~/.config/git/config 文件：只针对当前用户。可以传递 --global 选项让 Git 读写此文件。
- 当前使用仓库的 Git 目录中的 config 文件（就是 .git/config）：针对该仓库。

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
第一步：让git跟踪新添加或新编辑的文件


## 远程仓库

dssd

## 本地分支和远程分支的管理

dssd


