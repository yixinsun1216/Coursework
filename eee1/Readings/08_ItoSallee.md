## Economics of Attribute-Based Regulation

### TLDR

* Attribute-based regulation aims to change one characteristic or behavior of a product, firm, or individual, but it takes some other characteristic or behavior into consideration when determining compliance
  * ex: CAFE standards want to increase the fuel economy of cars, but they take size of each car into consideration
* Fuel-economy regulations are attributed-based in the world's four largest car markets - China, Europe, Japan and US
* Nearly every wealthy country regulates energy efficiency of household appliances, and these are universally attribute-based
* Goal: investigate welfare consequences of attribute-based regulation as opposed to regulations based only on the targeted characteristic 
* Conclude that it is unlikely that attribute basing is justified on efficiency grounds - suspect many ABR are motivated by distributional considerations
  * Ex: size-based fuel-economy regulations can be rationalized as a way of shifting welfare between firms that sell small vehicles and those that sell large vehicles (perhaps in order to favor domestic producers and their consumers)



### 2 Theory

**Consumer Side**

* consumer has unit demand for a durable good with two continuously varying characteristics, $a$ (secondary attribute) and $e$, the levels of which they choose
* Present discounted benefit of services from durable is $F_N(a_n, e_n)$ 
* Exogenous income $I_n$ 
* quasi-linear numeraire good, $x$
* $e_n$ generates externality that is linear in aggregate $e$ with marginal social benefit $\phi$ 
  * Total externality: $\phi\sum_n e_n$ 
* Attribute-based regulation is a mandate that requires $e_n \geq \sigma(a_n)$ - constraint on consumer's optimization problem
  * generally work with a linear attribute-based regulation: $e_n \geq \hat{\sigma}a_n + \kappa$ 
  * $\sigma'(a_n)$ called the attribute slope

**Supply Side**

* Perfectly competitive supply side with no fixed costs per variety
* Consumers choose any bundle of $a$ and $e$ and pay $P(a, e)$ that is equal to marginal cost of $C(a,e)$
* No distinction between changing the attributes of an existing product versus introducing a new variety 
* Interpret changes in product characteristics as reflecting policy-induced shifts in consumer choices 
  * benefit of this is tractability and transparency
  * cost if we do not account for the welfare consequences of policy-induced changes in firm market power



**Consumer Problem**

Consumer ignores externality when making choices
$$
\max _{a_{n}, e_{n}} U_{n}=F_{n}\left(a_{n}, e_{n}\right)-C\left(a_{n}, e_{n}\right)+I_{n}+\lambda_{n}\left(e_{n}-\sigma\left(a_{n}\right)\right)
$$
**Planner Problem** 

Planner puts welfare weight $\theta_n$ on utility of type $n$, which includes the externality, where the mean of $\theta_n$ is normalized to 1
$$
\max _{\sigma\left(a_{n}\right)} W=\sum_{n} \theta_{n}\left(F_{n}\left(a_{n}, e_{n}\right)-C\left(a_{n}, e_{n}\right)+I_{n}\right)+\phi \sum_{n} e_{n}
$$
Consumer's welfare loss from deviating from private optimum is
$$
L_{n}\left(e_{n}-e_{n}^{0}, a_{n}-a_{n}^{0}\right) \equiv U_{n}\left(a_{n}, e_{n}\right)-U_{n}\left(a_{n}^{0}, e_{n}^{0}\right)
$$


Denote deviations from private optima as 
$$
\Delta a_n \equiv a_n - a_n^0 \\\
\Delta e_n \equiv e_n - e_n^0
$$

### 2.1 ABR is an imperfect substitute for compliance trading

<u>Proposition 1</u> Assume that there is competitive compliance trading. If welfare weights are uniform ($\theta_n = 1$), the optimal policy involves no attribute basing. The optimal attribute slope is
$$
\sigma^{\prime}\left(a_{n}\right)^{*}=0 \quad \forall a_{n}
$$

