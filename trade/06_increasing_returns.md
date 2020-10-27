# Week 6 Does Size Matter?

* In NCG models, pattern of specialization is size invariant
* In new trade theory, size can influence the pattern of specialization because of economies of scale
  * Inituition: size is advantageous when there are economies of scale
  * Implications: strategic trade policy, multiple equilibria
* "Home market effect", in which an economy with greater domestic demand is a net exporter of that good, distinguishes new trade theories from neoclassical models
  * Our domestic consumers want more of the stuff, so we sell more of it to foreigners &rightarrow; hallmark of increasing returns to scale
* Empirical challenge is inferring "greater demand" from observed equilibrium. How do you know it's caused by demand rather than exogenous differences in supply?

## Short History of Size in Theory

* Linder (1961) posits that home demand is a source of comparative advantage such that rich countries will produce high-quality products
  * Different kinds of people at different income levels demand different products. 
  * Wrote this in words ad gave motivating empirics, but no theory
  * 2 decades pass, and theorists struggle to link market size and specialization
* Krugman (1980) formalizes two-sector, two-country predictions for (1) exogenous demand differences and (2) country size differences
  * writes down a toy model that becomes intractable when we try to generalize
* Early 2000s: empirical work correlates market size with sectoral composition
* 2010s: income driven demand composition in theory and empirics 
* We focus on internal economies of scale within the firm (homogeneous this week)
  * external economies of scale can be done with perfect competition 



## Linder Hypothesis

* Home demand governs supply capability
  * range of exportable products is determined by internal demand. Profit opportunities arise from domestic needs. The production functions of goods demanded at home are the relatively most advantageous ones 
  * If you are making goods for rich people, you need rich people telling you what they want in your home country
  * Doesn't seem as true in this day and age 
* Hypothesis for trade flows: internal demand determines which products may be imported. The more similar the demand structure of two countries, the more intensive, potentially, is the trade between these two countries. 
  * Vast majority of our tools so far cannot talk at ALL about this since they always assume identical and homothetic preferences
  * To make this hypothesis work, we need identical and nonhomothetic preferences or allow for arbitrary differences in preferences
* Modeling challenge - Grubel and Lloyd's book on intra-industry trade 
  * Corden 1970 discussant: Grubel suggests country will tend to product and export those products or "styles" of products for which it has a relatively large domestic product... it raises an interesting theoretical question which has not be explored. How to write this model? 3 approaches 
  * 2 dynamic stories: 
    * larger demand + economies of scale = lower autarky price
    * larger demand + learning by doing = inherited comparative advantage
  * 3rd approach is to introduce transport costs &rightarrow; what we're talking about today!



## Krugman 1980	

* Krugman 1979 &rightarrow; variable elasticity of demand, and size of the firm is the thing you need to pin down. Elasticity of demand changes with quantity. On the other hand, size becomes deterministic in Krugman 1980

1. $U =\sum_{i} c_{i}^{\theta^{\circ}}$
2. $l_{i} =\alpha+\beta x_{i} $
3. $x_{i} =L c_{i}$
4. $L =\sum_{i}\left(\alpha+\beta x_{i}\right) $
5. $\theta c_{i}^{\theta-1} =\lambda p_{i} $
6. $p_{i}=\theta^{-1} \beta w$
7. $p_{i} =\theta \lambda^{-1}\left(x_{i} / L\right)^{\theta-1}$
8. $\pi_{i} =p x_{i}-\left(\alpha+\beta x_{i}\right) $
9. $x_{i} =\alpha \theta / \beta(1-\theta)$
10. $n =L(1-\theta) / \alpha $  Number of firms is related to total population size, some demand parameter, and the fixed cost (does not depend on variable cost because of isoelastic demand)
11. $n =L(1-\theta) / \alpha, n^{*}=L^{*}(1-\theta) / \alpha$  Add trade

**Section 2**

