# Using Equity Market Reactions to Infer Exposure to Trade Liberalization

# I. Introduction

* Measure financial markets' reaction to key events associated with the new regime, assuming all new info relevant for firm value is fully reflected in its stock price
  * Measure firms' average abnormal returns (AARs) relative to market during these events to assess impact of policy change on firm value
* Estimate US firms' exposure to two US trade liberalizations, with China and Canada
* Usually in the literature, exposure to trade is defined in terms of import competition, measured via changes in tariffs or import volumes among the set of goods a worker, firm or region produces. This approach has 3 disadvantages
  1. Ignores potentially offsetting channels of exposure, for example the greater availability of low-cost foreign inputs that may allow users of these inputs to expand, or GE effects
  2. Ignores firms outside goods-producing industries, which account for vast majority of national employment
  3. Not possible for trade liberalizations that focus on non-tariff barriers
* This approach captures expected net impact of all avenues of exposure 
* Provides direct assessment of how changes in trade policy affect the return to capital, and important but understudied dimension of the distributional implications of trade
* Distributional impacts
  * While the vast majority of firms have negative predicted relative operating profit after the liberalization, a small group of very large goods and service firms with positive $AAR^{PNTR}$ are predicted to have substantial relative gains, enough to dwarf smaller firms' relative losses
  * Because these large firms are less labor-intensive than the smaller firms with negative $AAR^{PNTR}$, the cumulative predicted relative change in employment across all firms is negative, forecasting a relative increase in labor productivity - suggests part of substantial rise in labor productivity in US manufacturing observed during this period may be driven by a reallocation of activity across firms
  * Predicted relative growth in operating profit is more uniform across firms in other sectors
* Caveats
  * Can be implemented only for firms whose shares are traded publicly 
  * Firm AARs surrounding sweeping changes in policy must be interpreted with care, as they may ignore a portion of the overall systematic impact of the change in policy on the market, e.g. via changes in interest rates or exchange rates. This paper measures AARs relative to observed market returns to account for this



## 2. Theory

* As with all event studies, we start with the assumption that the markets are informationally efficient
* Assume a firm's stock price at time $t$ is a function of a state space partitioned as $\left(X_{t}, e_{t}\right)$ 
  * $e_t$ is information about policy event of interest available at time $t$
  * $X_t$ contains all other information relevant for firm value
* Policy event takes place at time $\tau$ 
  * Information is whether the policy is approved or denied
  * Assume event is unanticipated
* $P_{j,t}$ stock price of firm $j$ at time $t$
* Return: $R_{j, t}=\left(P_{j, t}-P_{j, t-1}\right) / P_{j, t-1}$
* Effect of the event on firm j's stock price is given by 

$$
A R_{j, \tau}^{*}=R_{j, \tau}-E\left(R_{j, \tau} \mid X_{\tau}\right)
$$

​	* denotes that this is the true impact of the change in policy, rather than the estimated effect

* $E\left(R_{j, \tau} \mid X_{\tau}\right)$ is the normal return function. Estimate this using reduced-form model 
  $$
  R_{j, t}=\alpha_{j}+\beta_{j} F_{t}+\epsilon_{j, t}
  $$
  * Use statistical model informed by CAPM known as the "market model" that uses the market portfolio as the single factor

* Estimate abnormal returns using 
  $$
  A R_{j, \tau}=R_{j, \tau}-\left(\hat{\alpha}_{j}+\hat{\beta}_{j} F_{\tau}\right)
  $$

  * This is only unbiased if:

    (A1) $X_{t} \text { do not affect the idiosyncratic component of returns } \epsilon_{j, \tau}$ 

    (A2) $e_{j, \tau}$ does not have an effect on the systematic factors $F_{\tau}$

    

## 3. Permanent Normal Trade Relations (PNTR) with China in 2000

### 3.1 Policy background

* US has 2 sets of import tariffs: (1) normal trade relations (NTR) and (2) significantly higher non-NTR tariffs
* US Presidents began requesting China be granted such a waiver in 1980, which became controversial after Tiananmen Square in 1989
* Ended with Congress' passage in 2000 granting China permanent normal trade relations (PNTR) status, formally taking effect upon China's entry into the WTO in December 2001
* Investment bankers expected US producers to have an easier time selling into the Chinese market and using China as an export platform, while US service providers would be granted greater access to Chinese consumers via the loosening of restrictions on FDI

### 3.2 Computing $AAR^{PNTR}$

* Calculate abnormal returns over the five steps by which a US bill becomes law:

  1. Introduction of PNTR bill in US House on May 15, 2000
  2. Vote to approve PNTR in the House on May 24
  3. Successful cloture motion to proceed with a vote on PNTR in the US Senate on July 27th
  4. Vote to approve PNTR by the Senate on September 19th
  5. Signature of PNTR into law by President Clinton on Ocotber 10

* Motivated by CAPM, impose the market portfolio return $R_{m,t}$ as the only systematic factor 
  $$
  R_{j, t}=\alpha_{j}+\beta_{j} R_{m, t}+\epsilon_{j, t}
  $$
  * Estimate this regression for every firm in the sample over all available dates in 1999
  * Chose this period to ensure $\hat{\alpha}$ and $\hat{\beta}$ are not affected by periods when relevant information about PNTR became known

* Use five-day window surrounding each of the legislative events mentioned above, for a total of 25 days

* For each day $t$ in the event window, calculate normal returns for each firm $j$ as $\hat{\alpha}_{j}+\hat{\beta}_{j} R_{m, t}$ and subtract this from the return of the firm on that day to obtain its abnormal return

