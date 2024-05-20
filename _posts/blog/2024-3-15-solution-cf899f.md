---
layout: post
title: CF899F Letters Removing 题解
categories: Blog
description: none
keywords: CF899F, Letters Removing, 题解, codeforces
---

这好像是个典题。

## 解法

一个很自然的想法。

考虑开 $62$ 颗平衡树，即每一种字符都开一颗平衡树，维护的是每种字符出现的位置，每次操作就把对应的平衡树区间删去即可，是很基础的非旋 treap 操作。

实现就是按值分裂。

```cpp
inline std::pair<fhq_node *,fhq_node *> split(fhq_node *rt,const int k)
{
    std::pair<fhq_node *,fhq_node *> ret;
    if(rt==nullptr) return std::make_pair(nullptr,nullptr);
    if(k<rt->val) ret=split(rt->lc,k),rt->lc=ret.second,rt->pushup(),ret.second=rt;
    else ret=split(rt->rc,k),rt->rc=ret.first,rt->pushup(),ret.first=rt;
    return ret;
}
```

当我搓完平衡树后发现过不了样例，仔细看样例才发现，字符的标号是随着删除操作而变化的。所以我们需要动态的维护每个数的标号，这也是很典的问题。考虑用一个树状数组，初始值都是 $1$，表示所有字符都没有被删除，之后每删除一个字符，我们就在树状数组的对应位置减 $1$，树状数组中第 $k$ 大的数的位置就是删除后的第 $k$ 个字符在原序列中的位置。最朴素的想法就是在树状数组上二分。

当然，有比树状数组上二分复杂度更优的做法，就是树状数组上倍增。

注意到树状数组上的节点 $c_i$ 表示 $\sum \limits _{j=i-lowbit(i)+1}^i a_j$，所以我们从高位向低位枚举答案的每个二进制位即可。

```cpp
inline int kth(int k)
{
    int sum=0,ret=0;
    for(int i=lgn;i>=0;i--)
    {
        ret+=1<<i;
        if(ret>=n || sum+c[ret]>=k) ret-=1<<i;
        else sum+=c[ret];
    }
    return ret+1;
}
```

时间复杂度：$\mathcal{O}(n \log n)$，即树状数组初始化、平衡树区间删除、树状数组获取第 $k$ 小值、树状数组单点修改的复杂度。

## 代码

```cpp
#include<bits/stdc++.h>
namespace fast_IO
{
    /**
     * 快读快写
    */
};
using namespace fast_IO;
int n,m;
char ans[200010],now;
class BIT
{
    #define N 200010
private:
    int c[N],lgn;
    inline int lowbit(const int &x)
    {
        return x&(-x);
    }
public:
    inline void init()
    {
        lgn=log2(n);
    }
    inline void fix(int pos,int x)
    {
        while(pos<=n) c[pos]+=x,pos+=lowbit(pos);
    }
    inline int kth(int k)
    {
        int sum=0,ret=0;
        for(int i=lgn;i>=0;i--)
        {
            ret+=1<<i;
            if(ret>=n || sum+c[ret]>=k) ret-=1<<i;
            else sum+=c[ret];
        }
        return ret+1;
    }
};
BIT fenwik_tree;
template<typename T>
inline void swap(T &_x,T &_y)
{
    T tmp=_x;
    _x=_y,_y=tmp;
}
struct fhq_node
{
    int val,w,siz;
    fhq_node *lc,*rc;
    inline fhq_node(int val)
    {
        this->val=val,w=rand(),siz=1,lc=rc=nullptr;
    }
    inline void pushup()
    {
        siz=(lc==nullptr?0:lc->siz)+(rc==nullptr?0:rc->siz)+1;
    }
};
class fhq_treap
{
    #define ls l,mid-1
    #define rs mid+1,r
private:
    fhq_node *root;
    std::vector<int> v;
    inline fhq_node *merge(fhq_node *l,fhq_node *r)
    {
        if(l==nullptr && r==nullptr) return nullptr;
        if(l==nullptr) return r;
        if(r==nullptr) return l;
        if(l->w<r->w)
        {
            l->rc=merge(l->rc,r),l->pushup();
            return l;
        }else
        {
            r->lc=merge(l,r->lc),r->pushup();
            return r;
        }
    }
    inline std::pair<fhq_node *,fhq_node *> split(fhq_node *rt,const int k)
    {
        std::pair<fhq_node *,fhq_node *> ret;
        if(rt==nullptr) return std::make_pair(nullptr,nullptr);
        if(k<rt->val) ret=split(rt->lc,k),rt->lc=ret.second,rt->pushup(),ret.second=rt;
        else ret=split(rt->rc,k),rt->rc=ret.first,rt->pushup(),ret.first=rt;
        return ret;
    }
    inline fhq_node *build(int l,int r)
    {
        if(l>r) return nullptr;
        if(l==r) return new fhq_node(v[l-1]);
        int mid=(l+r)/2;
        fhq_node *rt=new fhq_node(v[mid-1]);
        rt->lc=build(ls),rt->rc=build(rs);
        rt->pushup();
        return rt;
    }
    inline void print(fhq_node *rt)
    {
        if(rt==nullptr) return;
        if(rt->lc!=nullptr) print(rt->lc);
        ans[rt->val]=now;
        if(rt->rc!=nullptr) print(rt->rc);
    }
    inline void del(fhq_node *rt)
    {
        if(rt==nullptr) return;
        if(rt->lc!=nullptr) del(rt->lc);
        fenwik_tree.fix(rt->val,-1);
        if(rt->rc!=nullptr) del(rt->rc);
        delete rt;
    }
public:
    inline void push_back(const int x)
    {
        v.push_back(x);
    }
    inline void build()
    {
        root=build(1,(int)v.size());
    }
    inline void del(const int L,const int R)
    {
        std::pair<fhq_node *,fhq_node *> a,b;
        a=split(root,R),b=split(a.first,L-1),del(b.second);
        root=merge(b.first,a.second);
    }
    inline void print()
    {
        print(root);
    }
};
fhq_treap tree[70];
std::unordered_map<char,int> mp;
std::unordered_map<int,char> imp;
char ch;
int main()
{
    srand(time(0));
    for(int i=1;i<=26;i++) mp['a'+i-1]=i,imp[i]='a'+i-1;
    for(int i=27;i<=52;i++) mp['A'+i-27]=i,imp[i]='A'+i-27;
    for(int i=53;i<=62;i++) mp['0'+i-53]=i,imp[i]='0'+i-53;
    in>>n>>m,fenwik_tree.init();
    for(int i=1;i<=n;i++) in>>ch,tree[mp[ch]].push_back(i),fenwik_tree.fix(i,1);
    for(int i=1;i<=62;i++) tree[i].build();
    for(int i=1,x,y;i<=m;i++)
    {
        in>>x>>y>>ch;
        x=fenwik_tree.kth(x),y=fenwik_tree.kth(y);
        tree[mp[ch]].del(x,y);
    }
    for(int i=1;i<=62;i++) now=imp[i],tree[i].print();
    for(int i=1;i<=n;i++) if(ans[i]) out<<ans[i];
    fwrite(Ouf,1,p3-Ouf,stdout),fflush(stdout);
    return 0;
}
```
