假设函数$f,g\in C[a,b]$,且$g(x)\geq 0,若存在常数C>0,使得$
	$f(x)\leq C+\int_{a}^{x} g(s)f(s) \, ds,x\in[a,b]$
那么$f(x)\leq C \exp\left( \int_{a}^{x} g(s) \, ds \right)$
一个简单的证明如下：
	构造函数$\Phi(x)=\int_{a}^{x} g(s)f(s) \, ds$
	那么$\Phi'(x)=g(x)f(x)$
	由已知条件得到：$\Phi'(x)\leq g(x)(C+\Phi(x))$
	这是一个积分不等式，采用积分因子的方法，我们得到：
	$\left( \Phi(x)\exp\left( \int_{a}^{x} -g(s) \, ds \right) \right)'\leq C\exp\left( \int_{a}^{x} -g(s) \, ds \right)g(x)$
	注意到右式实际上是$-C\left[ \exp\left( \int_{a}^{x} -g(s) \, ds \right) \right]'$
	从而我们有:$[\Phi(x)\exp\left( \int_{a}^{x} -g(s) \, ds \right)+C\exp\left( \int_{a}^{x} -g(s) \, ds \right)]'\leq 0$	
	注意到$x=0时左式内部为C$,从而$[\Phi(x)\exp\left( \int_{a}^{x} -g(s) \, ds \right)+C\exp\left( \int_{a}^{x} -g(s) \, ds \right)]\leq C$
	即$\Phi(x)\leq C\exp\left( \int_{a}^{x} g(s) \, ds \right)-C$
	回代回有关$\Phi'(x)的不等式，便得到了\Phi'(x)\leq g(x)C\exp\left( \int_{a}^{x} g(s) \, ds \right)$
	事实上这与我们所求的不等式等价
	