* Intuition: first-best allocation is achieved by flat standard that is set at a level that implies that the market shadow price is equal to $\phi$.
*  In this scenario, there are no distributional concerns, marginal costs are equalized across types by compliance trading, and the only market failure is the externality from $e$. 
* The planner can achieve the first-best allocation by creating a wedge in the choice of $e$ relative to the externality. There is no benefit to creating a wedge in the choice of $a$, which requires that $\sigma'(a_n) = 0$ 
* Consistent with standard principles of Pigouvian taxation



<u>Proposition 2:</u> Assume there is no compliance trading. Then, even if welfare weights are uniform, the optimal linear regulation generally involves attribute basing. If the constraint binds for all $n$, the optimal attribute slope satisfies:
$$
\hat{\sigma}^{*}=\frac{\operatorname{cov}\left(\lambda_{n}, a_{n}\right)}{\phi\left(\frac{\partial \bar{a}}{\partial \hat{\sigma}}-\bar{a} \frac{\partial \bar{a}}{\partial \kappa}\right)}
$$
which is not $0$ unless $\lambda_n$ is uncorrelated with $a_n$ 

* The difference between this case and the case above is that $a_n$ and $e_n$ are now functions of the mandate parameters. In proposition 1, because there is trading and marginal costs can equalize across firms, we treat all the different firms and products as one monolith. Not the case here if there is no trading

* So here, some attribute basing is optimal, even when there are no distributional considerations. This is true as long as the dimension along which the standard can be differentiated is correlated with marginal cost

* Attribute basing is a substitute for compliance trading, but is an imperfect substitute

  * Compliance trading can generate first-best outcomes, but attribute basing can only partially improve MC equalization (unless compliance costs are perfectly predicted by the choice of $a$)
  * Attribute basing achieves marginal cost equalization by inducing distortions in the choice of the attribute for all types, which has an efficiency cost
    * Second-best attribute slope will not be the one that maximizes marginal cost equalization. Instead, it will be less steep; it will trade-off mitigation in the distortion to $a$ for more dispersion in marginal cost

* Common misunderstanding in the non-academic literature: it is desirable for an attribute-based standard to not distort the distribution of the secondary attribute relative to the no-policy baseline

  * An efficient policy will induce a change in the attribute, and an attribute-based policy that preserves the distribution of the attribute from a no-policy baseline is preserving a market inefficiency 

* Attributes that are (1) more closely related to compliance costs and (2) less elastic will be better

  * **Intuition is that you want to activate the least cost option in driving towards the efficiency standard** 
  * **What does it mean that you want the attributes to be less elastic?**

  

### 2.3 Distributional justifications for ABR

<u>Proposition 4:</u> Assume that welfare weights $\theta_{n}$ vary. Then, the optimal linear subsidy involves attribute basing unless $\theta_{n}$ is uncorrelated with $a_{n} .$ The optimal attribute slope is:
$$
\hat{\sigma}^{*}=\left[\left(\frac{\phi-s}{s}\right) \frac{\partial \bar{e}}{\partial \hat{\sigma}}-\operatorname{cov}\left(\theta_{n}, a_{n}\right)\right] / \frac{\partial \bar{a}}{\partial \hat{\sigma}}
$$
**$s = \phi$**

* First term is zero 
* When correlation between $\theta$ and $a$ is positive, optimal attribute slope is negative 
* As the correlation gets stronger, the slope becomes steeper
* As the attribute is more elastic with respect to the policy wedge, the optimal slope is flatter ($\partial a / \partial \hat{\sigma}$ larger in magnitude)  &rightarrow; any distributional gains are achieved at the cost of distorting the choice of $a$ for all types. When the attribute is more elastic, the efficiency costs of distribution are higher. Less redistribution is therefore optimal, and the optimal slope is flatter. 

$s \neq \phi$

* First term non-zero
* First term shrinks as elasticity of the attribute, relative to the elasticity of the target characteristic, rises



## 3 Identifying Attribute Distortions via Bunching