* Calculate primary measure of the firm's exposure to the policy, $AAR_j^{PNTR}$ by taking an average of all the non-missing abnormal returns of the firm over the 25 days in the event windows

* Classify firms as either manufacturing or service producers

### Results

* Across all 5 events, mean $AAR_j^{PNTR}$ is $-0.37$ with a standard deviation of 1.04 percent (ok so very noisy!!)
* $AAR_i^{PNTR}$ of goods-producing firms is more left-skewed than service firms, consistent with the fact that goods-producing firms were directly exposed to increased import competition from China following PNTR, while service firms were not. 
* Firms with positive $AAR_j^{PNTR}$ are larger along almost every dimension than firms with negative relative returns, even within narrow industries, and that these premia are higher for goods producers than for service firms
  * Consistent with trade models predicting that high-efficiency firms are better able to take advantage of reductions in trade costs by, for example, selling more in foreign markets or offshoring
* Firm's $AAR_j^{PNTR}$ vary widely even within 6-digit NAICS industries

### 3.3 Validity of $AAR_j^{PNTR}$ 

* Contemporaneous validity: examine relationship between $AAR_j^{PNTR}$ and changes in expected US import tariffs, aka "NTR gaps"
  $$
  A A R_{j}^{P N T R}=\delta N T R G a p_{j}+\epsilon_{j} \\
  \text { NTR Gap}_{i}=\text { Non NTR Rate }_{i}-\text { NTR Rate }_{i} \\
  i \text{ indexes 6-digit NAICS industries}
  $$

  * NTR gap is not defined for service firms
  * Find negative and statistically significant relationship &rightarrow; firms more exposed to PNTR via direct import competition are re-valued downward relative to less-exposed firms

* Ex post validity: examine link between firm's $AAR_j^{PNTR}$ and US import growth from China 

  * Calculate weighted average of US import growth across observed business segments in 2000
  * Again restricted to manufacturing firms
  * Sample period is 2000 to 2006 (before Great Recession)
  * Find negative and statistically significant relationship between $AAR_j^{PNTR}$ and post-PNTR import growth &rightarrow; investors' reactions during the passage of PNTR anticipated an increase in import competition from China relative to the 1990s, and that this increase is not the continuation of a prior trend 

* External validity: several events in US-China relations during the 1990s likely increased uncertainty regarding annual renewal of China's NTR status in the US

  * Accidental NATO bombing of Chinese embassy in Belgrade, Yugoslavia on May 7th, 1999

  * Examine how this relates to firm's average abnormal returns in the seven trading days after the bombing occurred. 

  * Analyze following association:
    $$
    A A R_{j}^{P N T R}=\delta A A R_{j}^{B e l g r a d e}+\epsilon_{i}
    $$

  * Relationship between the AARs is negative and statistically significant at conventional levels in all three columns, indicating that firms which are expected to benefit relative to the market from a potential breakdown of US-China relations due to the bombing in 1999 are expected to be harmed in relative terms by the trade liberalization in 2000



## 4. Using $AAR_j^{PNTR}$ to Predict Firm Outcomes

Abnormal returns provide an all-in summary of the impact of a change in policy on the firm. As such, they can be used as an explanatory variable for firm outcomes, including exit, operating profit and employment

### 4.1 Firm Survival

* Account variables are commonly included in regressions of abnormal returns in the finance literature as proxies for firms' investment opportunities and their ability to finance them. These include property, plant, and equipment (PPE) per worker, firm size (as measured by log of market capitalization), profitability (cash flows to assets), book leverage, and Tobin's Q
* Higher $AAR_j^{PNTR}$ is correlated with reduced exit via contraction and bankruptcy 
* Suggests investors anticipate link between the change in trade policy and firms' future profits 

### 4.2 Relative Growth in Operating Profit, Employment, and Capital

* Use diff-in-diff specification to analyze relationship between AAR and measures of profitability among surviving firms

* Sample period is 1990 to 2006 
  $$
  \begin{aligned}
  \ln \left(\text {OperatingProfit}_{j, t}\right)=& \delta \text {Post} \times A A R_{j}^{P N T R}+\gamma \text {Post} \times \mathbf{X}_{\mathbf{j}}^{1990} \\
  &+\alpha_{j}+\alpha_{t}+\epsilon_{j, t}
  \end{aligned}
  $$

* all positive relationships for firm sales, cost of goods sold, and operating profit
* Both goods-producing and service firms with higher AAR exhibit relative increases in employment after the change in policy versus before 
* Positive relationships between AR and both physical and intangible capital 

### 4.3 Distributional Impacts

* For each firm, compute predicted relative operating profit for 2001 to 2006 using the coefficient $\hat{\delta}$ from a DID specification analogous to DID in previous section, but estimated using non-standardized covariates  
  $$
  \text { Op Profit_{j } }^{\text {Post Period }}=\left(\exp \left(\hat{\delta} \times A A R_{j}^{P N T R}\right)-1\right) \times \text {Op Profit}_{j}^{2000}
  $$

* $\hat{\delta} \times A A R_{j}^{P N T R}$ is the predicted growth in operating profit in the post-PNTR period relative to the pre-PNTR period, in log points. It is exponentiated and reduced by 1 to convert it to percentage terms, and then multiplied by operating profit in 2000 to convert it into levels
* Cumulative prot generally declines with firm size until market capitalization reaches approximately 10 billion dollars. Firms larger than that threshold exhibit modest relative increases in expected operating prot until market capitalization reaches around 100 billion dollars, at which point it rises substantially.
  * Differential expected relative growth of large firms suggests a potential role for trade liberalization in the rising share of economic activity attributed to large, old (i.e., "superstar") firms 
  * 

