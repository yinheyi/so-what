#! /bin/bash

# 1. 使用aliyun的镜像网站
echo -e "\033[31m 正在修改aliyun的镜像网站. \033[0m"
if [ -f /etc/apt/sources.list ]; then
	mv /etc/apt/sources.list /etc/apt/sources.list.bp
else
	echo -e "\033[31m /etc/apt/sources.list file is not exists. \033[0m"
fi
echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
" > /etc/apt/sources.list
if [ $? -eq 0 ]; then
    echo -e "\033[32m 更换阿里云的镜像地址成功。\033[0m"
else
    echo -e "\033[31m 更换阿里云的镜像地址失败。\033[0m"
fi

# 2. install vim
echo -e "\033[32m 正在安装vim.... \033[0m"
apt install vim
if [ $? -eq 0 ]; then
    echo -e "\033[32m 安装vim成功。\033[0m"
else
    echo -e "\033[31m 安装vim失败。\033[0m"
fi

# 3. 安装 chrome浏览器
echo -e "\033[32m 正在安装chrome浏览器.... \033[0m"
wget -O ~/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
if [ ! -f ~/chrome.deb ]; then
    echo -e "\033[31m 下载chrome浏览器失败。 \033[0m"
else
    dpkg -i ~/chrome.deb
    if [ $? -ne 0 ]; then
        echo -e "\033[31m 安装chrome时的依赖不满足，接下来使用'apt install -f'指令安装相关信赖... \033[0m"
        apt install -f
        echo -e "\033[32m 正在重装安装chrome浏览器...  \033[0m"
        dpkg -i ~/chrome.deb
    fi
    if [ $? -eq 0 ]; then
        echo -e "\033[32m 安装chrome浏览器成功。 \033[0m"
    else
        echo -e "\033[31m 安装chrome浏览器失败。 \033[0m"
    fi
    rm ~/chrome.deb
fi

# 4. 安装git
echo -e "\033[32m 正在安装git..... \033[0m"
apt install git
echo -e "\033[32m git安装成功..... \033[0m"

# 5. 