### Data and Policy Background

* Firms must have sales-weighted average fuel economy that exceeds the sales weighted average target of their vehicles, given their weights
* No trading of compliance credits across firms
* Only required to meet this standard in the "target year" of a policy

![image-20201110140129300](C:\Users\Yixin Sun\AppData\Roaming\Typora\typora-user-images\image-20201110140129300.png)



### 3.3 Estimation of Excess Bunching at Notches

* Shows strong evidence of weight manipulation in response to the policy

**First estimate counterfactual distribution as if there were no bunching at the notch points**

* Group cars into small weight bins
* Fit polynomial of order $S$ to the bin counts in the empirical distribution, excluding data at the notches 
* Define initial estimate of the counterfactual distribution as the predicted values from their regression omitting the contribution of the notch dummies
* Need to shift counterfactual distribution upward until the area equals the area under empirical distribution
  * Since excess bunching should come from the "left", and make the conservative assumption that bunching observed at a given notch comes only from the adjacent step in the regulatory schedule

**Estimation of Bunching**

* find statistically significant excess bunching at all notches
* 10% increase in weight
* Heavier automobiles are safer for occupants but more dangerous for pedestrians - BOE calculation shows a 110kg (10%) weight increase leads to an average \$2026 welfare distortion. Associated with extra 103 deaths over the lifetime of those cars



## 4 Comparing Costs and Benefits of Attribute Basing

### 4.1 A Subsidy Policy and Descriptive Evidence from Panel Data

* If a car had a fuel economy higher than the subsidy cutoff, consumers purchasing that car received a direct subsidy of approximately \$700 for kei-cars and \$1000 for other cars 
  * Cars with fuel economy 10% and 20% higher than the subsidy cutoff received more generous subsidies in the form of tax exemptions
* This creates quasi-experimental variation in incentives to change weight ($a$) and fuel economy $(e)$ 

### 4.2 A Discrete Choice Model of Vehicle Redesign

* 





-----------

**Paper Summary**

This paper examines the welfare implications of attribute-based regulation (ABR). ABR aims to change a target characteristic of a product, firm, or individual, but  the stringency of a regulation depends on a secondary attribute. 

The paper begins the analysis with a simple model of consumers who have unit demand for a durable good. The good has a characteristic, e, that generates an externality with a marginal social benefit (think of this as fuel economy), and a characteristic, a, which the standard is a function of (think of this as weight of car).  Comparing the consumer maximization problem to the social planner problem, we see that the ABR produces two wedges: (1) $\lambda$, the cost from the externality that can be corrected through Pigouvian taxation, and (2) $-\lambda \sigma'(a_n)$, an implicit subsidy for $a$. 

From the simple model, the authors lay out several propositions. 

<u>Proposition 1:</u> with competitive compliance trading and no distributional concerns, the optimal policy involves no attribute basing. The intuition here is that because compliance trading equalizes marginal cost across types, there is only a market failure from the externality from the fuel economy standard. The planner can then achieve the first-best allocation by correcting for the wedge created between the consumer and the planner's optimum. 

<u>Proposition 2:</u> assume there is no compliance trading. Then, even without distributional concerns, the optimal regulation generally involves attribute basing. The intuition here is that the ABR is now a (partial) substitute for compliance trading. It is imperfect because unless compliance costs are perfectly predicted by the chosen attribute, attribute basing only partially improves marginal cost equalization. ABR also distorts attributes to achieve this marginal cost equalization, which has an efficiency cost. 

<u>Proposition 3:</u> If $a$ is more elastic with respect to policy, then distortions from ABR will be larger. If $a$ does not respond to policy, there is no efficiency cost. 

<u>Proposition 4:</u> When welfare weights vary (when there are distributional concerns), the optimal subsidy involves attribute basing. They posit that these distributional concerns are a key to why ABR is used in real policies, but it comes at the cost of distorting attribute choices. 

To empirically investigate the costs and benefits of ABR, the paper turns to the Japanese regulation setting. 



