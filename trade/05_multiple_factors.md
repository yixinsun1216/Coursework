## Week 5 Multiple Factors of Production

### Factor Proportions Theory 

* Law of comparative advantage establishes relationship between relative autarky prices and trade flows
* Factor proportions theory is a particular case - tells us where autarky prices come from
  * Countries differ in terms of factor abundance (RELATIVE factor supply rather than levels)
  * Goods differ in terms of factor intensity (relative factor demand)
* Interplay between these differences governs relative autarky prices and hence trade
* To focus on factor endowments, shut down other channels: 
  * identical production functions (No ricardian forces)
  * identical homothetic preferences
* Two canonical models: (1) Ricardo-Viner model with 2 goods and 3 factors (2 are specific to a good) and (2) Heckscher-Ohlin model with 2 goods and 2 factors

### Ricardo-Viner Models - Pre-class Video

* Seems like a simple model but (1) simple is good and (2) 
* Kovak paper contribution - here is guidance on what you should be putting on your rhs variable and how to interpret coefficients that you're getting out of these regressions

---

### Heckscher-Ohlin Model

* Jones + (Meera?) textbook is quite good for this

* Production functions (HD1) using factors $L$ and $K$ are 
  $$
  y_{g}=f_{g}\left(L_{g}, K_{g}\right) \quad g=1,2
  $$
  Unit cost functions are given by (by definition is solution to min function for one unit of a good) 
  $$
  c_{g}(w, r)=\min _{L_{g}, K_{g}}\left\{w L_{g}+r K_{g} \mid f_{g}\left(L_{g}, K_{g}\right) \geq 1\right\}
  $$
  We write the solution in terms of unit factor demands $a_{g f}$ (aka the solutions to the cost minimization problem)
  $$
  c_{g}(w, r)=w a_{g L}(w, r)+r a_{g K}(w, r)
  $$
  From the envelope theorem, we know
  $$
  \frac{\mathrm{d} c_{g}}{\mathrm{d} w}=a_{g L} \quad \frac{\mathrm{d} c_{g}}{\mathrm{d} r}=a_{g K}
  $$
  $A(w, r) \equiv\left[a_{g f}(w, r)\right]$ denotes the matrix of total factor requirements

