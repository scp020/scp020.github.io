### 一、模板类别

​	数学：卢卡斯定理。

​	练习题目：

1. [P3807 【模板】卢卡斯定理/Lucas 定理](https://www.luogu.com.cn/problem/P3807)

### 二、模板功能

#### 1.构造

1. 数据类型

   模板参数 `typename Tp` ，表示任意一种自取模数类。要求模数为质数。

2. 时间复杂度

    $O(P)$ ，此处 `P` 指模数。
   
3. 备注

   在一个模数下求多个组合数的情况下，可以先针对模数进行预处理，以便进行高效查询。

#### 2.查询组合数(raw_query)

1. 数据类型

   输入参数 `uint32_t n` ，表示从 `n` 个数中选取。

   输入参数 `uint32_t m` ，表示选取 `m` 个数。

2. 时间复杂度

   $O(1)$ 。

3. 备注

   本方法限制 `n` 和 `m` 在 `[0, __P)` 范围内。
   
#### 3.查询组合数(query)

1. 数据类型

   输入参数 `uint64_t n` ，表示从 `n` 个数中选取。

   输入参数 `uint64_t m` ，表示选取 `m` 个数。

2. 时间复杂度

   $O(\log m)$ 。

### 三、模板示例

```c++
#include "IO/FastIO.h"
#include "MATH/DynamicModInt32.h"
#include "MATH/LucasTable.h"

int main() {
    using mint = OY::DynamicModInt32<0>;
    // 设置模数为 10007
    mint::set_mod(10007, false);
    cout << mint::mod() << endl;

    OY::LucasTable<mint> table;

    // 求组合数 C(15, 2) mod 10007
    auto a = table.query(15, 2);
    cout << "Comb(15, 2) mod " << mint::mod() << " ≡ " << a << endl;

    // 求组合数 C(1515, 222) mod 10007
    auto b = table.query(1515, 222);
    cout << "Comb(1515, 222) mod " << mint::mod() << " ≡ " << b << endl;
    
    // 求组合数 C(1515151515151515, 222222222222) mod 10007
    auto c = table.query(1515151515151515, 222222222222);
    cout << "Comb(1515151515151515, 222222222222) mod " << mint::mod() << " ≡ " << c << endl;
}
```

```
#输出如下
10007
Comb(15, 2) mod 10007 ≡ 105
Comb(1515, 222) mod 10007 ≡ 3179
Comb(1515151515151515, 222222222222) mod 10007 ≡ 4153

```

