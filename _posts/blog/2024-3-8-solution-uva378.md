---
layout: post
title:  UVA378 Intersecting Lines 题解
categories: Blog
description: none
keywords: UVA378, Intersecting Lines, 题解, UVA
---

怎么这么多点斜式邪教啊。

## 解法

在计算几何中，我们应该尽可能地避免使用浮点数的计算，尽可能地使用向量计算。

本篇题解默认读者具有向量基础。

为了方便讲解，我们将输入的四个点分别记作 $A,B,C,D$。

考虑两条直线 $AB,CD$ 何时平行。根据向量叉乘的几何意义，如果 $\overrightarrow{AB} \times \overrightarrow{CD}=0$，则两直线平行。

直线重合是在直线平行的基础上，如果 $C,D$ 中任一点在直线 $AB$ 上，则两直线平行。即 $\overrightarrow{AB} \times \overrightarrow{AC}=0$（这里取点  $C$）。

剩下的情况就是直线相交了。如图，设两直线交点为 $E$。

![图](https://cdn.luogu.com.cn/upload/image_hosting/nebsz3hn.png)

根据小学四年级（雾）学的燕尾模型，$\dfrac{AE}{EB}=\dfrac{S_{\Delta ADC}}{S_{\Delta BDC}}$，所以 $\dfrac{AE}{AB}=\dfrac{S_{\Delta ADC}}{S_{\Delta ADC}+S_{\Delta BDC}}$，三角形面积可以用叉积轻松求出。

所以两直线交点为 $(X_A+(X_B-X_A) \times \dfrac{AE}{AB},Y_A+(Y_B-Y_A) \times \dfrac{AE}{AB})$。

最后提一句，这道题是早期 UVA 题，没有自动忽略文末换行，这题需要有文末换行。

## 代码

```cpp
#include<bits/stdc++.h>
namespace fast_IO
{
    /**
     * 省略了一部分
    */
    inline void read(int &x,char c=Getchar())
    {
        bool f=c!=45;
        x=0;
        while(c<48 or c>57) c=Getchar(),f&=c!=45;
        while(c>=48 and c<=57) x=(x<<3)+(x<<1)+(c^48),c=Getchar();
        x=f?x:-x;
    }
    inline void write(int x)
    {
        if(x<0) Putchar(45),x=-x;
        if(x>=10) write(x/10),x%=10;
        Putchar(x^48);
    }
    inline void read(__int128 &x,char c=Getchar())
    {
        bool f=c!=45;
        x=0;
        while(c<48 or c>57) c=Getchar(),f&=c!=45;
        while(c>=48 and c<=57) x=(x<<3)+(x<<1)+(c^48),c=Getchar();
        x=f?x:-x;
    }
    inline void write(__int128 x)
    {
        if(x<0) Putchar(45),x=-x;
        if(x>=10) write(x/10),x%=10;
        Putchar(x^48);
    }
    inline bool inrange(const char &ch)
    {
        if(ch>=33 && ch<=126) return true;
        return false;
    }
    inline void read(std::string &st,char c=Getchar())
    {
        st.clear();
        while(!inrange(c)) c=Getchar();
        while(inrange(c)) st+=c,c=Getchar();
    }
    inline void write(std::string st)
    {
        for(int i=0;i<st.size();i++) Putchar(st[i]);
    }
    inline void read(char &ch)
    {
        ch=Getchar();
        while(!inrange(ch)) ch=Getchar();
    }
    inline void write(const char &ch)
    {
        Putchar(ch);
    }
    inline void write(double x,int fix=2)
    {
        x+=x>0?my_round[fix+1]:-my_round[fix+1],write((__int128)x),x=x>0?x:-x,x-=(__int128)x;
        if(fix)
        {
            Putchar(46);
            while(fix--) x*=10,Putchar(((int)x)^48),x-=(int)x;
        }
    }
    class fastin
    {
    public:
        template<typename T>
        inline fastin &operator>>(T &x)
        {
            read(x);
            return *this;
        }
    };
    class fastout
    {
    public:
        template<typename T>
        inline fastout &operator<<(T x)
        {
            write(x);
            return *this;
        }
    };
    fastin in;
    fastout out;
};
using namespace fast_IO;
int n;
struct point
{
    int x,y;
    point()
    {
        x=y=0;
    }
    point(int x,int y)
    {
        this->x=x,this->y=y;
    }
    inline point operator-(const point &rhs) const
    {
        return point(x-rhs.x,y-rhs.y);
    }
    inline int operator*(const point &rhs)
    {
        return x*rhs.y-y*rhs.x;
    }
};
inline int sgn(int x)
{
    return x==0?0:(x>0?1:-1);
}
struct seg
{
    point s,t;
};
seg a,b;
inline void calc()
{
    double ix,iy,rat;
    rat=(b.t-a.s)*(b.s-a.s)*1.0/((b.t-a.s)*(b.s-a.s)-(b.t-a.t)*(b.s-a.t));
    ix=a.s.x*1.0+(a.t.x-a.s.x)*rat,iy=a.s.y*1.0+(a.t.y-a.s.y)*rat;
    out<<"POINT "<<ix<<' '<<iy<<'\n';
}
int main()
{
    in>>n,out<<"INTERSECTING LINES OUTPUT\n";
    for(int i=1;i<=n;i++)
    {
        in>>a.s.x>>a.s.y>>a.t.x>>a.t.y>>b.s.x>>b.s.y>>b.t.x>>b.t.y;
        if((a.t-a.s)*(b.t-b.s)==0)
        {
            if((a.t-a.s)*(b.s-a.s)==0) out<<"LINE\n";
            else out<<"NONE\n";
        }else calc();
    }
    out<<"END OF OUTPUT\n";
    fwrite(Ouf,1,p3-Ouf,stdout),fflush(stdout);
    return 0;
}
```
