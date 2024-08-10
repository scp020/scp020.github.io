---
layout: post
title: CF1725K Kingdom of Criticism 题解
categories: Blog
description: none
keywords: CF1725K, Kingdom of Criticism, 题解, codeforces
---

感觉这个题类似于方伯伯的 OJ 那题。

## 解法

还是考虑使用普通平衡树维护。这里使用 fhq_treap 维护普通平衡树。

平衡树每个节点维护的是值，平衡树外维护每个位置对应的是哪个平衡树节点。这样我们就可以直接单点查询了。

再考虑单点修改。我们找到这个节点的位置，把他左边和右边分裂出去，这个过程即按排名分裂，再更改这个位置的值，把左边右边合并起来，再按值分裂把这个位置插回去。

不难发现正常的平衡树的写法是不支持任取一点将其左右分裂出去的。考虑维护每个节点的父节点，这样可以通过在一个节点一直向上跳进行查询排名，然后按排名分裂就行了。

考虑区间修改，区间修改是不影响平衡树形态的，所以把需要修改的部分拿出来修改打标记再合并回去就行了。

但是回头看单点查询，发现并不能直接查询了，因为这个节点的祖先可能有懒惰标记还没有下传。所以我们从这个节点向上跳，把祖先的懒标记全都下放。

所有操作复杂度均为 $\mathcal{O}(\log n)$。

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
int n,m,a[400010];
struct fhq_node
{
    int val,w,siz,lazy;
    fhq_node *lc,*rc,*fa;
    inline fhq_node(int val)
    {
        this->val=val,w=rand(),siz=1,lazy=-1,lc=rc=fa=nullptr;
    }
    inline void pushup()
    {
        siz=(lc==nullptr?0:lc->siz)+(rc==nullptr?0:rc->siz)+1;
        if(lc!=nullptr) lc->fa=this;
        if(rc!=nullptr) rc->fa=this;
    }
    inline void pushdown()
    {
        if(lazy!=-1)
        {
            if(lc!=nullptr) lc->lazy=lazy,lc->val=lazy;
            if(rc!=nullptr) rc->lazy=lazy,rc->val=lazy;
            lazy=-1;
        }
    }
};
class fhq_treap
{
private:
    fhq_node *root,*index[400010];
    inline fhq_node *merge(fhq_node *l,fhq_node *r)
    {
        if(l==nullptr && r==nullptr) return nullptr;
        if(l==nullptr) return r;
        if(r==nullptr) return l;
        l->pushdown(),r->pushdown();
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
    inline std::pair<fhq_node *,fhq_node *> split_rank(fhq_node *rt,const int k)
    {
        std::pair<fhq_node *,fhq_node *> ret;
        if(rt==nullptr) return std::make_pair(nullptr,nullptr);
        rt->pushdown();
        int left=rt->lc==nullptr?0:rt->lc->siz;
        if(k<=left) ret=split_rank(rt->lc,k),rt->lc=ret.second,rt->pushup(),ret.second=rt;
        else ret=split_rank(rt->rc,k-left-1),rt->rc=ret.first,rt->pushup(),ret.first=rt;
        return ret;
    }
    inline std::pair<fhq_node *,fhq_node *> split_val(fhq_node *rt,const int k)
    {
        std::pair<fhq_node *,fhq_node *> ret;
        if(rt==nullptr) return std::make_pair(nullptr,nullptr);
        rt->pushdown();
        if(k<rt->val) ret=split_val(rt->lc,k),rt->lc=ret.second,rt->pushup(),ret.second=rt;
        else ret=split_val(rt->rc,k),rt->rc=ret.first,rt->pushup(),ret.first=rt;
        return ret;
    }
    inline void upd(fhq_node *rt)
    {
        if(rt==nullptr) return;
        if(rt->fa!=nullptr) upd(rt->fa);
        rt->pushdown();
    }
    inline int ask_rank(fhq_node *rt)
    {
        upd(rt);
        int ret=(rt->lc==nullptr?0:rt->lc->siz)+1;
        while(rt->fa!=nullptr)
        {
            if(rt->fa->rc==rt) ret+=(rt->fa->lc==nullptr?0:rt->fa->lc->siz)+1;
            rt=rt->fa;
        }
        return ret;
    }
public:
    inline void add(const int i,const int x)
    {
        std::pair<fhq_node *,fhq_node *> a;
        index[i]=new fhq_node(x),a=split_val(root,x-1);
        root=merge(merge(a.first,index[i]),a.second),root->fa=nullptr;
    }
    inline int ask(const int x)
    {
        upd(index[x]);
        return index[x]->val;
    }
    inline void fix1(const int x,const int y)
    {
        std::pair<fhq_node *,fhq_node *> a,b;
        int rank=ask_rank(index[x]);
        b=split_rank(root,rank),a=split_rank(b.first,rank-1);
        a.second->val=y,root=merge(a.first,b.second),b=split_val(root,y-1);
        root=merge(merge(b.first,a.second),b.second),root->fa=nullptr;
    }
    /**
     * || 1 ... l-1 || l ... mid || mid+1 ... r || r+1 ... n  ||
     * ||       a.first          ||         a.second          ||
     * ||  b.first  || b.second  ||   c.first   ||  c.second  ||
     *                    l-1            r+1
     */
    inline void fix2(const int l,const int r)
    {
        std::pair<fhq_node *,fhq_node *> a,b,c;
        int mid=(l+r)/2;
        a=split_val(root,mid),b=split_val(a.first,l-1),c=split_val(a.second,r);
        if(b.second!=nullptr) b.second->val=l-1,b.second->lazy=l-1;
        if(c.first!=nullptr) c.first->val=r+1,c.first->lazy=r+1;
        root=merge(merge(b.first,b.second),merge(c.first,c.second)),root->fa=nullptr;
    }
};
fhq_treap tree;
int main()
{
    srand(time(0));
    in>>n;
    for(int i=1;i<=n;i++) in>>a[i],tree.add(i,a[i]);
    in>>m;
    for(int i=1,op,x,y;i<=m;i++)
    {
        in>>op>>x;
        if(op==1) in>>y,tree.fix1(x,y);
        else if(op==2) out<<tree.ask(x)<<'\n';
        else in>>y,tree.fix2(x,y);
    }
    fwrite(Ouf,1,p3-Ouf,stdout),fflush(stdout);
    return 0;
}
```
