# 构建Nuxt-Docker说明
构建基于docker的nuxt运行容器需要实时构建镜像
将Nuxt项目上传到当前目录
将目录中的`Dockerfile`与`build.sh`文件拷贝到项目根目录，执行
```
chmod +x build.sh
./build.sh
```