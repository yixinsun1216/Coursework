# Pigou Creates Losers

### Lecture Notes

* Very useful literature review
* Internalities 



Economic theory states that efficient-enhancing policies create enough new surplus to compensate all losers, so that these policies are Pareto improving. However, this concept that a tax combined with a transfer system can make everyone better off has yet to capture the public imagination (nor that of most policy-makers it seems). This paper offers one resolution to this seeming discrepancy by highlighting the role of implementation constraints in the transfer system. It offers a necessary condition that has to be met for a Pareto improvement to be feasible, a condition that can be taken to the data. The paper then tests this condition in the case of a gas tax in the US, where targeted transfers are based on household demographics, income, and geography. 

The theoretical underpinning of this paper considers a policy aimed at correcting an externality. This then produces heterogeneous burdens on the consumers, and the target scheme must deliver bigger transfers to those with bigger burdens in order to achieve a Pareto improvement. Some definitions important for the the main result are:

* Average funding gap: initial cost of the policy (total burdens levied on everyone) minus the total revenues raised, divided by the number of consumers. 
* Average efficiency gain: average gains enjoyed by consumers who bear the policy burden
* Targeting error: gap between initial burdens and the transfer

The paper then gives the main result (condition 1): a Pareto improvement is not possible if the average absolute targeting errors exceed twice the average efficiency gain in the market minus the average funding gap. Intuitively, two times the average efficiency gain minus the funding gap gives the total efficiency gain of the market, and also is the "budget" for how much targeting error is allowed. This shows that Pareto improving transfer scheme is a prediction problem, where the size of the targeting error (and thus the feasibility of Pareto improvement policy) is based on the ability to accurate predict the policy burden. 

This framework is applied to a marginal increase in an externality-correcting tax, where the initial policy burdens are the consumer surplus losses from an increase in prices. To test this empirically, the following pieces of data are required:

1. Estimate of the distribution of baseline consumption of the good
2. Knowledge of the correlation between baseline consumption and covariates that can be used as a transfer scheme
3. Estimate of the own-price derivative
4. Estimate of the size of the externality

Investigating how the condition holds in the case of a gas tax, the author constructs the necessary estimates using data from the Consumer Expenditure Survey (CEX), gas price data from the EIA, and price elasticities taken from the literature. Then simple regressions of consumer burden on the variables used for targeting transfers provides estimates of the targeting error. The paper provides estimates of the least absolute deviation (LAD) regressions, which minimize non-squared errors to match the theory, OLS estimates, and estimates using lasso to select covariates. These regressions provide similar estimates of around \$45 per household for the average targeting error. Comparing this to the average welfare gain of \$8.25, condition 1 certainly does not seem to hold. 

The paper then goes onto explore a few "next steps":

* When might a Pareto improvement be achievable?
* What happens if the transfers do not use all of the revenue, or if extra revenue is taken from general funds to supplement the transfers?
* What type of transfer scheme would maximize political support for a tax?
* What if covariates used for targeting are endogenous? 



**Discussion**

This paper was well structured, making good use of "message titles" in the section headers to give coherent guidance to the reader. The main condition itself was simple but powerful, and presented in a way that made it easy to understand how it can be implemented empirically. This seems to be a very useful tool as a first pass for policy researchers in evaluating the impact of a tax, since the data ingredients are readily available in many cases. Figure 1 seems especially useful, especially if it was broken out by covariate characteristics. 

While Sallee's critique was pointed and powerful, his long discussions and "next steps" were impressive in opening up the scope for improvement. Pointing out a problem is easier than offering solutions, and while Sallee did not have all the answer's, he certainly gave an impressive first pass at avenues for improvement.

Some Questions:

