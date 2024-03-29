https://voxdev.org/topic/energy-environment/do-india-s-farmers-use-too-much-water

## TLDR

* India is now the largest user of groundwater in the world, extracting more in a year than in the US and China combined - WHAT??
  * Cost of long boom has been a corresponding depletion of natural capital, with a rate of groundwater decline faster, in parts of India, than anywhere else in the world
* Groundwater has no price and property rights over groundwater are not defined. Instead of pricing electricity (used to extract groundwater) above private cost, Indian states price electricity at or near zero, but then ration the supply of power to farmers to limit their groundwater use. The states that have adopted this regime have a combined population of 585 million people and product 65% of the country's agricultural output

## Rationing in Rajasthan

* Rajasthan has an agricultural share of state product of over 25% 
* Agricultural electricity tariff in Rajasthan is Rs 0.9 per kWh (8 US cents) and a distribution cost of Rs 6.20 per kWh (10 US cents). Thus the marginal price of electricity is 15% of private marginal cost, before even accounting for any value of water
* Quantity of electricity supply to agricultural feeders is fixed at six hours per day over the whole state
* Figure 2: survey data shows that farmers mostly report supply of 6 hours of electricity per day, while the modal usage is 5 hours per day &rightarrow; constraint binds!
* State regulates both the number of agricultural pumps and size of pumps to prevent farmers adding more or larger pumps, which would effectively make the ration useless

## 3. Model 

Farmer's Problem: 
$$
\begin{aligned}
\Pi_{i}\left(L_{i}, X_{i}, K_{i}, H_{i}\right)=& \max _{X_{i}, K_{i}, H_{i}} \Omega_{i} F\left(L_{i}, X_{i}, K_{i}, W_{i}\left(H_{i}, D_{i}\right)\right)-w_{i} X_{i}-r_{i} K_{i}-p_{E} P_{i} H_{i} \\
& \text { subject to } \quad H_{i} \leq \bar{H}
\end{aligned}
$$
Rewrite farmer's problem with just water as the argument:
$$
\widetilde{\Pi}_{i}\left(W_{i}\right)= \max _{H_i} \Omega_{i} \widetilde{F}_{i}\left(W_{i}\right)-w_{i} X_{i}^{*}-r_{i} K_{i}^{*} \\
 \text { subject to } \quad H_{i} \leq \bar{H}
$$
**Planner's Problem:**
$$
\max _{\bar{H}} \sum_{i}\left[\widetilde{\Pi}_{i}\left(W_{i}\left(\bar{H}, D_{i}\right)\right)-c_{E} P_{i} \bar{H}-\rho \frac{P_{i}}{D_{i}} \bar{H} \lambda_{W}\right]
$$
The first-order condition for an optimal ration $\bar{H}^{*}$ is
$$
\underbrace{\sum_{i} \frac{d \widetilde{\Pi}_{i}\left(W_{i}\left(\bar{H}^{*}, D_{i}\right)\right)}{d \bar{H}^{*}}}_{\text {Marginal benefit }}=\underbrace{\sum_{i} c_{E} P_{i}+\rho \frac{P_{i}}{D_{i}} \lambda_{W}}_{\text {Marginal social cost }}
$$

* Optimal ration is increasing in farmer productivity and the marginal return to water
* Optimal ration is decreasing in the cost of power and the cost of water extraction

**Pigouvian Benchmark** 

* Optimal Pigouvian benchmark sets price of power $p_E = c_E$ and price of water $p_W = \lambda_W$  &rightarrow; too costly to monitor water, so they consider a Pigouvian benchmark that only prices power

$$
p_{E i}^{*}=c_{E}+\rho \frac{1}{D_{i}} \lambda_{W}
$$

* They show that the optimal uniform ration will achieve weakly lower surplus than a Pigouvian pricing regime 
* Since no uniform ration will be efficient for all farmers, there is allocative loss from forcing heterogeneous farmers to have the same level of power use. This allocative loss will be greater when productivity is more variable 

**Relation of profits to groundwater depth**

* FOC condition above is hard to estimate empirically
* the marginal benefit, $$\sum_{i} \frac{d \widetilde{\Pi}_{i}\left(W_{i}\left(\bar{H}^{*}, D_{i}\right)\right)}{d \bar{H}^{*}}$$, can't be calculated because the ration doesn't vary 

* Depth of groundwater can be used as stand-in for electricity ration to calculate how the ration changes farmer profits

