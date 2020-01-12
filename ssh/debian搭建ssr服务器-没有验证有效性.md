## debian下搭建ssr服务器
1. 软件更新  
  ```
  apt update
  ```
2. BBR配置
  ```
  echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
  ```
3. 配置生效
  ```
  sysctl -p
  ```
4. 安装shadowsocks
  ```
  apt-get install python-pip
  pip install shadowsocks
  ```
5. 配置xiao.json
  ```
{
    "server":"0.0.0.0",
    "server_port":3333,
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"xiaoming",
    "timeout":600
    "method":"aes-256-cfb"
}
  ```
6. 为shadowsocks打补丁  
  ```
  sed -i 's/cleanup/reset/g' /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py
  ```
7. 启动服务
  ```
  ssserver -c xiao.json -d start
  ```

