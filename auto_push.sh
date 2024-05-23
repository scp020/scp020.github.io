#!/bin/bash

:<<!

作者：scp020
版本：1.1.0
时间：2024.5.21
版本更新：无

!

# 加入所有更改

git add .

# 输入 commit 信息

time=$(date "+%Y.%m.%d")

yes="y"

no="n"

one="1"

two="2"

three="3"

echo -e "1. 上传题解\n2. 修改题解\n3. 自定义\n请选择 commit 信息模板(1/2/3)： \c"

read templatetype

if [ "${templatetype}" = "${one}" ];then
read -p "需要上传几篇题解? " numofupdate
git commit -m "上传 ${numofupdate} 篇题解 on ${time}"
git push
echo "成功提交修改！"
elif [ "${templatetype}" = "${two}" ];then
read -p "需要修改几篇题解? " numoffix
git commit -m "修改 ${numoffix} 篇题解 on ${time}"
git push
echo "成功提交修改！"
elif [ "${templatetype}" = "${three}" ];then
read -p "请输入 commit 信息： " co
git commit -m "${co}"
git push
echo "成功提交修改！"
else
echo "无效输入"
fi

sleep 5