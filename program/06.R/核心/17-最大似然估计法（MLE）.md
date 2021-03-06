
https://blog.csdn.net/shulixu/article/details/52577934

最大似然估计（Maximum Likelihood Estimation），是一种统计方法，它用来求一个样本集的相关概率密度函数的参数。最大似然估计中采样需满足一个很重要的假设，就是所有的采样都是独立同分布的。

一、最大似然估计法的基本思想
　　最大似然估计法的思想很简单：在已经得到试验结果的情况下，我们应该寻找使这个结果出现的可能性最大的那个  作为真  的估计。
　　我们分两种情进行分析：
1．离散型总体　
　　设  为离散型随机变量，其概率分布的形式为  ，则样本  的概率分布为  ，在  固定时，上式表示  取值  的概率；当  固定时，它是  的函数，我们把它记为  并称为似然函数。似然函数  的值的大小意味着该样本值出现的可能性的大小。既然已经得到了样本值  ，那它出现的可能性应该是大的，即似然函数的值应该是大的。因而我们选择使  达到最大值的那个  作为真  的估计。
2．连续型总体 
　　设  为连续型随机变量，其概率密度函数为  则  为从该总体抽出的样本。因为  相互独立且同分布，于是，样本的联合概率密度函数为
　　 ，在  是固定时，它是  在 处的 密度，它的大小与  落在  附近的概率的大小成正比，而当样本值  固定时，它是 的函数。我们仍把它记为  并称为似然函数。类似于刚才的讨论，我们选择使  最大的那个  作为真  的估计。
总之，在有了试验结果即样本值  时，似然函数  反映了  的各个不同值导出这个结果的可能性的大小。 我们选择使  达到最大值的那个 作为真  的估计。这种求点估计的方法就叫作最大似然法。
二、 最大似然估计的求法
假定现在我们已经观测到一组样本  要去估计未知参数  。一种直观的想法是，哪一组能数值使现在的样本  出现的可能性最大，哪一组参数可能就是真正的参数，我们就要用它作为参数的估计值。这里，假定我们有一组样本  .如果对参数的两组不同的值  和 ，似然函数有如下关系
　　  ,
　　那么，从  又是概率密度函数的角度来看，上式的意义就是参数  使 出现的可能性比参数  使  出现的可能性大，当然参数  比 更像是真正的参数.这样的分析就导致了参数估计的一种方法，即用使似然函数达到最大值的点 ,作为未知参数的估计，这就是所谓的最大似然估计。 现在我们讨论求最大似然估计的具体方法.为简单起见，以下记  ,求θ的极大似然估计就归结为求  的最大值点.由于对数函数是单调增函数，所以
　　　　　　　　　　     　　　　 　(2.1)

　与  有相同的最大值点。而在许多情况下，求  的最大值点比较简单，于是，我们就将求  的最大值点改为求  的最大值点.对  关于 求导数，并命其等于零，得到方程组 
　　　　　　　　　　 ,                  (2.2)
　　称为似然方程组。解这个方程组，又能验证它是一个极大值点，则它必是  ，也就是  的最大值点，即为所求的最大似然估计。大多常用的重要例子多属于这种情况。然而在一些情况下，问题比较复杂，似然方程组的解可能不唯一，这时就需要进一步判定哪一个是最大值点。
　　还需要指出，若函数  关于  的导数不存在时，我们就无法得到似然方程组 (7.2.2)，这时就必须根据最大似然估计的定义直接去  的最大值点。
　　在一些情况下，我们需要估计  。如果  分别是  的最大似然估计，则称  为  的最大似然估计。 

三、实例
1.  正态分布估计
设从正态总体  抽出样本  ，这里未知参数为mm  和  （注意我们把  看作一个参数）。似然函数为
　　　　　　　　            
              　　　　 　 = 
　　它的对数为
　　 ，
　　似然方程组为 
　　　　　　　　　　　 
　　由第一式解得
　　　　　　　　　　　 ，             
     代入第二式得
　　　　　　　　　　　 .         
　　似然方程组有唯一解(  ，  )，而且它一定是最大值点，这是因为当  或 或∞时，非负函数  。于是  和  的最大似然估计为
　　　　　　　　  ，  .         (7.2.53.3) 
　　这里，我们用大写字母表示所有涉及的样本，因为最大似然估计  和  都是统计量，离开了具体的一次试验或观测，它们都是随机的。
2.泊松分布估计
设总体  服从参数为的泊松分布，它的分布律为
　　　　　　　　  ， 
　　有了样本  之后，参数λ的似然函数为 
　　　　　　　　　　　 ，
　　似然方程为 
　　　　　　　　　　　 ，
　　解得
　　　　　　　　　　　　  . 
　　因为  的二阶导数总是负值，可见，似然函数在  处达到最大值。所以，  是λ的最大似然估计。
3.均匀分布估计
设总体  为  上的均匀分布，求  的最大似然估计。
　　 的概率密度函数为
　　　　　　　　　 
　　对样本  ，
　　　　　　　　　
　　很显然，L(a，b)作为a和b的二元函数是不连续的。这时我们不能用似然方程组(7.2.2)来求最大似然估计，而必须从最大似然估计的定义出发，求L(a，b)的最大值。为使L(a，b)达到最大，b－a应该尽量地小，但b又不能小于  ，否则，L(a，b)=0。
　　类似地，a不能大过  。因此，a和b的最大似然估计为
　　　　　　　　　   ， 
　　　　　　　　　　　　 .　
现在为止，我们以正态分布，泊松分布，均匀分布的参数以及事件发生的概率的估计为例子讨论了矩估计和最大似然估计。在我们所举的例子中，除了均匀分布外，两种估计都是一致的。矩估计的优点是简单，只需知道总体的矩，总体的分布形式不必知道。而最大似然估计则必须知道总体分布形式，并且在一般情况下，似然方程组的求解较复杂，往往需要在计算机上通过迭代运算才能计算出其近似解。

转自：http://blog.sciencenet.cn/home.php?mod=space&uid=491809&do=blog&id=400893