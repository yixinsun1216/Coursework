# Lecture Notes

* What's the welfare cost of using these imperfect policies? Some examples
  * SO2 regulation based only on emission quantities. This is imperfect because data on location and weather should be accounted
  * Flat highway toll prices despite the fact that there are traffic congestions at certain periods of the day
  * Uniform cigarette taxes 
* Research goal: analyze welfare cost of externality-correcting policies, where policies are made under constraints upon variables that are imperfectly correlated with externality 
* Short-run model 

* How the heck did this paper come about
  * Origins of this paper - started with application 3 where they were trying to make this point that emissions are related to how long the car is on the road 
  * As they were working on that, they came upon the $R^2$ result! 
* $R^2$ interpretation here is contingent on KNOWING what causes a wedge, so it's really hard to say what the $R^2$ is with model uncertainty
* Kellogg - EPA fuel economy rating exercise
  * Real fuel economy is not the same as the fuel economy that's used for compliance
  * But there's an error for each car, and the old fuel economy is biased and they're biased down. Missing some welfare implications here that we could try to quantify. Can see this in figure 3
  * Always assuming that they Pigouvian benchmark or whatever variables they're using as the benchmark is unbiased
* Could $R^2$ differences between policies be interpreted as a comparison of policies  
  * Corollary 2 says: Suppose A and B are second-best policies with attribute vectors $f_A$ and $f_B$, as given by proposition 1 under assumptions 1–3. The welfare difference between A and B is proportional to $R^2_A - R^2_B$ (you might want to check the appendix)
* How feasible is it to apply this type of framework to a supply side policy
  * Subscript 6 - Assumption 1 doesn't hold anymore with market power. 
* Flowchart - one of the most awesome things Ryan has ever seen in a paper!
* 

 







----------

# The Use of Regression Statistics to Analyze Imperfect Pricing Policies

### TLDR

* Develop model that characterizes welfare cost of using policies where externality is dependent on a set of variables, but policy is contingent on only a subset of those variables or their imperfect proxies
* set up a standard model of competitive market with goods that produce different levels of externalities
  * Pigouvian tax can restore efficiency
  * But planner faces a constraint, so taxes must be made contingent upon a variable that is imperfectly correlated with the externality
* Look at 4 empirical problems
  * Random mismeasurement - energy efficiency is measured according to lab test procedures which differ from in-use averages
  * Real-time electricity pricing: wedge between MC and MB due to the fact that the marginal cost of generating electricity varies hour by hour, but tariffs do not vary to reflect those costs
  * Regulation of energy-consuming durable goods that have heterogeneous total lifetime utilization
  * Spatial differentiation for CO2 emissions resulting from the use of electric appliances

* Method can be applied more broadly. Key data requirement is some measure of the distribution of the externality (or other efficiency wedge) and its correlation with the variables upon which policy is contingent 



## 2 Theory for Deriving Sufficient Statistics

### 2.1 Model Set up

* Representative consumer in a perfectly competitive market
* Economy has products indexed $j = 1, ...,J$
* $U\left(x_{1}, \ldots, x_{J}\right)$ twice differentiable, increasing, and weakly concave in each argument
* $C\left(x_{1}, \ldots, x_{J}\right)$ twice differentiable, increasing, and weakly convex in each argument
* Exogenous amount of income in the economy: $M$
  * All remaining income is consumed in a quasilinear numeraire, $n$ 
* No technological change and do not model endogenous entry and exit of products into the market &rightarrow; short run model
* Market failure which leads market to choose quantities so that there is a wedge, $\phi_j$ - this is fixed and unchanging with respect to policy intervention, and total social inefficiency is sum of these wedges across goods: $\phi=\sum_{j=1}^{J} \phi_{j} x_{j}$
  * Can think of $phi_j$ as marginal social damage per unit of $x_j$ 

<u>Assumption 1.</u> Marginal social damages from each product are fixed with respect to tax vector, $t$



**Consumer Problem**
$$
\begin{aligned}
\max _{x_{1}, \ldots, x_{J}} Z &=U\left(x_{1}, \ldots, x_{J}\right)+n \\
& \text { s.t. } \sum_{j=1}^{J}\left(p_{j}+t_{j}\right) x_{j}+n \leq M+D
\end{aligned}
$$

* planner imposes taxes $t_j$
* Revenue is recycled lump-sum to consumers through a grant $D$

<u>FOC:</u>
$$
\frac{\partial U}{\partial x_{j}}=p_{j}+t_{j}
$$


