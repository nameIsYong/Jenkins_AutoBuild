把整个AutoBuild文件拷贝到和 .xcodeproj文件同级目录
plist文件不用做改动，只需要改动shell文件的下面几个配置即可。

#1 蒲公英
User_Key="xxxxxxxxxx"
API_Key="xxxxxxxxxx"


#2 CD到jenkins的工作目录
cd /Users/zc/.jenkins/workspace/YDL_IOS_Dev/ydl
selfpath=$(cd "$(dirname "$0")"; pwd)
echo '当前路径--->'$selfpath


#3 工程名
project_name=ydl

#4 打包模式Debug/Release
development_mode=Debug

#5 scheme名
scheme_name=ydl
