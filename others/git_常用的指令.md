git工具的常用指令,之前已经不止看过一次，看一遍忘一遍，忘一遍看一遍！！！ 俗话说，好记兴不如烂笔头，那就把它们记下来吧。 本文只记录一下我们经常会使用到的git指令，**不深入扩展与研究它背后后了什么事情**。记住这些，平常工作/学习就基本上够用了。



## **git的配置与初始化**

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

## **提交修改到git仓库的过程**

### **第一步：新建一个git本地仓库**
当在本地手动生成一个git仓库时，进入你要创建仓库的目录，执行以下命令就可以搞定. 对于clone一个已经存在的远程仓库情况，会在本地自动生成一个对应的git仓库,不需要新建. 
````bash
git init
````

### **第二步：添加至暂存区**

- 跟踪新建的文件或把编辑的文件放到缓存区内
````bash
git add 文件名
````

- 删除新建的未跟踪文件或目录
````bash
# 删除给定的文件(-f 表示force的意思)
git clean -f 文件名
# 如果要删除目录，需要加上额外的-d参数, 这样即可以删除目录也可以删除文件了
git clean -df 文件名或目录名
# 删除全部文件或目录时，不需要指定文件名或目录名
git clean -d -f
# 如果想进行交互地执行删除操作，使用i参数代替f参数
git clean -d -i
````

- 取消对已经跟踪文件的修改操作
````bash
git checkout -- 修改的文件名
````

- 取消跟踪或取消添加到暂存区
````bash
git reset HEAD 文件名
````

### **第三步：提交到git仓库**

- 提交时，单独输入注释信息
````bash
git commit
````

- 提交时，在输入指令的同时添加注释信息
````bash
git commit -m "要注释的信息。"
````

- 添加暂存区与提交过程同时进行
````bash
git commit -a -m "注释信息"
````

## **远程仓库**

### **查看远程仓库**
- 查看拥有的全部远程仓库的列表：
````bash
git remote
git remote -v
````
- 查看某一个远程仓库的具体信息：
````bash
git remote show <远程仓库的缩写名>
````

### **添加/删除/重命名远程仓库**
- 添加远程仓库
````bash
git remote add <远程仓库的缩写名>  <远程仓库的url>
````
- 移除一个远程仓库
````bash
git remote remove <远程仓库的缩写名>
````
- 重命名远程仓库
````bash
git remote rename <旧名字> <新名字>
````

### **拉取/推送远程仓库**
- 拉取远程仓库的内容
````bash
git fetch <仓库的名字>
````
- 拉取远程仓库的同时并尝试合并当前的分支
````bash
git pull <仓库的名字>
````
- 把本地仓库的快照推送到远程仓库上
````bash
git push <仓库的名字>
````

## **本地分支管理**
**说明:** 本地分支的名字就是分支名，远程分支的名字是 <仓库名/分支名>.

### **查看分支**
- 查看本地分支
````bash
git branch
git branch --list
bit branch -v
````
- 查看本地分支以及与之绑定的远程分支
````bash
git branch -vv
````

### ** 分支的新建/删除/重命名
- 新建分支
````bash
git branch 新分支名
````
- 删除已经合并的分支,如果没有合并，删除会失败
````bash
git branch -d 分支名
````
- 删除一个分支，即使没有合并，也可以删除成功
````bash
git branch -D 分支名
````
- 重命名分支
````bash
git branch -m <原分支名> <新分支名>
git branch --move <原分支名> <新分支名>
````

### **分支的切换/合并/变基**
- 切换到一个已经存在的分支
````bash
git checkout <要切换到的分支名>
````
- 切换到一个不存在的分支(新建或切换)
````bash
git checkout -b <新分支名>
````
- 把其它分支合并到当前分支
````bash
git merge <其它分支>
````
- 对当前的分支进行变基操作
````bash
git rebash <要变到的基分支名字>
````

## **涉及远程分支相关的管理**

### **新建/删除远程分支**
- 新建远程分支，就是把本地分支推送到远程分支上
````bash
git push <远程仓库名缩写名> <要推送的本地分支名>
````
- 删除远程仓库的分支
````bash
git push <远程仓库的缩写名> --delete <要删除的远程分支名>
````
### **跟踪/解除跟踪 远程分支**
- 新建一个本地分支并跟踪远程分支(远程分支名表示为：<仓库名>/分支名,例如origin/master)
````bash
git checkout -b <新建的本地分支名> <远程分支名>
````
- 如果你想新建的本地分支名与远程分支名相同的话，可以使用以下捷径命令, 前提是本地不存在与远程分支相同的分支名.
````bash
git checkout --trace <远程分支名>
git checkout <**去掉仓库名前缀**的远程分支名>

## 对上面的两个命令举个例子更容易明白
git checkout --trace origin/test
git checkout test
````
- 为已经存在的当前本地分支跟踪添加一个远程跟踪分支
````bash
git branch -u <远程分支名>
git branch --set-upstream-to=<远程分支名>
````
- 为当前分支解除跟踪远程分支
````bash
git branch --unset-upstream
````
----

**参考资料:** [git在线手册](https://git-scm.com/book/zh/v2)

