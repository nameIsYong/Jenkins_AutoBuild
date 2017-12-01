#蒲公英
User_Key="xxxxxxxxxx"
API_Key="xxxxxxxxxx"
#CD到jenkins的工作目录
cd /Users/zc/.jenkins/workspace/YDL_IOS_Dev/ydl

selfpath=$(cd "$(dirname "$0")"; pwd)
echo '当前路径--->'$selfpath
#工程名
project_name=ydl

#打包模式Debug/Release
development_mode=Debug

#scheme名
scheme_name=ydl

#plist文件所在路径
exportOptionsPlistPath=${selfpath}/DevelopmentExportOptionsPlist.plist

ipaName=ydl_`date '+%Y_%m_%d_%H_%M_%S'`  
#导出.ipa文件所在路径
exportFilePath=${selfpath}/$ipaName-ipa

#echo '*** 正在 清理工程 ***'
#xcodebuild \
#clean -configuration ${development_mode} -quiet  || exit 
#echo '*** 清理完成 ***'


echo '*** 正在 编译工程 For '${development_mode}
xcodebuild archive -project ${project_name}.xcodeproj -scheme ${project_name} -archivePath build/${project_name}.xcarchive -quiet  || exit
echo '*** 编译完成 ***'

echo '*** 正在 打包 ***'
xcodebuild -exportArchive -archivePath build/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportFilePath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-quiet || exit

# 删除build包
if [[ -d build ]]; then
    rm -rf build -r
fi

if [ -e $exportFilePath/$scheme_name.ipa ]; then

    ipaPath=$exportFilePath'/'$scheme_name.ipa
    echo '*** .ipa文件已导出 ***>'$ipaPath
    cd ${exportFilePath}
    echo "*** 开始上传.ipa文件 ***"

    RESULT=$(curl -F "file=@$ipaPath" -F "uKey=$User_Key" -F "_api_key=$API_Key" -F "publishRange=2" http://www.pgyer.com/apiv1/app/upload)

    echo "*** .ipa文件上传成功 ***"
    echo $RESULT
else
    echo "*** 创建.ipa文件失败 ***"
fi
echo '*** 打包完成 ***'

