# Market Power 

### Lecture Notes

* If efficiency is the objective, then the railroads are kind of doing the role of a carbon tax
* Is market power "good" in this context? Efficiency vs distributional
  * If all you care about is efficiency then I guess it's good
  * But the distributional impacts are essentially that we're getting a transfer from consumers to producers 
  * What's happening on the extensive margin? Railroads are pretty good at price discrimination, and if they're doing it right, they're not going to drive a generator completely out of business
* What's the best policy?
  * If we take Louis' number seriously, there's still room for a modest carbon tax. 
  * What would be better, something in terms of intensity standard to get the electricity quantity right
* Demand estimation
  * Estimating demand curves for each of these individual coal plants, because the markup effects depend on the curvature as well as level
  * 



--------

* Define $M_j$ as a predictor of how railroads reoptimize markups due to variation in both transport market power and plant-specific coal demand

**Summary**

While Pigouvian taxes are efficient in the world of perfect competition, market power can significantly reduce the efficiency of trying to price carbon.  This paper looks at how market power in railroad transportation of coal impacts the pass through of shifts in coal demand, and uses this to evaluate the efficacy of US climate policy. Because of coal's geographic specificity and high transportation costs, power plants that demand coal face and geographic constraint are captive to an effective transportation monopoly. When there is a change in the demand for coal, such as from a carbon price, a shift in coal demand would cause a profit-maximizing railroad to reoptimize coal markups. Using a shift in demand induced by falling natural gas prices, the paper is able to show this shift is partially absorbed by railroads, muting the environmental benefits that should have accrued from a fall in coal use. 

The paper starts with a simple Cournot oligopoly model of railroad intermediaries who sell coal to power plants. The model gives an equation for the change in markups as a result of a change in price, which reveal that the heterogeneity of mark-up response is caused by (1) number of potential rail carriers, (2) availability of water transport as a substitute for rail transport, and (3) the level, slope, and curvature of a plant's inverse demand. This motivates an empirical strategy to estimate these three components to construct comparative statics for each plant. 

The empirical strategy begins with a difference-indifferences design to capture how markup levels vary between captive and non-captive plants. Captive plants are those that only have access to a single rail carrier. These captive plants are matched to geographically close non-captive plants to control for systematic differences between captive and non-captive plants. Using this approach, the outcome of interest in the DiD regression should compare the price of two identical coal shipments to otherwise identical coal plants, where only one plant is rail captive. 

Differential effects on markups are due not only to the markup levels plants face, but are also because of the shape of the plant's demand curve. To account for this, the paper estimates the plant-specific coal demand curves using a semi-parametric policy function approach that estimates a time-series regression for each coal generating unit. This yields coal demand curves for each plant-month, which allows for estimation of the three key parameters for calculating comparative statics for markup responses. 

Armed with these three key parameters, the paper derives an empirical approximation of the change in a plant's average markup that should result from a change in gas price, M_j. Now the paper is able to fully leverage the geographic variation in transport market power and the variation in coal plant's demand curves to estimate how markups respond to changes in the price of natural gas. The author finds that as gas prices fall, rail carriers reoptimized markups heterogeneously across plants. Amongst the 43% of plants in the sample that face the most market power and are sensitive to competition from gas-fired generation, offsetting changes in markups insulated these coal plants against demand shocks. 

The paper then translates gas price changes to an effective carbon tax to estimate the passthrough that a carbon tax would have to a coal power plant in the presence of market power. The paper finds heterogeneous passthrough rates, depending on M_j. In the group with the highest M_j (about 15% of the plants), the passthrough rate ranges from .42 to .9.  

The paper ends with two counterfactual exercises: (1) fracking boom never happened and (2) fracking boom happened but coal markups did not adjust. They find that a decrease in coal markups eroded about 8% of the fracking boom's short-run abatement potential, translating to an unrealized $2.3 billion in unrealized climate damages. 



**Discussion:**

I really enjoyed this paper, which adds a realistic theoretical layer to the topics and tools we have been discussing the last several weeks in class. It shines a light on 2 major gaps that often exist in discussing coal policy: (1) how do we account for market power and (2) how do we account for the role of transportation in linking mining and generation. The empirical strategy for this setting is clever, and I tend to believe the identifying assumptions that the author makes. The section that was fuzziest for me is the technique used in demand estimation. Is the intuition that this approach gets around the simultaneity problem because market conditions on the right hand side are exogenous? 

It is interesting to translate these markup responses to counterfactuals and put a number on the amount of carbon abatement that could have happened. However, I wonder how informative this is. If most of the lost abatement is driven by plants with the highest level of M_j, but the author admits that M_j "does not generate accurate quantitative predictions of how markups change" because of the lack of railroad regulation and threat of arbitrage in his set up. 

Two other discussions I would have loved to see in the paper:

1. How would policies other than Pigouvian taxes fare in the presence of market power? Obviously a thorough analysis would a lot to ask, but I would have appreciated just a general musing. 
2. As more and more coal plants shut down due to price pressures from natural gas, what is the future for railroads? What proportion of railroad profits come from coal exclusively, and how should the government think about a green transition that takes this into account?



What proportion of the total cost of electricity does transportation costs take up?