**Planner's Problem**
$$
\max _{t_{1}, \ldots, t_{J}} W=U\left(x_{1}, \ldots, x_{J}\right)+M-C\left(x_{1}, \ldots, x_{J}\right)-\sum_{j=1}^{J} \phi_{j} x_{j}
$$
<u>FOC:</u> 
$$
\frac{d W}{d t_{j}}=\sum_{k=1}^{J}\left(\frac{\partial U}{\partial x_{k}}-\frac{\partial C}{\partial x_{k}}-\phi_{k}\right) \frac{\partial x_{k}}{\partial t_{j}}=\sum_{k=1}^{J}\left(t_{k}-\phi_{k}\right) \frac{\partial x_{k}}{\partial t_{j}}=0
$$
FOC holds iff $t_j = \phi_j \quad \forall j$ &rightarrow; Pigouvian benchmark



**Planner's Problem with Constraint**

Constraint is: $t_j = g(f_j; \theta)$ where $f$ is some vector of exogenous attributes of the product, and $\theta$ are parameters to be chosen by the planner
$$
\begin{aligned}
\max _{\theta} & W=U\left(x_{1}, \ldots, x_{J}\right)+M-C\left(x_{1}, \ldots, x_{J}\right)-\sum_{j=1}^{J} \phi_{j} x_{j} \\
\text { s.t. } t_{j} &=g\left(f_{j} ; \theta\right) \forall j
\end{aligned}
$$
the solution here, $t_j = g(f_j; \theta^*)$ is the second-best

Restrict attention to situations where $g(f_j; \theta)$ can be written as linear in parameters



### 2.2 Characterizing Deadweight Loss

* Characterize the welfare loss of moving from the Pigouvian benchmark $t_j = \phi_j$ to $t_j = \tau_j$, where $\tau_j$ is a generic tax schedule. Call this $DWL(t = \tau)$ 

<u>Assumption 2</u>: Demand derivatives $\frac{\partial x_{j}}{\partial t_{k}}$ are constant between $\phi_{j}$ and $\tau_{j}$ for all $j$ and $k$.

From this assumption, we get that the efficiency loss incurred from imposing any arbitrary tax schedule $\tau$ in lieu of the Pigouvian tax schedule is
$$
W(t=\phi)-W(t=\tau) \equiv D W L(t=\tau)=-\frac{1}{2} \sum_{j=1}^{J} \sum_{k=1}^{J}\left(\tau_{j}-\phi_{j}\right)\left(\tau_{k}-\phi_{k}\right) \frac{\partial x_{j}}{\partial t_{k}}
$$
<u>Assumption 3:</u> 

(a) Tax errors $e_j$ are uncorrelated with own-price derivatives

(b) Products of tax errors $e_je_k$ are uncorrelated with price derivatives. Holds if externalities, conditional policy, are orthogonal to substitutability. 

