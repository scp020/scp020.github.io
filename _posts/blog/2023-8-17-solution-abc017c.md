---
layout: post
title: [ABC017C] ハイスコア 题解
categories: Blog
description: none
keywords: ABC017C, ハイスコア, 题解, AT
---

前置芝士：差分，前缀和，不会的小朋友可以去学习。

## 解法

### 部分分解法（$30$ 个测试点）

考虑枚举 $n$ 个遗迹是否选取，判断这些遗迹是否覆盖了所有宝石，如果没有则最大化答案。

时间复杂度 $\mathcal{O}(n \times m \times 2^n)$。

### 部分分解法（$100$ 个测试点）

考虑优化枚举方法。

因为题中要求至少一个宝石不被选取，所以考虑固定这个不被选取的宝石（不管别的宝石是否被选取）。如果一个遗迹选了这个被固定的宝石则不选，否则选（要最大化答案）。

时间复杂度 $\mathcal{O}(n \times m)$。

### 满分解法

考虑继续优化上一个方法。

上一个解法的特点是不去考虑我们选的遗迹的贡献，而是总贡献减去没有被选的贡献。所以我们需要一种数据结构可以完成下面两种操作：

+ 区间加和。

+ 单点查询。

当然，可以完成这两种操作的数据结构有很多，比如线段树，树状数组，但是这道题中没有修改，所以我们可以选择差分和前缀和来完成这两种操作。

对于 $n$ 个遗迹，每个遗迹对应的宝石为 $l_i$ 和 $r_i$，我们将 $pre_{l_i}$ 加上 $s_i$，将 $pre_{r_i+1}$ 减去 $s_i$，最后算一遍前缀和，就可以达到将 $l_i$ 和 $r_i$ 之间所有数都加上 $s_i$ 的效果。最后枚举一遍不选取的宝石用总贡献减去选这个宝石的贡献然后取最大值即可。

时间复杂度 $\mathcal{O}(n + m)$。

### 代码

```cpp
#include<bits/stdc++.h>
using namespace std;
#define Getchar() p1==p2 and (p2=(p1=Inf)+fread(Inf,1,1<<21,stdin),p1==p2)?EOF:*p1++
char Inf[1<<21],*p1,*p2;
inline void read(int &x,char c=Getchar())
{
	bool f=c!='-';
	x=0;
	while(c<48 or c>57) c=Getchar(),f&=c!='-';
	while(c>=48 and c<=57) x=(x<<3)+(x<<1)+(c^48),c=Getchar();
	x=f?x:-x;
}
int n,m,pre[100010],sum,mini=0x3f3f3f3f;
int main()
{
	read(n),read(m);
	for(int i=1,L,R,s;i<=n;i++) read(L),read(R),read(s),pre[L]+=s,pre[R+1]-=s,sum+=s;
	for(int i=1;i<=m;i++) pre[i]+=pre[i-1],mini=min(mini,pre[i]);
	cout<<sum-mini<<endl;// 千万别忘输出行末换行
	return 0;
}
```