$$
\begin{aligned}
\sum_{i} \frac{d \tilde{\Pi}_{i}\left(W_{i}\left(\bar{H}, D_{i}\right)\right)}{d \bar{H}} &=\sum_{i} \frac{d \widetilde{\Pi}_{i}}{d W_{i}} \frac{d W_{i}}{d \bar{H}} \\
&=\sum_{i} \frac{d \widetilde{\Pi}_{i}}{d W_{i}}\left(-\frac{d W_{i}}{d D_{i}} \frac{D_{i}}{H_{i}}\right) \\
&=\sum_{i}-\frac{d \widetilde{\Pi}_{i}}{d D_{i}} \frac{D_{i}}{H_{i}}
\end{aligned}
$$

## 4. Marginal analysis of the ration

$$
\begin{aligned}
\Pi_{i c} &=\beta_{o}+D_{i} \beta_{1}+X_{i c}^{\prime} \beta_{2}+\alpha_{s}+\alpha_{p}+\epsilon_{i c} \\
D_{i} &=\delta_{0}+Z_{i}^{\prime} \delta_{1}+\eta_{i c}
\end{aligned}
$$

* Hedonic instrumental variables regression to estimate the effect of well depth on farmer profits
* $\beta_1$ is the coefficient of interest, $\frac{d\Pi}{dD}$, the estimated effect of well depth on profits. Assumed to be a constant - seems reasonable since it's a geological relationship rather than related to productivity of the farmer. Although perhaps this has to do with how efficient/old the pumps are?
* "the advantage of using a cross-sectional, Ricardian approach is that it can recover long-run elasticities of profit with respect to water, net of farmer adaptation ... We would expect that all inputs have been carefully optimized to the local availability of water" - **what exactly does this mean?**
* Worried that there is bias due to endogeneity or omitted variables &rightarrow; people who's water depth is bigger perhaps is more powerful or more productive, hence why they were able to get that land in the first place
* Estimate using instrumental variables. Use geological characteristics: type of rock beneath farmer's location, length of underground fractures near a farmer, and functions of these variables, such as type of aquifer system
  * Exclusion restriction: geological variables do not have a direct effect on farmer's profits, other than through their effect on groundwater levels. Control for surface characteristics like elevation, slope, and measures of soil quality
  * **I don't see how this actually gets rid of the endogeneity issue. Since there is selection onto the land in the first place**
  * Use machine learning to select instruments since the geology here is quite complicated

**Empirical Results**

![image-20201030140518352](C:\Users\Yixin Sun\AppData\Roaming\Typora\typora-user-images\image-20201030140518352.png)

* A one standard deviation increase in depth decreases profit by INR 8,900 per Ha in the dry season. This reduction in profit equals 14 percent of output per Ha (Table $1,$ panel $\mathrm{A}$ ) or, for an average farmer, $15 \%$ of household income from all sources over the whole year. A scarcity of groundwater thus significantly harms agricultural livelihoods.
* Effect of depth on profits is a reduced-form estimate that obscures how farmers adapt their production to water scarcity
  * Farmers with deeper wells achieve lower yields and output
  * Farmers adapt to scarcity of groundwater through disinvestment: less likely to use HYV seeds, less likely to use efficient but capital intensive irrigation techniques, and more likely to report their crops as under-irrigated

**Compare marginal benefits and costs of increasing the ration**

* Marginal benefits taken from preferred estimate of 8.87 thousand per Ha decrease in profit per std. deviation of depth 
* Estimate opportunity cost of water $\lambda_w$, which depends on how water extraction today affects groundwater levels tomorrow as well as on the returns to water in agriculture and the discount rate. They use a simplified dynamic version of their production model to calculate this. They use a discount factor of $\beta = 0.90$ &rightarrow; **seems outrageously high to me??**
  * Skip the model they use to calculate this but it is Appendix E
* Figure 4: compares estimated marginal benefit of increasing the ration by one hour to the estimated social marginal cost
  * First bar is marginal benefit from previous regression
  * Second bar is private marginal cost
  * last three bars are private marginal cost + opportunity cost of water at different discount rates
* We see a near equality of marginal benefits and social marginal costs at a discount factor of $\beta = 0.90$, which implies that the status quo ration is set at a roughly optimal level, or somewhat too high, judging by point estimates alone
  * A discount factor of $\beta = 0.82$ would exactly rationalize the level of the ration as socially efficient, among uniform rations

## 5. Structural Analysis of Rationing and Counterfactual Reforms

* Structurally estimate distribution of productivity 

* Extraction function is fully observed in the data - $H_i$ are endogenous, $\rho$ is a physical constant, observe $P_i$ and $D_i$ 

