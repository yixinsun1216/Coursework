## Rosen/Roback Model - Glaeser Video

[Video Link](https://www.youtube.com/watch?v=zMmXo1nHetE&feature=youtu.be&t=4085)

3 ingredients

1. Spatial equilibrium for workers/consumers who are mobile across cities. City can't deliver extra utility somewhere, because then people will flock to that area
2. Zero profit condition for firms and/or spatial equilibrium for entrepreneurs. More reasonable assumption than easy alternatives
3. Zero profit condition for the builders who supply housing, or producers who build the non-traded good

Added ingredients can include endogenous local policies determined by voting, endogenous agglomeration economies, endogeneous amenities

### Spatial Equilibrium for Consumer - Old Style

* Individual  $I$'s utility in place $c$ is $U_{i c}=V\left(Y_{c}, P_{c}, \theta_{c}\right)$. There's only one type of person, choosing between cities

* $V(.,.,.)$ is an indirect utility function defined over local wages ($Y_c$), prices ($P_c$), and a vector of amenities ($\theta_c$)

  * $\theta$ stands for time spent commuting

* Utility must be equalized across space

* At any point in time the reservation utility or $\underline{U}$ must equal utility everywhere
  $$
  V\left(Y_{c}, P_{c}, \theta_{c}\right)=\underline{U}
  $$

* Is this literally true? Self reported happiness across the US

  * Deep South is happier than Rust Belt. We see differences in happiness across the US
  * So spatial equilibrium is just an approximation

**What happens as amenities goes up?**

* What happens to income and prices? If we write this in terms of net income, $V\left(Y_{c}, P_{c}, \theta_{c}\right)=V\left(Y_{c}-P_{c}, \theta_{c}\right)$ then this equality implies that if an area's amenities improve
  $$
  \frac{d\left(Y_{c}-P_{c}\right)}{d \theta_{c}}=-\frac{V_{\theta}\left(Y_{c}-P_{c}, \theta_{c}\right)}{V_{Y}\left(Y_{c}-P_{c}, \theta_{c}\right)}
  $$
  * Higher amenities are associated with lower real incomes
  * First order thing to keep in mind - if something is nice about a place, then something else has to be BAD about the place. If a place has nice amenities, then you have to have lower real income

* Holding amenities constant: $d Y_{c}=d P_{c}$, any increase in price is offset by an equivalent increase in come; any incrase in income is offset by an equivalent increase in price &rightarrow; compensation differentials

  * Relationship between housing prices and income in data, by and large support this
  * 



### Spatial Equilibrium for Consumers - New Style

* See Rebecca Diamond's AER Paper

* Individual $I$'s utility in place $c$ is - no longer one type of consumer!
  $$
  U_{i c}=V\left(Y_{c}, P_{c}, \theta_{c}\right)+\epsilon_{i c} / \rho
  $$

* $\epsilon_{i c}$ is a random place specific preference that follows a type 1 extreme value distribute with density $e^{-\epsilon-e^{-\epsilon}}$

* Individuals are identical except for their heterogeneous tastes for locations. Utilities are constant, subject to a location-specific idiosyncratic preference

* The share of the population living in city $\mathrm{c}^{\prime}$ is then
  $$
  \frac{\left.e^{\rho V\left(Y_{c}, P_{c}, \theta_{c} \prime\right.}\right)}{\sum_{c} e^{\rho V\left(Y_{c}, P_{c}, \theta_{c}\right)}}
  $$
  * The $\rho$ term that scales the variance of the normalization of the variance of tastes is innocuous because the utility function can be redefined to accommodate any desired variance

* What's hard is heterogeneity in different types: different education levels, different tastes etc

### Free Entry Condition for Firms

* Production in the traded good is constant returns to scale Cobb-Douglas
  $$
  \begin{array}{c}
  A_{c} L^{\alpha} K^{\beta} Z^{1-\alpha-\beta} \\
  A_{c}=\text {Local Productivy} \\
  \end{array}
  $$

* $A_c$ is endogenous in a simple agglomeration model, where it is typically a power function of total output, or total population. But we're not going to deal with that here

* $K$ is everywhere available at price of $r$

* $Z$ is non-traded capital, which has a fixed supply of $\bar{Z}_c$ in area $c$ - this is CRS technology. Still have profits which go to owner of the non-traded capital

* $L$ is hired at a local and endogenous price of $Y_c$ - determined by labor market 

* There is free entry for firms, price of traded good is normalized to 1

* Produces a local labor demand curve of 
  $$
  \ln \left(Y_{c}\right)=\Psi+\frac{1}{1-\beta} \ln \left(A_{c}\right)+\frac{1-\alpha-\beta}{1-\beta} \ln \left(\bar{Z}_{c}\right)-\frac{1-\alpha-\beta}{1-\beta}\left(L_{c}\right)
  $$

  * $\Psi$ is just a lot of constant terms that I don't want to carry around
  * The only truly fixed factor is the non-traded capital which makes local production function concave. These things are not city specific so they'll eventually vanish
  * This is one of 3 curves that will shape our equilibrium

* If we wanted to allow for agglomeration economies or other externalities, we would assume that 
  $$
  A_{c}=A_{0, c}\left(A_{c} L_{c}^{\infty} K_{c}^{\beta} \bar{Z}_{c}^{1-\alpha-\beta}\right)^{\gamma}
  $$

  * Individual firms are too small to internalize the impact of their output on agglomeration
  * This changes the parameters, but not the basic structure of the labor demand equation
  * This changes the parameters, but not the basic structure of the labor demand equation



### Zero Profit Condition for Non-traded Good (Housing)

* The non-traded good is produced with capital and non-traded capital M (land)
  * Not using labor to create housing
* This non-traded capital has a fixed supply of $\bar{M}_c$ which is determined both by local geography and by land use controls
* Typically we make one of two assumptions about this good
  1. It is power function for housing and consumption which is a Cobb Douglas utility
  2. Each good consumes exactly one unit of housing
* At this point, we need not specify
* If you wanted to use local labor to produce the good, you had better assume the Cobb Douglas structure
* Cobb-Douglas is a beautiful functional form, but it ties your hands because it ensures the income elasticities are one and the price elasticities of minus 1
* Sticking with the housing analogy, the supply of usable space is Height $\times$ Land, or HM
  * Capital cost of producing $H$ is $h_0H^{\delta_c}$ where we assume $\delta_c > 1$ 
  * In reality construction cost tells us that going from one story to five is quite convex, five stories to fifty is CRS, and more than 50 becomes convex again
  * Power function is easiest to work with 
* Housing supply differences are differences in $M_c$ or $\delta_c$) are important for explaining why cities look the way they do
  * If you think cities have relatively elastic supply (low $\delta_c$) - if you have rising demand, why some places would see more population and why some places you'd see higher prices. 