* $2 \times 2$ HO:  Equilibrium in Small Open Economy
  - Start with "small open economy" for which $p_{g}$ are exogenous
  Profit maximization:
  $p_{1} \leq c_{1}(w, r) \quad$ equal if produced $p_{2} \leq c_{2}(w, r) \quad$ equal if produced
  - Labor and capital markets clear:
  $$
  \begin{aligned}
  a_{1 L} y_{1}+a_{2 L} y_{2} &=L \\
  a_{1 K} y_{1}+a_{2 K} y_{2} &=K
  \end{aligned}
  $$
  - These are four nonlinear equations in four unknowns; unique
    solution not generally guaranteed (cost functions aren't linear)
    - L and K are exogenous parameters ==(does this mean w and r are given too? confused what we're solving for here).== Prices are fixed. 
    - To solve for: how you produce this stuff (cost functions), unit factors $a$, and quantity to produce

* Four theorems - old Neoclassical literature and canonical set of results in old school trade
  1. Factor price equalization: Can trade in goods substitute for trade
      in factors?
    1. You're endowed with factors. If you have less labor compared to capital, can you trades and wind up with the same factor prices?
  2. Stolper-Samuelson: Who wins and who loses from a change in
      goods prices? 
  3. Rybczynski: How does output mix respond to change in
      endowments?
  4. Heckscher-Ohlin: What is the pattern of specialization and trade?

* Let's first take care of uniqueness: Factor price insensitivities

  * Good 1 is called labor-intensive if $\frac{a_{1 L}(w, r)}{a_{1 K}(w, r)}>\frac{a_{2 L}(w, r)}{a_{2 K}(w, r)}$ and capital-intensive if $\frac{a_{1 L}(w, r)}{a_{1 K}(w, r)}<\frac{a_{2 L}(w, r)}{a_{2 K}(w, r)}$
    * At a set of factor prices, the L/K ratio is bigger than 1 &rightarrow; labor intensive. 
  * A factor intensity reversal occurs if $\exists w, r, w^{\prime}, r^{\prime}$ such that good 1
    is labor-intensive for $(w, r)$ and capital-intensive for $\left(w^{\prime}, r^{\prime}\right)$
  * **Lemma**: If both goods are produced, and factor intensity reversals do not occur, then factor prices $\omega \equiv(w, r)$ are uniquely determined by goods prices $p \equiv\left(p_{1}, p_{2}\right)$ 
    Proof: If both goods are produced in equilibrium, then $p=A(\omega) \omega$. By Gale and Nikaido $(1965),$ this equation admits a unique solution if $a_{f g}(\omega)>0$ for all $f, g$ and $\operatorname{det}[A(\omega)] \neq 0 \forall \omega,$ which no factor intensity reversals guarantees.
    * Means you know something about how this economy is going to behave
    * Proof is BORING
    * Everything today assumes free trade and prices are equalized across countries
  * Not a lot of critical evaluation of whether factor intensive reversals. You would need to observe a large mix of factors for different factor prices with same technology for different goods &rightarrow; hard to evaluate
    * If a factor became abundant, can I imagine inventing different techniques to produce the same good?

* Factor Intensity Reversals

  ![image-20201019150744247](C:\Users\Yixin Sun\AppData\Roaming\Typora\typora-user-images\image-20201019150744247.png)

  * Figure 1.5: Curve for good 1 is always steeper than for good 2! &rightarrow; single crossing
    * Then given goods prices, we can pin down $r$ and $w$
  * Figure 1.6: multiple crossing points
    * Good 1 is labor intensive at A. Good 2 is labor intensive at B. 
    * Can't just look at single industry - definition is comparing two pairs. Then empirically you'd have to look at more than 2 goods so it's all very difficult!

* Back to 4 Theorems

  1. Factor Price Equalization Theorem: If two countries both produce both goods under free trade with the same technology and there are no factor intensity reversals, then factor prices in the two countries are the same.
     - This follow directly from the previous lemma and the no-FIR diagram:
     By free trade, goods prices are the same
     - By identical technologies, isocost lines are the same
     - Hence, trade in goods is a perfect substitute for factor mobility in
     this model in the sense that it also equalizes factor prices
     - 

  2. Stolper-Samuelson Theorem: Theorem
      An increase in the relative price of one good raises the real return of
      the factor used intensively in producing that good and lowers the real
      return of the other factor.
      Proof (hats here mean log):
      $\mathrm{WLOG}, \operatorname{let} \frac{a_{1 L}(\omega)}{a_{1 K}(\omega)}>\frac{a_{2 L}(\omega)}{a_{2 K}(\omega)}$ and $\hat{p}_{1}>\hat{p}_{2},$ where $\hat{x} \equiv \frac{\mathrm{d} x}{x}$ 
      Differentiating the zero-profit conditions yields (by envelope theorem)
  $$
    \mathrm{d} p_{g}=a_{g L} \mathrm{d} w+a_{g K} \mathrm{d} r
  $$
    Define the cost share $\theta_{g L}=\frac{w a_{g L}}{c_{g}}$ to obtain
  $$
    \hat{p}_{g}=\theta_{g L} \hat{w}+\left(1-\theta_{g L}\right) \hat{r}
  $$
    Goods price changes are weighted averages of factor, price changes.
  $$
    \frac{a_{1 L}}{a_{1 K}}>\frac{a_{2 L}}{a_{2 K}} \Rightarrow \theta_{1 L}>\theta_{2 L}
  $$
    so $\hat{r}<\hat{p}_{2}<\hat{p}_{1}<\hat{w}$

      1. comparing factor prices to goods prices. Thinking about the returns to those factors (and winners and losers)
    2. The important thing here is differentiating the zero-profit condition. The reason I can assign these cost shares is because you hire a factor and that produces one good. This doesn't work if you hire a factor and it produces more than one good. 
      3. Stolper-Samuelson is a shift out of the iso-cost curve. 
  4.  Rybczynski Theorem: For given goods prices, an increase in the endowment of one factor causes a more-than-proportionate increase in the output of the good using this factor intensively and a decrease in the output of the other good. 
  

  
    Differentiating the factor market clearing conditions yields,
      $$
      \mathrm{d} L=a_{1 L} \mathrm{d} y_{1}+a_{2 L} \mathrm{d} y_{2} \text { and } \mathrm{d} K=a_{1 K} \mathrm{d} y_{1}+a_{2 K} \mathrm{d} y_{2}
      $$
      Defining $\lambda_{i L}=\frac{a_{i L} y_{i}}{L}$ and $\lambda_{i K}=\frac{a_{i K} y_{i}}{K}$ this implies,
      $$
      \hat{L}=\lambda_{1 L} \hat{y}_{1}+\left(1-\lambda_{1 L}\right) \hat{y}_{2} \text { and } \hat{K}=\lambda_{1 K} \hat{y}_{1}+\left(1-\lambda_{1 K}\right) \hat{y}_{2}
      $$
      If (w.l.o.g.) $\frac{a_{1 L}}{a_{1 K}}>\frac{a_{2 L}}{a_{2 K}},$ then $\lambda_{1 L}>\lambda_{1 K}$ so that,
      $$
      \hat{y}_{1}>\hat{L}>\hat{K}>\hat{y}_{2} \text { or } \hat{y}_{1}<\hat{L}<\hat{K}<\hat{y}_{2}
      $$
      
      Hence, if also (wlog) $\hat{K}>\hat{L},$ we obtain,
      $$
      \hat{y}_{1}<\hat{L}<\hat{K}<\hat{y}_{2}
      $$
      1. Cone of diversification: cone is the factor requirements vector. There's basically two ways to get to (L,K) in figure 1.8

### HO Theorem: 

* consider world economy with two countries and free trade (prior results derived for small open economies)  
  * This is a 2 by 2 by model
  * Identical tech and homothetic preferences
  * What is the pattern of trade?
* Imagine angel comes down and fragments world into two countries and splits endowments. Can trade reproduce the integrated equilibrium? Yes if factor price equalization holds!
  * So yes for point E, but not E' since E' lies outside the cone (FPE set)
  * Equal goods prices 
* **Theorem** in the free-trade equilibrium, each country exports the good that uses its abundant factor intensity &rightarrow; statement about net export vectors
  * If endowments are in the FPE set, this is a simple corollary of Rybczynski theorem
    * output mix responds to my endowment (factor supply mix) and you have homothetical and identical preferences. Then you need to export the thing you're making more of and swap with the other country. No assumption on FIRs required
  * Outside FPE set, need to also consider FIRs
* Higher dimensions 
  * High dimensional predictions are either weak or unintuitive
  * Results often depends on relative sizes of number of factors vs number of goods

### Ricardo-Roy Model

* Costinot-Vogel motivation: people hate this absurd high dimensional result that depends on F and G
  * If you make strong assumptions then you can solve higher dimensions but what do we think about those assumptions and subsequent predictions?
  * Ricardo-Roy set up here make strong assumptions and strong predictions
* Ricardo with linear production functions and Roy with multiple factors of production

---



## Empirics! 

### Trade and Regional Outcomes (empirics with RV lens)

* Topalova (2010) and Kovak (2013) -> affecting nationwide goods prices and what happens to economic outcomes
* Topalova in pre-class video 
  * higher tariff lowers poverty rate and is associated with increased consumption!
  * Uphill battle written about in Banarjee and Duflo book! 
  * Debate in 80s/90s about whether bad outcomes for hs graduates relative to college graduates were driven by foreign competition. By late 90s conclusion was that foreign trade was not responsible (Krugman!). Mostly about skill-biased technical change. How we think about credibility revolution and concerns about research designs means we wouldn't find satisfaction in the literature from that age. 
  * What do we make of these regressions? What would theory tell you. Stolper-Samuelson is 1948 - if you cut tariff, some factors are going to lose! So what should it do to an average outcome like the poverty rate? 
    * Poverty rate is not the most natural thing to think about in relationship to the factor price 
  * Can also think about this as a program evaluation. 
  * These are also all relative - poverty could be trending downward in aggregate 
* Kovak gives straightforward lens - tells you how to map tariff cuts to pass through of price shocks

### Autor Dorn Hanson (2013)

* Not the Ricardo-Viner Model, where you're thinking of goods shocks

* WTO entrance 2001 - no change in taxes. The things are causing changes in Chinese imports are (1) changes in uncertainty and (2) productivity growth in China

  * China's membership in WTO goes up every year, so it could be that they are in the WTO one year and then kicked out the next year
  * ADH uses (2)

* Use of trade quantities rather than prices, so they use a gravity-based model rather than specific-factor SOE

* Exogenous Chinese export supply shock in industry $j$ is $\hat{A}_{C j}$
  - Look at region $i$ 's outcomes for wages $\hat{w}_{i},$ employment in traded goods $\hat{L}_{i}^{T},$ and employment in non-traded goods $\hat{L}_{i}^{N}$
  - Treatment is exposure to import competition (shift-share design):
  $$
  \Delta \mathrm{IPW}_{U i t}=\sum_{j} \frac{L_{i j t}}{L_{U j t}} \frac{\Delta M_{U C j t}}{L_{i t}}
  $$
  * Called shift-share because I group things at the regional level and the industry level. The shift is the change in imports at the industry level. Share is the regional employment. I've got different regions that have different mixes of industries and they're being hit by the shocks. 
  * Worried about demand shocks or industry level trends in the US. So as long as there's not a global demand shock, the below instrument is valid. 
  * Instrument using non-US exposure ("other" $o$ ):

  $$
  \Delta \mathrm{IPW}_{\text {oit }}=\sum_{j} \frac{L_{i j t-1}}{L_{u j t-1}} \frac{\Delta M_{o C j t}}{L_{i t-1}}
  $$

  * Current period imports reduce amount of manufacturing employment relative to the working age population in that commuting zone. 
    * They study pre-trends because you might be worried that areas that are importing regions are just areas that were fledgling anyways. In fact, places that were doing better were the places that faced import competition in China!
  * Population response: people do seem to be leaving places that are hit by places that face import competition. But actually once you control for broader trends in migration, that result evaporates, so no population response!
  * What about switching employment to a different sector? 
    * No effect on manufacturing employment
    * Unemployment goes WAY UP
    * Not in the Labor Force (NILF) and disability go WAY UP! 
    * Particularly bad for people without a college degree
  * Huge amount of followup work to this
  * This is a diff-in-diff - how do we get to a GE effect?

Print Krugman (1980) and bring to class - going to work through it in full!!