* Need to estimate production - Cobb Douglas function
  $$
  y_{i c}=\alpha_{L} l_{i c}+\alpha_{X} x_{i c}+\alpha_{K} k_{i c}+\alpha_{W} w_{i c}+\omega_{Y i c}
  $$

  * The residual has several parts: $\omega_{Y i c}=\underbrace{W_{E i c} \beta_{E}+\omega_{i c}}_{\omega_{E i c}}+\epsilon_{Y i c}$ 
  * farmer-special shock $\omega_{ic}$ and effect of known output shifters $W_{Eic}$ 
  * $E$ signals 'early' because farmer observes both components early in the season and then makes input choices
  * The crop is then hit by $\epsilon_{Yic}$ at harvest, which represents either a late-season productivity shock or measurement error in output
  * Econometrician observes $W_{Eic}$ but neither shock - what does it mean to lump $W_{Eic}$ with the errors instead of with the observables?
  * Input choices are endogenous to the $\omega_{ic}$ shock observed by farmer but not the econometrician

* Estimating equation with inputs:
  $$
  \begin{aligned}
  y_{i c}=& \alpha_{L} l_{i c}^{o}+\alpha_{X} x_{i c}^{o}+\alpha_{K} k_{i c}^{o}+\alpha_{W} w_{i c}^{o} -\sum_{J} \alpha_{j i c} \epsilon_{j i c}+W_{E i c} \beta_{E}+\omega_{i c}+\epsilon_{Y i c}
  \end{aligned}
  $$

  * Estimate with 2sls using farmer-by-crop data

  * Main concern: endogeneity of input choices to productivity 

  * Solution: use four sets of variables as instruments, based on 

    1. geology
    2. household demographics
    3. land ownership
    4. input prices

    **How could you possibly argue exogeneity here???** See footnote 18. Maybe a bunch of okayish instruments that rely on different sources of variation makes one good instrument?

* To analyze distributional effects of rationing, we need to estimate not only output elasticities but also farmer productivities

  * residuals from above will overstate dispersion in productivity, since they contain measurement error in output and inputs
  * Solution: deflate the estimated dispersion of productivity to remove the effects of measurement error and cross-farmer differences in input prices or shadow prices. Key economic assumption is that farmers face the same shadow prices across all crops they plant. This correction will reduce the dispersion of TFP and is thereby conservative, since it will tend to lessen possible efficiency gains from Pigouvian reform

**Model Estimates**

* Estimate coefficients on water, land, labor, and capital inputs
* Graph distribution of productivity across farmer-crops

**Shadow value of the ration**

* Calculate heterogeneous effects of status quo ration on farmers using the model estimates 
* Use model to calculate the shadow cost of the ration for each farmer. Shadow cost of the ration is the price of electricity, in INR per kWh, such that each farmer, if unconstrained, would optimally choose to use the rationed amount of power. &rightarrow; **How do you actually calculate this??**
* Figure 6: shadow cost of the status quo ration. Ration causes a scarcity of water, and puts a large shadow value on additional electricity use on average
  * Shows remarkable amount of dispersion
  * Heterogeneity in the model casts the main finding of the marginal analysis in a new light: even though the six hour ration is roughly efficient, on average, it is set too high for most farmers, and far too low for a substantial minority, and the dispersion illustrates the degree of misallocation of water across farmers
* Is what's happening here that farmer's have relatively **flat marginal benefits curves**, and there's a bunch of them at different levels due to the heterogeneity in productivity. So then the benefits and losses cancel each other out, but this masks the fact that we are restricting quantities at the wrong place

**Counterfactual effects of Pigouvian reform**

* Take land and labor inputs are fixed rather than endogenous (makes sense here where land markets are thin and 2/3 of labor is suppled by hh on their own farms)

1. Ration set at optimal, surplus-maximizing level, rather than status quo of six hours
2. Pricing regime that lifts the ration and sets the price of electricity at private marginal cost
3. Pigouvian regime that lifts the ration and sets the price of electricity at social marginal cost (including the opportunity cost of water in the price of power)

* Also consider 3 simple regimes that allow states to make transfers to refund the additional revenue from Pigouvian pricing
  1. Flat (uniform) transfers across farmers
  2. Transfers pro rata on the basis of land size
  3. Transfers pro rata on the basis of pump capacity 

**Counterfactual results on efficiency**

![image-20201102095500661](C:\Users\Yixin Sun\AppData\Roaming\Typora\typora-user-images\image-20201102095500661.png)

* Ration is set at roughly the efficient level, or slightly too high  (Table 4, Panel B, column 2)
* Rationing has a large efficiency cost - mean surplus is INR 10,000 per farmer-crop. Pigouvian pricing increases surplus by roughly INR 4,600 per farmer-crop 
* Surplus gains under a Pigouvian regime are due to increases in productivity, not water conservation - under Pigouvian regime, farmers extract nearly the same amount of water using 20% less power. This is because farmers with shallower wells, who can get more water per unit power, run their pumps more, increasing water extracted per unit power 
* Increase in profits comes mainly from an increase in agricultural productivity 

**Farmer heterogeneity in response to Pigouvian reform**