![image-20201108114618757](C:\Users\Yixin Sun\AppData\Roaming\Typora\typora-user-images\image-20201108114618757.png)

* X-axis is new permiting / initial housing stock

  * Y-axis is gap between housing prices and physical cost of building. Places that build a lot aren't expensive, and places that are expensive don't build a lot. Compatible in view of heterogeneity in supply of housing. 
  * In Phoenix or Houston, demand shows up in change in quantity because of elasticity of supply. In San Francisco or LA it shows up in higher prices because quantity is more or less fixed. 

* This type of model can get at that, you just need different $\delta_c$

* Producers profits $=M\left(P_{c} H-h_{0} H^{\delta} c\right)-$ cost of $M$O

* Optimizing yields:
  $$
  H^{*}=\left(\frac{P_{c}}{\delta_{c} h_{0}}\right)^{\frac{1}{\delta_{c}-1}}
  $$

* Total supply of non-traded capital satisfies:
  $$
  H^{*} \bar{M}_{c}=\left(\frac{P_{c}}{\delta_{c} h_{0}}\right)^{\frac{1}{\delta_{c}-1}} \bar{M}_{c}
  $$

* To work with a system of city-specific equations, set $\delta_c = \delta$

### Individual Optimization within the City

* Return to microfounding the indirect utility function

* In all options, assume that amenities are just a multiplier: $\theta_c U(.)$. 2 options for this $U(.)$

  1. One household: turns off intensive demand for housing

     1. Utility is just $\theta_c U(\text{Trade consumption}) = \theta_cU(Y_c - P_c)$
     2. Not what we want given our other assumptions. Income is a power-function of labor supply; prices are a power function of labor supply. Subtracting two power functions isn't particularly pretty
     3. Generally, you want to arrange things so that you multiply power functions and add linear functions

  2. Cobb-Douglas Preferences: $\text { Utility }=\theta_{c} X_{\text {Traded}}^{1-\sigma} X_{\text {Non-Traded}}^{\sigma}$

     1. The price of the traded good is normalized to 1 .

     2. This implies an indirect utility function:
        $$
        V\left(Y_{c}, P_{c}, \theta_{c}\right)=\sigma^{\sigma}(1-\sigma)^{1-\sigma} \theta_{c} Y_{c} P_{c}^{-\sigma}
        $$

        1. Weight of housing price here depends on the share of your income that goes towards housing

     3. Spending on non-traded goods equals $\sigma Y_c$

