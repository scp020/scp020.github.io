---
layout: post
title: AT_jag2018summer_day2_i ADD DIV MAX RESTORE 题解
categories: Blog
description: none
keywords: AT_jag2018summer_day2_i, JAG, ADD DIV MAX RESTORE, 题解, atcoder
---

拿来题一看，哟，这不雅礼集训市场那题吗，狂喜。

## 解法

但是读完题后发现最后一个操作会使区间的势能重置，复杂度并没有保障。所以考虑新做法。为了方便表述，我们分别称 $4$ 个操作为加法、除法、查询、重置操作。

显然还是考虑线段树做法，但是这里维护懒标记的方法非传统方法。

我们把加法操作和除法操作看作是一种 $f(x)$ 的映射，其中 $x$ 即为线段树当前节点的答案。本题中形如 $f(x) = (ax + b)/c$ 和 $f(x)=(a + x)/b + c$ 的映射都是可以的，这里我们只讨论后者。

重置操作过于简单，这里不多说了。

加法操作即直接在 $c$ 上加 $val$ 就可以了。

对于除法操作，我们重构 $a,b,c$ 的值。通分后原来的值为 $\dfrac{a + bc}{b}$，$a$ 的意义是除以 $b$ 的余数，$c$ 的意义是除以 $b$ 的商，所以 $a,b,c$ 的新值分别为 $a+bc\mod {(b \times val)},\left\lfloor \dfrac{a + bc}{b \times val} \right\rfloor,b \times val$。

剩下的就全是基础的线段树操作了。

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
#define int long long
const int V=1e9;
int n,m,a[200010];
// 节点表示为 (x+a)/b+c
struct fun
{
    int a,b,c;
    inline fun()
    {
        a=0,b=1,c=0;
    }
    inline void clear()
    {
        a=0,b=1,c=0;
    }
    inline int calc(const int x)
    {
        return (x+a)/b+c;
    }
    inline void add(const int x)
    {
        c+=x;
    }
    inline void div(const int x)
    {
        int na,nb,nc;
        nb=b*x,nc=(a+b*c)/nb,na=(a+b*c)%nb;
        if(nb>V) na=std::max(0ll,na-nb+V),nb=V;
        a=na,b=nb,c=nc;
    }
};
struct node
{
    int maxi,ori_maxi,tag;
    fun lazy;
    node *lc,*rc;
    inline node()
    {
        maxi=ori_maxi=tag=0,lc=rc=nullptr;
    }
    inline void pushup()
    {
        maxi=std::max(lc->maxi,rc->maxi);
    }
    inline void pushdown()
    {
        if(tag)
            lc->lazy.clear(),rc->lazy.clear(),lc->maxi=lc->ori_maxi,rc->maxi=rc->ori_maxi,lc->tag=rc->tag=1,tag=0;
        if(lazy.a) lc->lazy.add(lazy.a),rc->lazy.add(lazy.a),lc->maxi+=lazy.a,rc->maxi+=lazy.a,lazy.a=0;
        if(lazy.b!=1) lc->lazy.div(lazy.b),rc->lazy.div(lazy.b),lc->maxi/=lazy.b,rc->maxi/=lazy.b,lazy.b=1;
        if(lazy.c) lc->lazy.add(lazy.c),rc->lazy.add(lazy.c),lc->maxi+=lazy.c,rc->maxi+=lazy.c,lazy.c=0;
    }
};
class seg_tree
{
    #define ls l,mid
    #define rs mid+1,r
private:
    node *root;
    inline node *build(int l,int r)
    {
        node *rt=new node();
        if(l==r) rt->maxi=rt->ori_maxi=a[l];
        else
        {
            int mid=(l+r)/2;
            rt->lc=build(ls),rt->rc=build(rs),rt->pushup(),rt->ori_maxi=rt->maxi;
        }
        return rt;
    }
    inline void add(node *rt,const int L,const int R,const int val,int l,int r)
    {
        if(L<=l && r<=R)
        {
            rt->maxi+=val,rt->lazy.add(val);
            return;
        }
        int mid=(l+r)/2;
        rt->pushdown();
        if(L<=mid) add(rt->lc,L,R,val,ls);
        if(R>mid) add(rt->rc,L,R,val,rs);
        rt->pushup();
    }
    inline void div(node *rt,const int L,const int R,const int val,int l,int r)
    {
        if(L<=l && r<=R)
        {
            rt->maxi/=val,rt->lazy.div(val);
            return;
        }
        int mid=(l+r)/2;
        rt->pushdown();
        if(L<=mid) div(rt->lc,L,R,val,ls);
        if(R>mid) div(rt->rc,L,R,val,rs);
        rt->pushup();
    }
    inline void fil(node *rt,const int L,const int R,int l,int r)
    {
        if(L<=l && r<=R)
        {
            rt->maxi=rt->ori_maxi,rt->lazy.clear(),rt->tag=1;
            return;
        }
        int mid=(l+r)/2;
        rt->pushdown();
        if(L<=mid) fil(rt->lc,L,R,ls);
        if(R>mid) fil(rt->rc,L,R,rs);
        rt->pushup();
    }
    inline int ask(node *rt,const int L,const int R,int l,int r)
    {
        if(L<=l && r<=R) return rt->maxi;
        int mid=(l+r)/2,ret=LONG_LONG_MIN;
        rt->pushdown();
        if(L<=mid) ret=std::max(ret,ask(rt->lc,L,R,ls));
        if(R>mid) ret=std::max(ret,ask(rt->rc,L,R,rs));
        return ret;
    }
public:
    inline void build()
    {
        root=build(1,n);
    }
    inline void add(const int L,const int R,const int val)
    {
        add(root,L,R,val,1,n);
    }
    inline void div(const int L,const int R,const int val)
    {
        div(root,L,R,val,1,n);
    }
    inline void fil(const int L,const int R)
    {
        fil(root,L,R,1,n);
    }
    inline int ask(const int L,const int R)
    {
        return ask(root,L,R,1,n);
    }
};
seg_tree tree;
signed main()
{
    in>>n>>m;
    for(int i=1;i<=n;i++) in>>a[i];
    tree.build();
    for(int i=1,op,x,y,z;i<=m;i++)
    {
        in>>op>>x>>y>>z,x++,y++;
        if(op==0) tree.add(x,y,z);
        else if(op==1) tree.div(x,y,z);
        else if(op==2) out<<tree.ask(x,y)<<'\n';
        else tree.fil(x,y);
    }
    fwrite(Ouf,1,p3-Ouf,stdout),fflush(stdout);
    return 0;
}
```