(b') cross-price derivatives are 0. Aka no substitution across products



### 2.3 Welfare Statistics when DWL is proportional to squared tax errors

With assumptions 1, 2, 3a, and 3b, and assuming $\sum_{j=1}^{J} e_{j}=0$
$$
\mathrm{DWL}=-\frac{1}{2} \frac{\overline{\partial x_{j}}}{\partial t_{j}} \sum_{j=1}^{J} e_{j}^{2} \tag{9}
$$
With 3a instead of 3b we get 
$$
\mathrm{DWL}=-\frac{1}{2}\left(\overline{\frac{\partial x_{j}}{\partial t_{j}}}-\frac{\overline{\partial x_{j}}}{\partial t_{k}}\right) \sum_{j=1}^{J} e_{j}^{2} \tag{10}
$$

* (9) shows the central role for minimizing a sum of squared tax errors

* (10) is still proportional to sum of squared tax errors, but it is multiplied by the difference in the average own-price and average cross-price derivative. 
* Solution to the planner's constrained problem in equation 5 is the same as minimizing the DWL in (10) subject to the same constraint. Therefore, whenever the policy constraint can be written as a function that is linear in parameters, minimization of deadweight loss is the same as minimizing the sum of squared residuals in a regression of the true externalities on the tax rates



<u>Corollary 1.</u> Under Assumptions 1 to 3 , the $R^{2}$ from the OLS fit of $\phi_{j}$ to $f_{j}$ represents the percentage of the welfare gain of the Pigouvian tax (relative to a baseline of a uniform unbiased tax
$$
R^{2}=\frac{D W L\left(t=\alpha^{O L S}+\beta^{O L S} f_{j}\right)-D W L(t=\bar{t})}{D W L(t=\phi)-D W L(t=\bar{t})}
$$


**Interpreting assumptions about cross effects**

* 3a: strength of own-price derivatives is not correlated with a product's tax error; aka whatever factors that determine the externality but are omitted from the policy function do not also indicate stronger or weaker own-price responses
  * Important when products are demanded in much larger quantities than others
* 3b': applies to markets where products are not substitutes or complements. 
* 3b: difference between the errors in the tax rates between two products is no smaller or larger when two products are close substitutes 
  * Errors in tax rates represent the residual variation of the externality, after conditioning on the attributes upon which the policy is contingent, $f$ 

* 



## Application 1: Noisy Energy Efficiency Ratings





--------------

**Paper Summary**

This paper develops a model that can characterize the welfare cost of using policies where the externality depends upon a set of variables, but the policy is set using a subset of those variables. To do this, they set up a a standard model of a competitive market where the consumer chooses from a bundle of goods that produce different levels of externalities. Consumption deviates from the social optimum because of this externality, or wedge. To model the policy choice, they analyze a planners problem where the planner faces a constraint, and thus a tax policy is set according to a variable that is a proxy for the externality. By giving the reader a cookbook/choose your own adventure, the paper builds a toolkit for characterizing welfare when faced with different assumptions. 

The two baseline assumptions are:

1. The marginal wedge/externality is fixed with respect to prices 
2. Demand and supply are linear over the relevant range (which is necessary to use the Harberger method)

Under these two assumptions, they can write the deadweight loss of a deviation from the Pigouvian benchmark, and can decompose this into the own and cross effects with respect to the tax. The equation they derive here though is difficulty to implement, since it requires knowledge of the complete demand matrix. 

To simplify the cross-price derivatives, they add assumption 3:

​	3a. The strength of own-price derivatives is not correlated with a product's tax error

​	3b. Difference between the errors in the tax rates between two products is no smaller or larger when two 		products are close substitutes 

​	3b': Cross-price derivatives are zero, aka there is no substitution across products (strong version)

When the strong version holds, the cross effects of the DWL drop out. Under the weaker version, the cross-price derivatives between pairs of products are uncorrelated with the product of their tax errors, and the cross effects are proportional to the own effects. This allows for an OLS interpretation of welfare effects, where the R2 from a regression of the wedge on the proxy variable is a measure of the welfare loss. They show that even without assumption 3, R2 can give useful bounds on the welfare implications of a policy.

In the second part of the paper, they apply their cookbook to four different settings that use different combinations of their assumptions. 

1. The CAFE program changed ratings substantially in 2008, but CAFE program still uses the less accurate original rating system from 1978. The paper thinks of the old rating system is a white noise mismeasurement of the truth that the policymaker must base policy upon. They argue this is a situation in which Assumptions 1-3 (weak version) hold. The R2 from a regression of the externality from carbon emissions on the tax has a welfare interpretation. They find that 97% of the welfare gain of the Pigouvian tax is retained by this second-best policy. 
2.  There is a wedge between the marginal cost and marginal benefit in electricity markets because of the marginal cost of generating electricity varies hour by hour, but tariffs do not vary in real time to reflect those costs. With the advent of smart meters, real-time pricing (the optimal pricing mechanism) is feasible, but receives a lot of pushback from regulators. Regulators instead opt to use tariff structures like on vs off-peak prices. They make an argument that assumptions 1-3 (strong version) hold here approximately, due to the literature on the inelasticity of demand for electricity. They find that tariff structures commonly used by regulators do not improve efficiency much, with R2 staying below .43 for different specifications.
3. CAFE standards target energy efficiency, but do not account for heterogeneity in the longevity of products with the same energy efficiency rating. Setting up a framework to take into account both fuel economy and vehicle longevity, and analyze both when assumption 3 (weaker version) does and doesn't hold. Interpreting R2 as an upper bound on the welfare gains, they find that even the upper bound is quite low at 20%. 
4. Many policies that target pollution externalities are uniform across space, even though these externalities are a function of many location-specific variables. Using the case of a tax on new refrigerators, where the externality of a given refrigerator depends on the location of its use, the authors argue that this is a setting where the cross-price elasticity does not simplify. However, the authors still derive a welfare interpretation of a within-R2 from a fixed effects regression. They find values of 0.96 and 0.9 (depending on the specification), demonstrating that welfare losses from not accounting for spatial heterogeneity are small. 



**Discussion**

There was a lot of information crammed into the theory section, but the authors did a good job of emphasizing the intuition. It was especially helpful to have the 2.6 summary section and the flowchart, which guided me well as I read through the applications. 

The tools shown here seem incredibly useful for researchers and policymakers, since the key data requirements are a measure of the distribution of the externality/wedge and its correlation with the variables upon which policy is based on. I appreciate their derivations of how to interpret R2 when assumption 3 does not hold, which is often the case in practical applications.

While the refrigerator analysis did not yield big losses from a failure to account for spatial heterogeneity, I would guess that for empirical settings such as plastic pollution, air pollution, or hazardous waste dumps, it would matter a whole lot. I recognize that this would also require applying a similar setup analyze supply side policies, which would be interesting in its own right. 