* Equilibrium in the non-traded sector satisfies:
  $$
  P_{c}\left(\frac{P_{c}}{\delta_{c} h_{0}}\right)^{\frac{1}{\delta_{c}-1}} \bar{M}_{c}=L_{c} \sigma Y_{c}
  $$

* Remember $L_{c}$ is the endogenous number of workers, so we have two equations and three unknowns (housing price as a function of income and labor supply) and income as a function of labor supply.

  * $\ln \left(P_{c}\right)=\Omega+\frac{\delta-1}{\delta}\left(\ln \left(Y_{c}\right)+\ln \left(L_{c}\right)-\ln \left(\bar{M}_{c}\right)\right)$

* Adopting the notation 
  $$
  \ln \left(\tilde{A}_{c}\right)=\ln \left(A_{c}\right)+(1-\alpha-\beta) \ln \left(\bar{Z}_{c}\right)
  $$
* Then
  $$
  \ln \left(Y_{c}\right)=\Psi+\frac{1}{1-\beta} \ln \left(\tilde{A}_{c}\right)-\frac{1-\alpha-\beta}{1-\beta}\left(L_{c}\right)
  $$
  * Productivity minus number of people

* The third equation is the supply equilibrium equation that closes the system



SKIPPING MATH



### Results - Old Style

* Gives intuitive comparative statics
* Population is rising in productivity, amenities, and land supply
* Income is rising in productivity and falling in both amenities and land supply
* Prices are rising in productivity and amenities and declining in land
* Changes in population, income, and prices can be used to invert and solve for changes in amenities, productivity, and land supply
* Even though Sun belt is associated with rising population, it still doesn't have rising amenities - what's going on is Sun Belt areas (housing, dallas, phoenix) are areas that have radically boosted housing supply.
* If you see a place in which populations are going up, wages are not going up by a lot, and prices are going down a lot, that's got to be a shift in housing supply
  * Population is not going up, but prices and income are going up, something about productivity
  * Incomes are going down, population is going up and prices are going up, that's rising amenities 
  * Real wages are higher in the city, then amenities must be lower



### Results - New Style

* Migration terms moderate part of productivity in income and all of amenities in income. That is because productivity increases population which lowers wages and offsets the direct impact
* Big things are unchanged 
  * Productivity boosts prices, population and income
  * Amenities boosts prices and population but lowers income
  * Housing boosts population but lowers prices and incomes

### Summary

* People choose metropolitan areas and each one delivers a bundle of wages, amenities, and prices
* A simple linear model would be that for identical people, wages + amenities - pries is constant across the US
* This means that amenities can be measured as prices - wages
* If amenities attract people, then this measure should predict future urban growth
* If happiness tells us something about amenities, then happiness measure should work as well





-----

## Henderson (1974) 

* Addresses basic, fundamental questions about a system of cities in general equilibrium
  * Why do cities exist? "beceause there are technological economies of scale in production or consumption"
  * Are cities too large or too small? "Stability argument says that cities tend to be too large"
  * Why do cities of different sizes exist? "cities of different types specialize in production of different traded goods"

### Environment

* Factors: land $L,$ labor $N,$ capital $K$
* Tradables production (external economies a la Chipman) 
  - Implicitly, there's an industry in city number 2

$$
X_{1}^{1-\rho_{1}}=L_{1}^{\alpha_{1}} K_{1}^{\beta_{1}} N_{1}^{\gamma_{1}} \quad \alpha_{1}+\beta_{1}+\gamma_{1}=1, \rho_{1} \in(0,1)
$$
- Housing production
  - Non-tradables called industry number 3
$$
X_{3}=L_{3}^{\alpha_{3}} K_{3}^{\beta_{3}} N_{3}^{\gamma_{3}} \quad \alpha_{3}+\beta_{3}+\gamma_{3}=1
$$
* Land sites produced by labor
  * Diminishing returns - congestion cost 
  * $z$ is a function of amount of labor in the city - worse as cities get more crowded 