1. Is it difficult to incorporate heterogeneous price elasticities into this framework? For example, using price elasticities that differ depending on the income level of the household? My intuition would be that this would  (1) be more realistic and (2) mechanically increase the predictive power, therefore decreasing the targeting error.  
2. Excuse my lack of public finance knowledge, but what exactly are the implications of an "infinitesimal positive tax"? 
3. I second Thomas's question, "Moreover, the authors present the problem as a prediction issue of c_i  (i.e. the initial consumption) on a set of covariate X_i, but if you  predict perfectly c_i with a large amount of observable X_i, then why  would it be different than to use c_i (i.e. consumption) for  incentives??" - is there some notion that we want to only reach "almost-Pareto improving" rather than 100% Pareto improvement?

 

### Model of Pareto Transfers

**Condition 1:** Let $c_{i}$ be the private burdens from a policy, $N$ be the number of agents in the market, $T\left(\mathbf{X}_{i}\right)$ be a transfer scheme, $\bar{\Delta}$ the average funding gap, and $\bar{g}$ be the average
efficiency gain accruing to those in the market. A Pareto improvement is not possible if the average absolute targeting errors exceed twice the average efficiency gain in the market minus the average funding gap; i.e., if
$$
\frac{1}{N} \sum_{i}\left|c_{i}-T\left(\mathbf{X}_{i}\right)\right|>2 \bar{g}-\bar{\Delta}
$$
then a Pareto improvement is not possible.

* Idea is that any targeting scheme will create some winners and losers. The condition asks whether there is enough efficiency gains $\eta G$ in the market  to cover all of these losses, if by happy coincidence gains are distributed perfectly so as to offset losses net of the transfers. This is why the condition is necessary, but not sufficient, for a Pareto improvement to be possible

* Illustrates how the design of a Pareto improving transfer scheme is inherently a prediction problem. If variation in policy burdens can be predicted accurately enough with the set of variables included in $\mathbf{X}$, then a Pareto improvement might be possible
* Apply this to the policy action in question: a marginal increase in an externality-correcting tax. The initial policy burdens, $c_i$ are the consumer surplus losses from the increased prices

* To check this condition, what data do we need?
  1. Estimate of the distribution of baseline consumption of the good
  2. Knowledge of the correlation between baseline consumption and covariates that can be used as a transfer scheme
  3. Estimate of the own-price derivative
  4. Estimate of the size of the externality



### Consumption Data

* Consumer Expenditure Survey - nationally representative sample of US households from 1996 to 2016



### A gasoline tax creates losers

* Model a small tax increase of 10 cents on motor fuels, under the assumption that the carbon externality from motor fuel consumption is not corrected at all prior to the tax
* (3) Translate 10 cent gasoline hike into a percentage price change using the average retail gasoline price facing the consumer unit at the time of the survey in its geographic location. Then use a gasoline price elasticity of -0.4, interpreted as a long-run price elasticity, to translate this price change into a change in gallons of fuel consumed
* (4) Use EPA's conversion factor to determine the tons of carbon emitted per gallon of gasoline consumed, and then multiply by \$40 for the social cost of carbon 
* (1) welfare loss calculated using a linear approximation. 
  * Revenue raised from each household is equal to 10 cents times the new consumption level, which is equal to the current observed level of consumption (from data) minus the elasticity (0.4) times the implied change in price (current price plus 10 cents divided by the current price, all minus 1): $10 \times (c_{new} - \varepsilon \Delta p)$
  * Initial private welfare loss is calculated as the new consumption level, plus the triangle, which is the change in consumption times half times the tax: $c_{new} + \frac{(c_{new} - \varepsilon \Delta p)}{2}\times 10$ 
* The key suggestion of the theoretical model is that the degree to which the initial burden of the corrective tax can be predicted by variables that are used in the transfer function will determine whether a Pareto improvement is technologically feasible. Simple regression of the household level burden on variables that constitute the transfer function thus provides the required estimates

### When might a Pareto improvement be achievable?

* Benefit taxes: Intuitively, it should be easier to create a Pareto improvement where the welfare gains, $g_i$, are tightly correlated with burdens, $c_i$
  * *Does this mean that when welfare gains are inversely correlated with burdens, that it is harder to create a Pareto improvement? For example, taxing pollution from heavy polluting industries, who do not get much welfare gain because they have been dumping their pollution elsewhere?*
  * 