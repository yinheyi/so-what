## 服务器端
1. 前提： 配置ssr首先需要有一个能访问外网的vps.  
2. 以debian9系统为例说明：  
   - 下载配置脚本ssr.sh：
   ```
   wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssr.sh  
   ```
   - 给配置脚本可执行权限： `chmod +x ssr.sh`  
   - 运行脚本，根据提示信息进行配置： `bash ssr.sh`  

## 客户端(debian9为例)  
1. 下载shadowsocks客户端安装与配置:  
   - 下载shadowsocks客户端并安装： `pip install shadowsocks` 
   - 找一个目录，写一个/.json的配置文件，例如在用户目录创建文件: ～/aabb.json, 内容如下:  
    ```
        {
            "server":"*.*.*.*", 
            "local_address":"127.0.0.1",
            "local_port":1080,
            "server_port":****,
            "password":"***",
            "timeout":300,
            "method":"aes-256-cfb"
        }     
    ```

   - 运行命令：`sudo shadowconfig on`
   - 运行客户端: `sslocal -c ～/aabb.json`. 如果报"EVP_CIPHER_CTX_cleanup"错误，则把`/usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/oppenssl.py文件中的"EVP_CIPHER_CTX_cleanup"替换为"EVP_CIPHER_CTX_reset"就可以了(一共有两处).  
2. 配置本地的代理，让网络从通过127.0.0.1和端口1080经过（即上面配置的json中的本地ip和端口。)  
   - 先配置一个全局代理，点击电脑中的有线设置，手动添加socks主机代理即可。
   - 配置完了全局代理之后，就可以上外网了，这时候呢，打开chrome浏览器，在应用商店中安装SwitchOmega代理，设置它的代理模式和自动切换模式，在自动切换模式中，条件类型自己添加一个规则列表规则,在规则列表设置中的规则列表格式中选择autoproxy, 在规则列表网址中输入`https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt`, 然后立即更新情景模式，最后点击左边的应用选项就可以了。
  - 通过浏览器配置好代理之后，第一步的全局代理就不需要了，删除就行了。现在我可以开心的上网了。