$$
L=N_{0}^{1 /(1-z)} \quad z<0, z^{\prime}(N)<0
$$
- Clear factor markets with prices $p_{N}, p_{K}, p_{L}$
$$
N_{0}+N_{1}+N_{3}=N, \quad K_{1}+K_{3}=K, \quad L_{1}+L_{3}=L
$$
- Cobb-Douglas preferences $\left(U=x_{1}^{a} x_{2}^{b} x_{3}^{c}\right)$ with income $y,$ import of good 2 , and prices $q$ deliver indirect utility
  - $q$ are prices of goods
  - This is the indirect utility function

$$
U \propto y q_{1}^{-a} q_{2}^{-b} q_{3}^{-c}
$$

### Capitalists and Workers

* Different (stark) assumptions about capital ownership:
  * each laborer owns equal capital stock (Assumption A)
  * capital owners live outside of cities (Assumption B) - won't bid up the housing price
* Utility components for labor income and capital income
$$
\begin{array}{l}
U_{N} \propto p_{N} q_{1}^{-a} q_{2}^{-b} q_{3}^{-c} \\
U_{K} \propto \bar{p}_{K} \frac{\bar{K}}{N} q_{1}^{-a} q_{2}^{-b} q_{3}^{-c}
\end{array}
$$
<u>Solving for optimal and equilibrium city sizes</u> 

* Optimum: maximize $U_{N}+U_{K},$ given the determination of $U_{N}$, $U_{K},$ and $p_{K}$ through simultaneous location and investment of labor and capital in cities in the economy 
* Equilibrium: atomistic choices of capital owners, firms, and laborers

### Results

![image-20201108130142375](C:\Users\Yixin Sun\AppData\Roaming\Typora\typora-user-images\image-20201108130142375.png)

- Vertical axis is utility levels and price levels. Horizontal axis is N
- $\alpha_{1}>\rho_{1}$ (site intensity vs IRS) is sufficient for both $p_{K}$ and $U_{N}$ to exhibit interior maxima
- $p_{K}$ curve has peak to right of $U_{N}$ and $U_{K}$ peak because  $U_{K}$ is  $p_{K}$ deflated by $q_{3}^{-c}$
  - Capital is translated to utility but deflated by price of housing
- Assumption B curves peak to right of Assumption A curves because capitalist income doesn't bid up housing prices
  - Now housing prices don't rise with increase in population so quickly because capitalist take income and don't spend it in local housing markets
- Why isn't "two identical cities at point C " stable? 
  - You're on a rising portion of the curve at C. If you nudge to city 1. That slight difference in population size means utility is higher in city 1, so more people will leave city 2 to go to city 1. So the fact that we're on the portion of the curve where we have rising utility with rising population means that the difference between city 1 and 2 grow with the nudge

### Optimal city size

* For Assumption A, maximize the vertical sum of $U_{N}$ and $U_{K}$
* Planner has total population $N$ and faces integer constraint 
* Start second city when $N$ is twice $N\left(U_{N}^{*}, U_{K}^{*}\right)$ (Starting second city earlier is not a stable optimum, as seen in the last slide)
* Figure 3 is more complicated due to Assumption $\mathrm{B}$ and the worker vs capitalist disagreement on optimal city size

### Equilibrium City Size

* Suppose city gets so big you're at $N(E)$. Then you could take a small number of people and deviate. 
  * Once a second city starts, you're on the rising portion, until we jump to half of $N(E)$ - we need utility equalization across cities
* Sizes are going to be too big - in order to be stable, you have to be to the right of $N(U_N)$. Someone joining the city is not internalizing their effect of driving up the driving congestion cost. If you are to the left of $N(U_N)$ then people will keep joining
* BDRN (2014): "there is a coordination failure in city formation so that any population size between optimal city size and grossly oversized cities - leaving their residents with zero consumption - can occur in equilibrium"

### Heterogeneous Cities

* "Our second type of city specializes in the production of another type of traded good, say, $X_{2} . "$
* "Different types of cities differ in size because production parameters, in particular $\alpha_{i}$ and $\rho_{i},$ differ between the traded goods of each type of city."
* "Although utility levels will be equalized between cities, wage rates and housing prices will vary with city type and size."