* Add iceberg transport costs. Quantity consumed at home is a bit bigger than what you sell to foreigners 
* Size matters for wages 
  * If you have no transportation costs, you still have equal wage rates with different sizes
  * If bigger country had same wage, there are more consumers in big country, so you make higher profits. Either smaller country is losing money, or bigger country is making money (which violates our zero profit condition)
  * The way to rectify this is by allowing wages to adjust 
* Normally, being in the bigger country causes wages to go down (DFS/NC models). Here, if you're the bigger country, you have more consumers which makes firms more profitable in that country. Hence you need higher wages! 

**Section 3**

* Introduce 2 types of consumers: 

  1. $U=\sum_{\omega} q(\omega)^{\frac{\sigma-1}{\sigma}}$ love of variety
  2. $\tilde{U}=\sum_{\tilde{\omega}} \tilde{q}(\tilde{\omega})^{\frac{\sigma-1}{\sigma}}$ love of a different set of varieties 

  * 2 classes of goods and two groups of people who like these goods

* Home and foreign have same total population; different shares of types

  * $L+\tilde{L}=c L^{*}+\tilde{L}^{*}=\bar{L} ; \quad L=\gamma \bar{L} ; \quad L^{*}=(1-\gamma) \bar{L}$

* Identical production functions and iceberg trade costs $\tau$
  $$
  \begin{array}{r}
  l(\omega)=f+c x(\omega) ; \quad l(\tilde{\omega})=f+c x(\tilde{\omega}) \\
  \Rightarrow p=\frac{\sigma}{\sigma-1} c w ; \quad \pi=0 \Rightarrow x=\frac{f}{c}(\sigma-1)
  \end{array}
  $$
  * just a change from $\alpha$ and $\beta$
  * Cost structure is identical between tilde and normal goods

* Symmetry implies $w = \tilde{w} = w^* = \tilde{w}^*$ and thus $p = p^*$

* Only need to solve for $n, \tilde{n}, n^*, \tilde{n}^*$

  * All the action is on extensive margin since size of each firm is determinate 

* From perspective of regular people, amount you spend on home good is less than foreign relative expenditure when $p = p^*$ is $\tau^{1-\sigma}$ (part of why we like isoelastic demand is the ease with which trade cost enters)

* Expenditure on domestic varieties as share of total is $\frac{n}{n+n^{*} \tau^{1-\sigma}}$

* Market clearing: industry income equals domestic plus foreign
  expenditure
  $$
  \begin{aligned}
  n p x &=\frac{n}{n+n^{*} \tau^{1-\sigma}} w L+\frac{n \tau^{1-\sigma}}{n \tau^{1-\sigma}+n^{*}} w^{*} L^{*} \\
  n^{*} p^{*} x^{*} &=\frac{n^{*} \tau^{1-\sigma}}{n+n^{*} \tau^{1-\sigma}} w L+\frac{n^{*}}{n^{*}+n \tau^{1-\sigma}} w^{*} L^{*}
  \end{aligned}
  $$

  * income = Sales to home expenditure + sales to foreign expenditure 

* With $p=p^{*}, w=w^{*}, x=x^{*},$ solve for $\frac{n}{n^{*}}$
  $$
  \begin{aligned}
  n>0, n^{*}>0 \Rightarrow \frac{n}{n^{*}}=\frac{L / L^{*}-\tau^{1-\sigma}}{1-\tau^{1-\sigma} L / L^{*}}, &\quad \frac{L}{L^{*}} \in\left[\tau^{1-\sigma}, \tau^{\sigma-1}\right] \\
  \frac{L}{L^{*}}<\tau^{1-\sigma} \Rightarrow n=0 ; & \quad \frac{L}{L^{*}}>\tau^{\sigma-1} \Rightarrow n^{*}=0
  \end{aligned}
  $$

* $\frac{n}{n^{*}}$ is increasing in $\frac{L}{L^{*}}:$ greater relative demand calls forth domestic supply

* In autarky, entry is proportionate to demand (how many people are tilde vs regular)

* With trade, entry more than proportionate to demand 

  * The market with relatively greater demand for a product is the net exporter of the product
  * Exogenous differences in demand cause pattern of specialization through the increasing returns to scale mechanism (more profitable to be producing goods for consumers that are close to you)

