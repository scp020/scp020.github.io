---
layout: post
title:  UVA303 Pipe 题解
categories: Blog
description: none
keywords: UVA303, Pipe, 题解, UVA
---

这题真被坑惨了。

## 解法

枚举所有拐点的上下端点（但是显然选同一处拐点的上下端点是没有意义的），然后使我们求的直线穿过这两个点，暴力验证直线是否可以穿过管道或者求最远到达的距离。

为什么选端点可以保证答案最大化？

我们称两个拐点之间的那段管道为一段管道，显然一段管道的上下两边的斜率是相同的，而且是单调的。我们分类讨论。

- 如果这段管道是单调递减的（斜率为负），显然我们可以让光线尽可能靠近下拐点以增大答案。
- 如果这段管道是单调递增的（斜率为正），显然我们可以让光线尽可能靠近上拐点以增大答案。

综上，靠近端点能使答案最大化。

接下来就是喜闻乐见的判断直线与线段是否相交以及求交点坐标。

判断线段相交的做法还是用向量判断。计算交点我们详细解释。

为了方便讲解，我们将直线上任取两点和线段两端点这四个点分别记作 $A,B,C,D$。

如图，设直线与线段交点为 $E$。

![图](https://cdn.luogu.com.cn/upload/image_hosting/nebsz3hn.png)

根据小学四年级（雾）学的燕尾模型，$\dfrac{AE}{EB}=\dfrac{S_{\Delta ADC}}{S_{\Delta BDC}}$，所以 $\dfrac{AE}{AB}=\dfrac{S_{\Delta ADC}}{S_{\Delta ADC}+S_{\Delta BDC}}$，三角形面积可以用叉积轻松求出。

所以直线与线段交点为 $(X_A+(X_B-X_A) \times \dfrac{AE}{AB},Y_A+(Y_B-Y_A) \times \dfrac{AE}{AB})$。

基本上就做完了，剩下还要特判光线有没有一直在管道外就行了。

## 代码

```cpp
#include<bits/stdc++.h>
const double eps=1e-8;
struct point
{
    double x,y;
    point(){x=y=0;}
    point(double x,double y){this->x=x,this->y=y;}
    inline point operator-(const point &rhs) const{return point(x-rhs.x,y-rhs.y);}
    inline double operator*(const point &rhs) const{return x*rhs.y-y*rhs.x;}
    inline bool operator==(const point &rhs) const{return fabs(x-rhs.x)<=eps && fabs(y-rhs.y)<=eps;}
};
inline int sgn(double x){return (fabs(x)<eps)?0:(x>0?1:-1);}
struct seg
{
    point s,t;
    inline seg(){}
    inline seg(point s,point t){this->s=s,this->t=t;}
    inline friend bool cross(const seg &lhs,const seg &rhs) // 第一个参数传直线，第二个参数传线段
    {
        return sgn((rhs.s-lhs.s)*(lhs.t-lhs.s))*sgn((rhs.t-lhs.s)*(lhs.t-lhs.s))<0;
    }
    inline friend point calc(const seg &lhs,const seg &rhs)
    {
        double ix,iy,rat;
        rat=(rhs.t-lhs.s)*(rhs.s-lhs.s)/((rhs.t-lhs.s)*(rhs.s-lhs.s)-(rhs.t-lhs.t)*(rhs.s-lhs.t));
        ix=lhs.s.x+(lhs.t.x-lhs.s.x)*rat,iy=lhs.s.y+(lhs.t.y-lhs.s.y)*rat;
        return point(ix,iy);
    }
};
int n;
point top[30],bot[30];
double ans;
seg lig;
bool flag;
inline void solve()
{
    int fl=0;
    for(int i=1;i<n && !fl;i++)
    {
        if(sgn((lig.t-lig.s)*(top[i]-lig.s))==-1 || sgn((lig.t-lig.s)*(bot[i]-lig.s))==1)
        {
            fl=1;
            break;
        }
        if(cross(lig,seg(top[i],top[i+1])) || calc(lig,seg(top[i],top[i+1]))==top[i] && sgn((lig.t-lig.s)*(top[i+1]-lig.s))==-1)
            ans=std::max(ans,calc(lig,seg(top[i],top[i+1])).x),fl=1;
        if(cross(lig,seg(bot[i],bot[i+1])) || calc(lig,seg(bot[i],bot[i+1]))==bot[i] && sgn((lig.t-lig.s)*(bot[i+1]-lig.s))==1)
            ans=std::max(ans,calc(lig,seg(bot[i],bot[i+1])).x),fl=1;
    }
    if(!fl) flag=1;
}
int main()
{
    while(1)
    {
        scanf("%d",&n),ans=-1e18,flag=0;
        if(n==0) break; 
        for(int i=1;i<=n;i++) scanf("%lf%lf",&top[i].x,&top[i].y),bot[i]=top[i]-point(0,1);
        for(int i=1;i<=n && !flag;i++)
            for(int j=i+1;j<=n && !flag;j++)
            {
                lig=seg(top[i],top[j]),solve();
                lig=seg(top[i],bot[j]),solve();
                lig=seg(bot[i],top[j]),solve();
                lig=seg(bot[i],bot[j]),solve();
            }
        if(flag) printf("Through all the pipe.\n");
        else printf("%.2lf\n",ans+eps);
    }
    return 0;
}
```
