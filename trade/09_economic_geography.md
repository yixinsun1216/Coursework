# Increasing Returns and Economic Geography

* international trade theory conventionally treats nations as dimensionless points
* Main question: why and when does manufacturing become concentrated in a few regions, leaving others relatively undeveloped?



## I. Bases for Regional Divergence 

Concept of external economies identifies 3 reasons for localization

1. Concentration of several firms in a single location offers a pooled market for workers with industry specific skills, ensuring both a lower probability of unemployment and a lower probability of labor shortage
2. Localized industries can support the production of nontradable specialized inputs
3. Informational spillovers can give clustered firms a better production function than isolated producers (agglomeration economies)

Question of this paper: instead of asking why a particular industry is concentrated in a particular area, I ask why manufacturing in general might end up concentrated in one or a few regions of a country, with the remaining regions playing the "peripheral" role of agricultural suppliers to the manufacturing "core"

* Formalizes "circular causation" - manufacturing will tend to concentrate where there is a large market, but the market will be large where manufacturers production is concentrated
* How far will the tendency toward geographical concentration proceed?
  * The circularity that can generate manufacturing concentration will not matter too much if manufacturing employs only a small fraction of the population and hence generates only a small fraction of demand, or if a combination of weak economies of scale and high transportation costs induces suppliers of goods and services to the agricultural sector to locate very close to their markets.
  * Thus this circular causation depends on transportation costs, economies of scale, and share of nonagricultural goods in expenditure crosses a critical threshold, population will start to concentrate and regions to diverge
  * Initial conditions matter a LOT



## II. A Two-Region Model

* 2 regions
* 2 types of production: CRS agriculture tied to land and IRS manufacturing that can be located in either region
* $U=C_{M}^{\mu} C_{A}^{1-\mu}$
  * $\mu$ one of key parameters that will determine whether regions converge or diverge
* $C_{M}=\left[\sum_{i=1}^{N} c_{i}^{(\sigma-1) / \sigma}\right]^{\sigma /(\sigma-1)}$ where $N$ is large number of potential products and $\sigma > 1$ is the elasticity of substitution among the products
  * Elasticity $\sigma$ is the second parameter determining the character of equilibrium in the model



<u>Production</u>

* 2 regions and 2 factors or production; each factor is assumed specific to one sector

* Peasants produce agricultural goods; unit labor requirement is one

  * Peasant population is completely immobile between regions, with a given peasant supply $\frac{1-\mu}{2}$ in each region

* Workers may move between regions; let $L_1$ and $L_2$ be the worker supply in regions 1 and 2, and require that 
  $$
  L_1 + L_2 = \mu
  $$

* Production of individual manufactured good $i$ involves fixed cost + constant marginal cost
  $$
  L_{M i}=\alpha+\beta x_i
  $$

<u>Transportation Cost</u>

* Transportation of agricultural output assumed to be costless - ensure price of agricultural output and hence the earnings of each peasant are same in both regions
  * Use common peasant wage as numeraire
* Transportation cost are iceberg &rightarrow;  of each unit of manufactures shipped from one region to the other, only a fraction
  $\tau < 1$ arrives. 
  * This fraction $\tau$, which is an inverse index of transportation costs, is the final parameter determining whether regions converge or diverge.



<u>Firm Behavior</u>

* Profit maximizing price
  $$
  p_{1}=\left(\frac{\sigma}{\sigma-1}\right) \beta w_{1}
  $$
  similarly for region 2

* Then we have
  $$
  \frac{p_{1}}{p_{2}}=\frac{w_{1}}{w_{2}}
  $$
  
* If there is free entry of firms into manufacturing, profits must be driven to zero. Thus it must be true that
  $$
  \left(p_{1}-\beta w_{1}\right) x_{1}=\alpha w_{1}
  $$
  which implies
  $$
  x_{1}=x_{2}=\frac{\alpha(\sigma-1)}{\beta}
  $$
  * Thus the number of goods produced is proportional to the number of workers: $\frac{n_{1}}{n_{2}}=\frac{L_{1}}{L_{2}}$

* In the zero profit equilibrium, $\frac{\sigma}{\sigma - 1}$ is the ratio of the MPL to its average product, that is the degree of economies of scale. So although $\sigma$ is a parameter of tastes rather than technology, it can be interpreted as an inverse index of equilibrium economies of scale



## III. Short-Run 

* Workers move toward the region that offers them higher real wages, leading to either convergence between regions as they move toward equality of worker/peasant ratios or divergence as the workers all congregate in one region



## III. Long-run Equilibrium

* What can you say about this system of equations
* Endogenous variable is $f$ and what values of $f$ will make (17) and (18) equal
* Race between home market effect and price index effect
* Equation 21 &rightarrow; premise is that everyone is in region 1
  * Everyone's expenditure is on region 1's goods 
* Forward linkage workers want higher nominal wages (price index effect)
* Backward linkage - firms want to sell to customers (home market effect)

![image-20201116152235779](C:\Users\Yixin Sun\AppData\Roaming\Typora\typora-user-images\image-20201116152235779.png)

* Necessary condition for concentration is saying if I stuck everyone in region 1, can I keep them there? $\lambda$ is share in region 1 ($f$ in Krugman's model). Aka is this an equilibrium?
  * Krugman establish a "sustain point" $\nu$  - if trade costs are low enough (below $T_s$)
* There is also a "break point" that is sufficient for concentration to be the "stable" equilibrium outcome - get half of population in each region
  * Dashed region at $\lambda = 0.5$ is an equilibrium but it's unstable (hence dashed)
  * 



## Core Results

* Home Market Effect: if region A has exogenously high relative demand for good A, then due to IRS region A will actually export good A
  * Once there are relatively more workers in Region A, there will be more demand there
* When transportation costs are sufficiently low (aka low trade costs), all manufacturers are concentrated in a single region that becomes the "core" of the economy. Economy displays symmetric regional pattern of production when transportation costs are high enough





----------

# Of Hype and Hyperbolas

* There's a lot of hype around Krugman, but there's a lot of special functional forms
* $\sigma$ starts as a taste parameter, and ends up as an index of returns to scale! 
  * Preferences are interpreted as returns to scale parameter
* These models don't have any history - just have phase diagram for solving static model. No forward looking behavior or dynamics 
* Iceberg assumption: fixed costs matter. If railroads caused transportation costs to fall, this is causal specific regions to be linked. Not a uniform decrease in transportation costs.



---



# Redding and Sturm (2008)

* West German cities close to the new border experienced a disproportionate loss of market access relative to other West German cities 
* Difference-in-differences is proximate vs distance West German cities before and after division
  * estimate effect of division of Germany on each 



# Allen and Arkolakis (QJE 2014)

* Develop quantitative framework that extends new economic geography to much broader class (rather than assuming locations lie on a circle)

* Continuum of locations