[wiki链接](https://en.wikipedia.org/wiki/Gershgorin_circle_theorem)
该定理给出了一个估计矩阵特征值的方法：
对于一个$n阶方阵A=(a_{ij})_{n\times n},定义R_{i}=\sum_{j\neq i}|a_{ij}|$
$定义圆盘区域C_{i}=\{Z:|Z-a_{ii}|\leq R_{i}\}$
那么$A的全部特征值\lambda_{i}全都落于\bigcup C_{i}中$

证明：对于$A的某一个特征值\lambda,设它的一个特征向量为x=(x_{j}),并记模最大的分量为x_{i}$
由特征值的定义，我们有：$Ax=\lambda x$，观察第$i$行，得到
	$\sum _{1\leq j\leq n}a_{ij}x_{j}=\lambda x_{i}$
	移项，我们得到$|\lambda-a_{ii}|\leq\frac{1}{|x_{i}|}\sum_{j\neq i}|a_{ij}x_{j}|\leq \sum_{j\neq i}|a_{ij}|(这里用到了x_{i}的模最大)$
	这表面$\lambda\in C_{i}$，得证

定理的推论：
- 严格对角占优矩阵的特征值都不为0,从而它可逆
- 对称的严格对角矩阵是正定的，若其对角线上的元素都大于0