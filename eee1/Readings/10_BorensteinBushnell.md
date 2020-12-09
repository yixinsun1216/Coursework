# Do Two Electricity Pricing Wrongs Make a Right? 

### Lecture Notes

* Lecture notes: solving the Ramsey model
  $$
  \frac{p_{i}-c^{\prime}}{p_{i}}=\frac{\lambda}{1+\lambda} \cdot \frac{1}{-\varepsilon_{i}}+\frac{1}{1+\lambda} \cdot \frac{\tau}{p_{i}}
  $$

  * Even without Pigouvian tax term, the utility has to recover its fixed costs so its price is already higher than its marginal cost
  * Depending on what's going on in the first term, maybe we don't need a Pigouvian tax?

* Data sources are quite involved

* Sweeps under the rug issues of quantity discounts/premiums and time-varying pricing (data is 2014-2016) - is this a bad assumption today?

* Social MC = Private MC + Externality

  * Private MC = wholesale price + distribution costs
    * If you assume wholesale market is competitive (is this true?), prices are costs
    * Distribution losses are estimated from engineering model - how much power is lost through power lines
    * Electricity is most expensive on coasts, particularly Northeast/Mid-atlantic
    * Considerable variation over time, due to variation in gas prices, winter surge in demand
  * Externalities: a bit sketchy
    * hourly damages due to main electricity pollutants, regress on load on grid, take first difference. Adjust downward for existing carbon tax programs

* Prices are too high in California/Northeast. Too low in Midwest/Rust Belt

* Implications - additional carbon taxes in blue states will create further inefficiencies 

  * Energy efficiency incentives should be targeted at red states

* Time variation in SMC - Decomposing the DWL

  * Total DWL is
    $$
    \begin{aligned}
    D W L &=\sum_{h} D W L_{h}=\sum_{h} \frac{1}{2 s}\left(\bar{P}-S M C_{h}\right)^{2} \\
    &=\frac{1}{2 s}\left(H(\bar{P}-\overline{S M C})^{2}+\sum_{h}\left(\overline{S M C}-S M C_{h}\right)^{2}\right)
    \end{aligned}
    $$

  * First term is loss from average price being different from average cost

  * Second term is loss from price being fixed over time

  * For most utilities, the second term dominates. But the largest magnitudes are from the first term.

  

### Discussion

* Is it reasonable to equate SR and LR elasticities?
* Possible explanation for the results: strong preferences regarding local pollutants? Seems feasible to calculate how strong such preferences would need to be able to justify the results, and whether such numbers are reasonable
* What's going on with North Dakota? 
  * Severe border effect - part of that is that there is a clear division in the electricity grid along that border. No flow east-west
  * A lot more renewables to the east (Wyoming, Montana). To the east - hydro does not get over there, so the grids become substantially dirtier 
  * Could simply be that North Dakota has a high fixed charge and a low variable charge 
* Key difference between Ramsey pricing vs what's going on here is that in reality,  utilities have a fixed charge + variable
  * Fixed charge is one way of trying to bring down variable charge. Severin's been trying to elevate the fixed charge 
* Who decides the pricing across different states? 
  * These are all publicly decided - almost any country, you treat as natural monopoly. Distribution services priced used cost-of-service principles. 
  * Retail prices typically set by PUC that the utility reports to. They report costs to PUC, they have rate hearings, and then that leads to a set of electricity rates that help the utility break even. 
  * ComEd actually owns some power plants and coal plants - so they pass costs to rate payers. And Madigan passed bailout so ComEd could get money
* Wholesale market competitive?
  * Distribution is textbook natural monopoly
  * On wholesale production side, in a world where you have hundreds of generation units, it's not crazy to think of that market as being potentially competitive 
  * Market design has gotten a lot better since the 2000s, but it's not the first-order concern
* Stephen Holland, Andy Yates, Nick Mueller at CMU
* Proponents of electrify everything - grid is fueled by wind and solar
* They do not include the marginal cost 
* 







----------

There are several opposing distortionary forces working in retail electricity markets:

1. Electricity generation imposes pollution costs that are not internalized in the retail price, so prices are too low
2. Recovery of fixed costs and the designation as a natural monopoly pushes prices up
3. Marginal cost fluctuate largely throughout the day and electricity is not storable, which is not captured by fixed monthly retail prices 

Researchers often study these separately, but this paper takes a holistic view of these opposing effects. The authors compare how residential electricity prices are different from the ideal short-run social marginal cost (SRSMC). They decomposed this into (1) the component caused by charging a price that differs from  the average SRSMC and (2) the component caused by charging a constant price that does not vary over short time periods. The authors further break down these price constructions into:

1. Retail price: constructed using several utility sales datasets. The authors remove the fixed charges (to the best of their ability) to compute the marginal price per kWh
2. Private marginal cost: consisting of wholesale price, costs from distribution losses, and other considerations such as capacity costs, ancillary services costs, and other maintenance costs. 
3. External marginal cost: computed through estimating damage functions for the four major pollutants from electricity generation. 

Figure 9 then (quite nicely!) presents the marginal price minus the average social marginal cost. We can see that in the Midwest and Appalachian areas, residential prices are much lower than the SMC, so the retail prices are not pricing in pollution adequately. However, in California and the Northeast, prices are well above the SMC. 

The authors then incorporate the mispricing from the fact that static prices do not capture how the SMC varies temporally. Through a DWL analysis, they find that this failure to take into account temporal fluctuations is the main component of the DWL for most utilities. As shown in Figure 13, this issue is most prevalent in Texas and the mid-Atlantic states. 



**Discussion**

The complexity of the electricity market has always been daunting to me, and this complexity is reflected in the myriad of data constraints, pricing schedules and utility idiosyncrasies the paper has to tackle head on. Given the nature of the beast, the authors do a great job laying out the problem and their methodology, and I especially liked the clarity of their maps. Their details about their data work show both the Herculean task they undertook, and the clarity of their exposition. 

Their discussion of how this mispricing affects energy efficiency was very interesting, that areas that are pricing electricity way above SMC also spend a lot on programs to incentivize reductions in electricity use. Instead, energy efficiency should be aimed at areas where price is below social marginal cost, where prices are not reflecting the harms imposed on the area. I'm not sure how the current national weatherization assistance program screens applicants, but the insights from this paper seem very useful for creating targeted federal programs. 

Questions:

1. They estimate the social marginal cost based on the emissions from plants, which would miss emissions damages from fossil fuel extraction. Is that outside the scope of this paper, or is it relevant that the fossil fuel inputs are probably priced too low relative to their SMC?
2. Do we think of long run marginal cost as essentially the same as short run marginal costs, since the variable costs are so small compared to the fixed cost, and utilities are continuously investing in new infrastructure?
3. If California's electricity prices are high because they want to use that to subsidize renewable technology, is that benefit captured within this framework?