* Figure 7: average change in profit, before any compensating transfers, due to a reform that replaces rationing with Pigouvian pricing. Nearly ALL FARMERS LOSE FROM REFORM, before transfers, since electricity prices are more than tenfold higher
* Average change in profits shows a skewed, U-shaped relationship with land size
* For low levels of landholding, productive farmers lose more than unproductive farmers; because they are more productive, it is optimal for these farmers to keep using higher amounts of water after the reform, despite that
  water is newly costly. 
* At high levels of landholding, however, productive farmers gain from reform, even before transfers. The reason is that productive farmers with large landholdings are likely to have been heavily constrained under the rationing regime. 
* A farmer that faced a high shadow cost of the ration, if sufficiently large and productive, may profit enough from the lifting of the ration to more than offset the roughly tenfold increase in electricity prices.
* Shows how difficult it is for the state to set compensatory transfers, since state cannot observe productivity

**Counterfactual results on redistribution**

* Direct effect of Pigouvian reform is regressive, since lifting the ration benefits most the farmers who are productive and have ample land and shallow groundwater
* State cannot target on productivity, a key determinant of the gains from reform, and therefore, leaves a large number of farmers worse off



___

## Weitman 1977: Is the Price System or Rationing More Effective in Getting a Commodity to Those Who Need It Most

3 main elements of his model:

1. Provided a measure of each consumer's relative need and of the ideal allocation based on that need. Note that he uses need, rather than preference, because he is specifically thinking about goods such as housing or water rather than widgets, aka when distributional issues are important 
   1. Need here s the amount that a person would purchase if all consumers had equal incomes and price clears the market
2. Social objective function, which is the quadratic loss between ideal and actual allocations
3. Limited-information assumption that constraints the government from simply distributing the commodity according to the ideal allocation and forces the government to choose an allocation system 

"There is a class of commodities whose just distribution is sometimes viewed as a desirable end in itself, independent of how society may be allocating its other resources. While it is always somewhat arbitrary where the line should be drawn, such "natural right goods" as basic food and shelter, security, legal aid, military service, medical assistance, education, justice, or even many others are frequently deemed to be sufficiently vital in some sense to give them a special status. The principal of limited dimensional equity in the distribution of a commodity is an open violation of consumer sovereignty."

* Find that price system has greater comparative effectiveness in sorting out the deficit commodity and in getting it to those who need it most when wants are more widely dispersed or when the society is relatively egalitarian in its income distribution. The price mechanism has greater effectiveness in screening out the deficit commodity and in funneling more of it to those who need it relatively more.
* Conversely, rationing is more effective as needs for the deficit commodity are more uniform or as there is greater income inequality, because it essentially prevents those with larger incomes from monopolizing consumption of the commodity in question
* I think the intuition here is that Weitzman's notion of need is affected by income and your own idiosyncratic need for a good. So when there is no income inequality, prices are effective at allocating the good because willingness to pay is an efficient measurement of the need of an individual. However, when there is huge income inequality, a rationing scheme essentially prevents those with larger incomes from monopolizing consumption of the commodity in question



----





## Class Discussion

* Picking a ration is really conditional on choosing the right discount rate. Their dynamic model work is in Appendix E. They're assuming the shadow value is constant as a function of depth and water capacity. Shadow value is a marginal value which changes depending on the stock. Potentially has a big impact on what this look
* Thinking deeply about equity vs efficiency - Josh
  * How do we want to approach formalizing these models
  * Bread and butter econ social welfare function - it's a money metric utility function where you add up everyone's surplus. Implicitly assuming that (1) you'll weight everyone equally, and (2) marginal utility income is the same
  * Rawlsian social welfare - heavily illuminated by this idea of think about yourself as being born with a veil of ignorance. So you really want to care about the worst off person in society
* Nathaniel Hendren Harvard. Amy Finkelstein came out with paper - intuitive discussion of marginal value of public funds 
* Carbon externalities: when we think about pricing carbon, has there been work on the most equitable way to impose a carbon tax. What does the demand side look like?
  * Pigou creates loser - a paper later in the class
* There's two types of uncertainty that we usually see empirical work, the uncertainty of which model specification is correct, and the confidence interval around our target parameter. Taking this paper as an example, they choose .9 as the discount factor for their preferred specification and then report results accordingly, and then have robustness checks. But I guess my question is should we be thinking about how we report uncertainty generally? I think I'm very influenced by polling results with this election in thinking about how we report uncertainty to the media
  * We all make modelling assumptions and all our models are simplified. Tricky part is trying to figure out what assumptions and simplifications are fine and which ones are material and not ok. Ex: what you worry about with the agricultural production in this paper is that the notion of who's high and who's low productivity is driven by the Cobb-Douglas production function. 
* Tax on water would be very different than tax on electricity. 