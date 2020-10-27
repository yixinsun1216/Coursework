## Introduction

* Motivation: price of crude oil in US was never before $40/barrel until mid-40s, after which there were sharp price changes. Were these sharp price changes due to fundamental shifts in supply and demand, or are "speculators" at least partly to blame? Aim of paper is to determine whether speculation was a significant driver of prices
* Definition: oil price speculation is the purchase (or sale) of an oil-related asset with the expectation that the price of the asset will rise (or fall) to create the opportunity for a capital gain
  * Note it is impossible to distinguish speculative activity from an investment. The paper is not concerned about whether the purchase is an investment or pure speculation
* Speculation is NOT a shift in fundamentals, aka shift in consumption demand or supply, seasonal fluctuations, or expected impact of forecasted hurricane
* Vehicles for speculation
  1. Hold oil futures 
     * Explanation: Oil producers can sell futures contracts that match up to their expected future production, and by  doing so, they can effectively lock in current prices. If a contract falls from \$50 per barrel to ​\$49, then the  seller will get a ​\$1,000 credit, corresponding to the ​\$1 decline  multiplied by the 1,000 barrels covered by the contract. Conversely, if  the contract rises from ​\$50 to ​\$51, the seller takes a $1,000 loss,  offsetting the eventual gain the seller will get in future by having a  higher price.
     * Buyers who need crude oil as a raw material, on the other hand, such  as refinery companies, can ensure they have adequate future supplies and lock in favorable pricing. For buyers, the finances of futures work in  the opposite direction. Rising prices give them a financial credit,  while falling prices cost them. The net effect, though, is to set the  price actually paid for the oil at the level at which the buyer entered  into the futures contract in the first place.
     * Investors generally aren't interested in  taking possession of thousands of barrels of crude oil. Many traders  participate in futures markets without ever dealing with actual physical delivery. As long as you close out your futures position before the  expiration date of the contract, then you can experience the same  financial gains and losses as other participants from the daily  movements of futures prices.
  2. Holding oil inventories: if there is sufficient storage capacity, oil companies can accumulative excess inventories during periods of suspected speculation

## Analytical Framework

1. Evolution of spot price

$$
P_{t}=f\left(\Delta N_{i} ; z_{1 t}, z_{2 t}, \epsilon_{t}\right) \tag{2}
$$

2. Inverse demand for storage, which dictates $N_t$, the supply of storage
   $$
   \psi=P g\left(N ; z_{3}, \epsilon_{3}\right) \tag{3}
   $$
   
3. Evolution of capitalized flow of marginal convenience yield that satisfies no arbitrage condition
   $$
   \psi_{t, T}=\left(1+r_{T}\right) P_{t}-F_{t, T}+k_{T} \tag{4} \\
   \Rightarrow \left[1+r_{T}-g\left(N_{t}\right)\right] P_{t}=F_{t, T}-k_{T} 
   $$
   
4. Evolution for futures price
   $$
   F_{t, T}=E_{t} P_{t+T}+\left(r_{T}-\rho_{T}\right) P_{t} \tag{6}
   $$
   $E_tP_{t+T} = E_t\bar{P}_{t+T} + s_t$ shows that expected future prices depend on rational expectations + deviations due to speculation

* How can the futures price affect the spot price? 
  * Futures contract is an agreement to deliver a specified quantity of a commodity at a specified future date, at a price to be paid at the time of the delivery
  * Increases in futures prices can lead to an increase in the spot price  of a commodity (by the no arbitrage condition) but any impact will be limited by activity in the market for storage 
* What happens if speculators bet on higher prices by buying futures
  1. Increase in $E_tP_t$ means increase in $F_{t,T}$ but no shift in net demand $f(\Delta N)$ 
  2. Equation (4) shows that to maintain a no arbitrage condition, either $N$ increases or $P_t$ increases. With no change in fundamentals. If the spot price rises, supply exceeds demands to inventories must rise, therefore both occur. 
  3. $g(N) = \psi/P$ will fall with the inventories rise, limiting the increase in spot price 
  4. At some point, the expected future spot price will fall, as will the futures price. Now everything runs in reverse until the spot price returns to its original level
* What happens oil companies accumulate inventories to speculate on rising prices?



## Canvas Summary

**Summary:**

Up until the mid-2004s, the price of crude oil remained steadily under $40/barrel. After 2004, the world saw sharp price changes. This paper sought to address a popular explanation for these sharp changes, and investigates whether these changes were due to "speculation" in the futures market. Oil price speculation here is defined as the purchase or sale of an oil asset with the expectation that the price of the asset will change in a way to create profit for the speculator, making it distinct from fundamental shifts in supply and demand that naturally drive changes in the price of oil. 

The paper builds a model of the oil market that distinguishes between a cash market and a storage market. Speculation here occurs through two channels:

1. Holding oil futures: if you think prices are going to go up, speculators can hold a long futures position. 
2. Holding oil inventories: if there is sufficient storage capacity, oil companies can accumulative excess inventories during periods of suspected speculation

The model shows that speculation through holding oil futures causes prices to increase in the short run, but any impact will be limited by activity in the market for storage, and the spot price will eventually revert back to the original price. Speculation through holding oil inventories has a similar effect on the spot price in both the short and long run. 

They are able to match reduced-form equations to their model to estimate the cumulative effect of speculation. Comparing this to changes in the oil prices, we see that changes in log price from speculation cannot explain the significant part of the sharp changes in log prices. Unless oil price elasticities of both supply and demand are close to zero, the shifts in speculation components cannot be the big driver. In fact, there is even some evidence that speculation decreased price shifts on average. 



**Discussion**:

I found the figures to be very helpful in explaining the logic of the model, but I found the paper generally hard to digest. Part of this is that I lack intuition on why journalists and politicians latched onto the idea that speculation caused these sharp changes in the oil prices in the first place. Perhaps it is simply that investors are an easy scapegoat and/or that I have become fully entrenched in the idea that futures reduces volatility rather than add to it. 

The authors are quite open with the limits (and benefits!) of the simplicity of the model. I am particularly interested in the assumption that the elasticities of demand and supply in the cash market being constant over their the time frame of their sample. What has been the literature on this? My gut reaction is that elasticities probably changed quite a bit between 1998 and 2012 with the increased interest in renewables, on both the supply and demand side.  



## Lecture Notes

* $\rho_T > r_T$ because commodities are usually procyclical 
* Negative convenience yield? No reason it has to be positive in their set up

* Negative oil prices?
* Constant elasticity of demand?
* How to think about exogeneity in this paper?
  * There's no regression involved anywhere that lead to their main graphs. Very different from typical applied micro/energy paper. 
* What was actually happening?
  * 2000-2008 - China's growth was totally bonkers
* The only way speculation can bid up the price of oil is if we saw a massive increase in storage. Storage is not going up like crazy here. 



Canals in OSM under waterways as a line