* Missing here is: is it absolute size or relative size that matters? What happens when a country has more tilde and more regular people?

## Helpman-Krugman - Special Case

* Cobb-Douglas upper tier with expenditure share $\alpha$ and homogenous share $1-\alpha$. 

* Homogeneous good is CRS, freely traded, produced in both. This gives us that $w^* = w$

  * CRS, freely traded (prices of good as to equalize), equal prices means unit cost has to be the same, only input is labor, so wages must be the same!

* Market clearing again, exploiting $p=p^*$ and now using $\alpha$, we get 
  $$
  \begin{aligned}
  n p x &=\frac{n}{n+n^{*} \tau^{1-\sigma}} \alpha w L+\frac{n \tau^{1-\sigma}}{n \tau^{1-\sigma}+n^{*}} \alpha w^{*} L^{*} \\
  n^{*} p^{*} x^{*} &=\frac{n^{*} \tau^{1-\sigma}}{n+n^{*} \tau^{1-\sigma}} \alpha w L+\frac{n^{*}}{n^{*}+n \tau^{1-\sigma}} \alpha w^{*} L^{*}
  \end{aligned}
  $$

* In effect a large domestic market serves as a base for exports. We've been able to work only with a highly specialized example; it is probably, however, that "home market effects" of the kind we have illustrated here are actually quite pervasive

* Davis (1998): load up data on manufacturing and agricultural goods and see what their trade costs are. Give these two sectors identical trade costs, then it turns out the home market effect goes away. 



3 main ingredients for all this theory: Demand differences, trade cost (so that where demand is located matters), and increasing (higher demand causes you to be relatively good at making something)



## Empirics 

* These don't really solve the problem in terms of how do I get variation in size that something is happening with scale instead of TFP differences
* Feenstra, Markusen, Rose (2001): gravity regression, differentiated goods have higher elasticity of exports wrt exporter GDP than importer GDP; reverse for homogenous goods
  * Differentiated goods are also those with IRS 
  * Put GDP on right hand side - omitting resistance terms so they're not consistent with proper gravity model. GDP is not randomly assigned - how do I know the reason they have higher GDP is exogenous because they have more tilde people as opposed to something like more sophisticated goods countries have higher GDP  because of TFP differences
* Handson and Xiang (2004): Differences-in-differences test. Higher-GDP countries export realtively more of high-transport cost, low-elasticity-substitution goods
* Davis and Weinstein (2003): Infer "idiosyncratic elements of demand". Does domestic production rise less than one-for-one or more than one-for-one with demand? MORE
  * Assume demand can be idiosyncratic at level below production level
  * Not a robust strategy
* These papers infer demand differences from GDP levels or expenditure patterns, which are eqm objects that may also reflect supply-side differences

## Back to Linder

Linder differs from Krugman 1980 in two important ways

1. Linder predicts that demand generates exports, Krugman predicts demand generate net exports. Helpful typology from Costinot, Donaldson, Kyle and Williams
   * Weak home-market effect: demand generates exports
     * Requires economies of scale
   * Strong-home-market effect: greater demand generates net exports
     * Krugman cannot find parameter values that generate weak home-market effect

2. The Helpman-Krugman formulation emphasizes country size, Linder focused on incomes: "The level of average income ... has .. a dominating influence on the structure of demand ... when we compare demand structures, it is necessary to define goods by specifying quality"
   * Non-homothetic preferences make income levels relevant for consumer expenditure allocations
   * This heterogeneous demand might predict trade flows through intersectoral or intrasectoral (quality) specialization
   * High-income economies might have comparative advantage in income-elastic goods due to a coincidental correlation or a causal home-market - rich countries make fancy stuff because they're technologically sophisticated, so they're good for production reasons, and they happen to be the stuff rich people like. This is the story of Matsuyamu 2000

## Coincidental correlation: Caron Fally, Markusen (2014)



* 

* intersectoral specialization, correlation between income elasticity and skill intensity

