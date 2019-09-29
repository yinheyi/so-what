## 服务端
1. 编辑sysctl.conf文件，在末尾添加两行：
```
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
```
2. 使第一步的配置生效
`sudo sysctl -p`
3. 下载安装脚本并运行,此时生成端口号和UUID,要记下来:
```
wget https://install.direct/go.sh
bash go.sh
```
4. 安装iptables-persistent,打开服务器的服务端口号。
```
apt install iptables-persistent
iptables -vnL
iptables -A INPUT -p tcp --dport 12345(这是你生成的端口号) -j ACCEPT
iptables -vnL
sudo dpkg-reconfigure iptables-persistent
```
5. 启动v2ray服务
```
systemctl enable v2ray
systemctl start v2ray
```
6. 查看v2ray的运行状态
```
systemctl status v2ray
netstat -tulpn
```

## 客户端
1. 访问<https://github.com/v2ray/v2ray-core/releases>下载v2ray-linux-64.zip发行版.
2. 解压v2ray-linux-64-zip，并进入目录：
```
unzip -o v2ray-linux-64-zip -d my_v2ray
cd my_v2ray
```
3. 建立配置文件myconfigure.json, 内容如下：
```
{
  "inbounds": [{
    "port": 10808(代理端口), 
    "listen": "127.0.0.1(代理IP)",
    "protocol": "socks",
    "settings": {
      "udp": true
    }
 }],
 "outbounds": [{
   "protocol": "vmess",
   "settings": {
   "vnext": [{
     "address": "服务器ip", 
     "port": 服务器设置的端口,
     "users": [{ "id": "YOUR-UNIVERSALLY-UNIQUE-ID" }]
   }]
   }
   },{
     "protocol": "freedom",
     "tag": "direct",
     "settings": {}
    }],
    "routing": {
      "domainStrategy": "IPOnDemand",
      "rules": [{
        "type": "field",
        "ip": ["geoip:private"],
        "outboundTag": "direct"
      }]
    }
}

```
4. 运行
```
./v2ray -config=myconfigure.json
```

5. 然后再配置代理就可以了。
