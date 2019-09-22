## git clone 通过添加代理加速！
默认情况下，git clone是不走代理的，要手动设置，以debian9为例：
- 方法一：通过命令输入以下命令，其中127.0.0.1是你本地代理的ip, 1080是你自己的端口：  
    git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
    git config --global https.https://github.com.proxy socks5://127.0.0.1:1080
- 方法二： 在～/.gitconfig文件中直接添加以下几行代码：
    [http]
        proxy = socks5://127.0.0.1:1080
    [https]
        proxy = socks5://127.0.0.1:1080
