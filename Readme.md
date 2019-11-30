# 自用的 Oneindex 支持世纪互联

## 运行：

- 使用`docker run`命令运行：

    ```
      docker run -d --name oneindex \
        -p 80:80 --restart=always \
        -v ~/oneindex/config:/var/www/html/config \
        -v ~/oneindex/cache:/var/www/html/cache \
        -e REFRESH_TOKEN='0 * * * *' \
        -e REFRESH_CACHE='*/60 * * * *' \
        -e TOKEN='TOKEN' \
        -e PASS='PASS' \
      hongchenhao/oneindex
    ```

    - 停止删除容器：
        ```
        docker stop oneindex
        docker rm -v oneindex
        ```

- 使用`docker-compose`运行：

    ```
    docker-compose up -d
    ```

    - 停止删除容器：
        ```
        docker-compose down
        ```

## 变量：

- `TZ`：时区，默认`Asia/Shanghai`
- `PORT`：服务监听端口，默认为80
- `DISABLE_CRON`：是否禁用crontab自动刷新缓存，设置任意值则不启用
- `REFRESH_TOKEN`：使用crontab进行token更新，默认`0 * * * *`，即每小时更新一次
- `REFRESH_CACHE`：使用crontab进行缓存更新，默认`*/60 * * * *`，即每10分钟更新一次
- `SSH_PASSWORD`：sshd用户密码，用户名为`root`，若不设置则不启用sshd

## 持久化：

- `/var/www/html/cache`：缓存存储目录
- `/var/www/html/config`：配置文件存储目录
