---
layout: post
title: AT_arc181_a Sort Left and Right 题解
categories: Blog
description: none
keywords: AT_arc181_a, ARC, Sort Left and Right, 题解, atcoder
---

赛时糖丸了，吃了 $5$ 发罚时才过。

## 解法

如果输入序列有序则答案一定为 $0$，这里不多讨论。

可以发现把序列还原可以通过两种方法，一种是在 $1$ 或者是 $n$ 已经还原的情况下通过 $1$ 步使整个序列还原，还有一种是通过选取一个在中间的和左右两边都不产生逆序对的数使序列还原。其实不难发现第一种方法是第二种方法的特殊情况。

第二种方法显然只能用一次，否则一定不会比第一种方法更优。

考虑第一种方法，如果 $1$ 或 $n$ 已经还原的话答案是 $1$。否则我们需要把 $1$ 或 $n$ 还原。

考虑极端情况，就是 $a_1 = n,a_n = 1$，那最少需要两步才能使 $1$ 或 $n$ 还原，所以答案是 $3$。

剩下的情况答案是 $2$，即通过 $1$ 步使 $1$ 或 $n$ 还原，然后通过 $1$ 一步使序列还原。

## 代码

```cpp
#include<bits/stdc++.h>
namespace fast_IO
{
    /**
     * useless fast IO
    */
};
using namespace fast_IO;
int t,n,a[200010],maxi[200010],mini[200010];
bool flag;
int main()
{
    in>>t;
    while(t--)
    {
        in>>n,flag=1;
        for(int i=1;i<=n;i++) in>>a[i],flag&=(a[i]==i);
        if(flag)
        {
            out<<"0\n";
            continue;
        }
        maxi[0]=INT_MIN,mini[n+1]=INT_MAX;
        for(int i=1;i<=n;i++) maxi[i]=std::max(maxi[i-1],a[i]);
        for(int i=n;i;i--) mini[i]=std::min(mini[i+1],a[i]);
        for(int i=1;i<=n;i++) if(maxi[i-1]<=a[i] && mini[i+1]>=a[i]) flag=1;
        if(flag) out<<"1\n";
        else if(a[1]==n && a[n]==1) out<<"3\n";
        else out<<"2\n";
    }
    fwrite(Ouf,1,p3-Ouf,stdout),fflush(stdout);
    return 0;
}
```