* Rich countries have skilled people, and they have high-income households

* Constant Relatively Income Elasticity (CRIE) preferences 

* EK-CDK-CP multi-sector production with intermediates 

  * That demand could affect supply-side is taken off the table
  * Only correlation mechanism, no causal mechanism

* Sector gravity: $\frac{X_{n i k}}{X_{n k}}=\frac{S_{i k} d_{n i k}^{-\theta_{i}}}{\Phi_{n k}} ; \quad \Phi_{n k}=\sum_{i} S_{i k} d_{n i k}^{-\theta_{k}}$

  * Freschet dispersion is sector specific

* Gravity with zero trade costs and no intermediates shows
  interaction of supply and demand characteristics
  $$
  \frac{X_{n i}}{X_{n}}=\sum_{k} \underbrace{\left(\frac{S_{i k}}{\sum_{j} S_{j k}}\right)}_{\text {supply shifters }} \underbrace{\left(\frac{\alpha_{4, k} \lambda_{n}^{-\sigma_{k}}}{\sum_{k^{\prime}} \alpha_{4, k^{\prime}} \lambda_{n}^{-\sigma_{k^{\prime}}}}\right)}_{\text {demand shifters }}
  $$

* Sectoral composition is driving aggregate trade flows
* Correlation between a good's income elasticity of demand and its skilled-labor intensity in production is about 50% 

## Causal HME in Theory: Matsuyama (2019)

* Just like Krugman in lower level.
* Rank sectors by income elasticities, the economy with higher standard of living is a net exporter in higher-ranked sectors
* Comparative statics for productivity improvements and trade costs
* 

**Brief discussion of implicit additive separability**

* Recall utility functions $U(x)$ and indirect utility $V(p,y)
* Explicitly additively separable function $U: \mathbb{R}_{+}^{J} \rightarrow \mathbb{R}$ is $U(x)=\sum_{j} u_{j}\left(x_{j}\right)$
* Bergson ([Burk] 1936 ): If $U$ is quasi-concave, increasing, and explicitly additively separable, then it is homothetic if and only if $u_{j}\left(x_{j}\right)=\alpha_{j} \frac{x_{j}^{\rho}}{\rho}+\beta_{j} \forall j$
  * If you want homothetic demand that's additively separable, have to have this utility function!
* Pigou's Law (1910) (Deaton 1974 ): If the (direct) utility function is additively separable, then the income elasticity of a good is (approximately) proportionate to the price elasticity of that good
  * By writing down a functional form, you're creating a tight linkage between price elasticities and income elasticities - no reason to have this in general economic setting!
* An implicitly additively separable utility function is $\sum_{j=1}^{J} f_{j}\left(x_{j} ; U\right)=1$
  * This class of models is broader 
  * Can have sector specific income elasticity parameters without the price elasticity 

## Dingel - Quality Specialization 

* Why do locations trade with each other? What are the consequences of trade? What are optimal trade policies? 
* What do locations trade with each other? 
  * countries export different products (Ricardo, Heckscher-Ohlin)
  * Countries export horizontally differentiated products (Krugman)
  * Countries export vertically differentiated products
* Is correlated comparative advantage or a causal home-market?
  * Factor abundance differences across locations &rightarrow; specialization
  * Home market effect: income differences across locations lead to specialization 
* Quantifies two mechanisms' roles in quality specialization
  * Use within country variation - go to one data source, and they give you plant level data on many different locations. If you can see factor inputs that plants are using, then you know whether skill abundance is causing it to specialize. Look at cross city variation
  * Results: composition of home market demand explains a large share of specialization, as much as differences in factor usage
  * Variation in income level of neighboring cities to shift demand, geographic variation that generates demand shift, controlling for factor inputs
* Home-market effect: plants with higher-income potential consumers produce higher-priced products, controlling for inputs



## CDKW: The More We Die, The More We Sell?

* Use demographic differences as source of exogenous variation in demand for pharmaceutical drugs
  * Proxy for demand shifters 
* 

