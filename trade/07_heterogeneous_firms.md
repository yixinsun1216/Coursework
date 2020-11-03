## Heterogeneous Firms

* Firms that export are very different from firms that don't export - what are the consequences of some firms being highly productive and likely to export? 

<u>Five summary factors about firms in international trade</u>

1. Very few firms export: $4 \%$ of 5.5 million US firms are exporters
2. A few firms dominate exporting: top $10 \%$ of exporters account for $96 \%$ of exports. 
   1. Holds even for manufacturing firms where they are creating tradable goods 
   2. Higher education and international McKinsey consulting counts as exports
   3. But most of what we talk about in the class is with manufacturing because (1) hard to measure productivity (2) hard to get detailed data
3. Exporters are bigger than non-exporters: Average exporting firm is twice the size of average non-exporter
   1. Is this a causal relationship or not? Learning by exporting? Selection?
   2. Melitz model: takes position that it's all a symptom - fixed level of productivity that's randomly drawn by the firm. 
4. Art Vandelay: More than $50 \%$ of importing firms export 
   1. Earlier literature view these decisions in isolation
   2. Firms tend to global on both margins
5. Churning: About $10 \%$ start or stop exporting annually

<u>Slide 4: Most manufacturing firms don't export</u>

* 1 out of 3 firms export
* Use to be 18% - switched from using US Census of Manufacturing (firm reports once every 5 years) to working with LFTTD data where they took customs data and link to firm identifiers
* Conditional exporting, third column shows fraction of sales that is exports. Vast majority of sales is still in US, even for exporting firms. US is just a large base of customers!

<u>Slide 5: Few firms dominated exporting</u>

* 40% of firms sell one thing to one country
* Those 40% are responsible for .2% of export value!
* All of the action is happening with the 12% of firms who are exporting more than 5 products to more than five countries

<u>Slide 6: Exporters are bigger than non-exporter</u>

* Exporter premia: difference in average characteristic of firms that export - average characteristics of firms that don't export
* Conditional exporter premia was not dealt with in first generation of these papers
* Quality and productivity need to be interacted. 

<u>Slide 7 Productivity premia</u>

* Labor productivity relative to industry means
* Nothing like a Melitz split - distributions are different between exporters and nonexporters but there's a huge amount of overlap

<u>Importers, exporters, and multinationals</u>

* Vast majority of firms happen in firms that are owning foreign subsidiaries 
* 90% of US trade are done by firms who are multinational enterprises 
* Employment shares - firms that trade are responsible for almost half of labor. 
* 27% of labor share is for multinationals. 

<u>Exporting Dynamics</u>

* Considerable churning. US seems to be in equilibrium, as compared to Chile
* Future exporters are larger and faster-growing than other non-exporters &rightarrow; makes you worry about selection that firms that were already better then become exporters
* Exporters are more likely to enter new markets geographically contiguous with current export destinations
* Sharing a border reduces estimated entry cost for Chilean chemical manufacturers by 20%-40%
  * Dynamic decision process: if you're already selling to Spain, that lowers cost of selling to Portugal by 20-40%. 

## Trade Liberalization and Reallocation Across Firms

* decompose change in aggregate productivity into between- and within-firm components
* Finding that trade liberalization raised shares of more productive
  firms motived theoretical work on heterogeneous firms
* Measuring firm-level TFP is plagued by simultaneity and selection biases
* Measuring TFP is hard: see recent survey by Jan de Loecker and Penny Goldberg that emphasizes profitability vs productivity, TFPQ vs TFPR, markups, learning by exporting, and so forth
* Pavcnik (2002) is an early and influential paper that applied Olley and Pakes (1996) technique to estimate TFP and assess Chile's 1970s



## Pavcnik (2002)

* Chile liberalized trade 1974 - 1979 (tariffs "often surpassing 100% in 1974" reduced to uniform 10%)
* Has planet-level panel data for 1979-1986
* No plant-level data on exporting behavior
* Classify industries as import-competing, export-oriented, or non-tradable based on penetration (doesn't use tariff rates)
* Exit is important: 35% of plants exited between 1979 and 1986; exiting plants on average 8% less productive than survivors
  * Consumers have love of variety, so it's not clear if this is good or not!
* Industry productivity growth decomposed into unweighted average and share-productivity covariance (Table 3) shows 2/3 of aggregate productivity improvement due to between-plant shifts
* Industry productivity regressed on orientation $\times$ year dummies (Table 4) shows substantial productivity increases 1979-1986 for import-competing sectors compared to non-tradables and no such improvements for export-oriented sectors 
  * Sensible - previously protected sectors now hammered by imports 

## Melitz  Ecma 2003)

* Melitz (2003) is a model with heterogeneous firms and fixed costs
  of exporting that can speak to productivity premia and trade liberalization causing intra-industry reallocation
* Two building blocks:
  1. Krugman (AER 1980): CES preferences, IRS technology,
     monopolistic competition
  2. Hopenhayn (JPE 1992): equilibrium model of entry and exit
     1. Exogenous death rate in Melitz, which is orthogonal to size of firm
* Are trade-induced reallocations of labor from less to more productive firms a "new" source of gains from trade?

<u>Preferences and Production</u>

* As in Krugman $(1980),$ representative agent has CES preferences:
  $$
  U=\left[\int_{\omega \in \Omega} q(\omega)^{\frac{\sigma-1}{\sigma}} \mathrm{d} \omega\right]^{\frac{\sigma}{\sigma-1}}
  $$

* Consumption and expenditure on each variety are
  $$
  q(\omega)=Q\left[\frac{p(\omega)}{P}\right]^{-\sigma} \quad r(\omega)=R\left[\frac{p(\omega)}{P}\right]^{1-\sigma}
  $$
  where $P \equiv\left[\int_{\omega \in \Omega} p(\omega)^{1-\sigma} \mathrm{d} \omega\right]^{\frac{1}{1-\sigma}}$ and $R \equiv \int_{\omega \in \Omega} r(\omega) \mathrm{d} \omega$

* As in Krugman $(1980),$ endowed labor $L$ is only factor of production
  with wage $w$ and IRS production function has fixed cost and constant
  marginal cost
  $$
  \begin{array}{cc}
  l=f+q / \varphi & p(\varphi)=\frac{\sigma}{\sigma-1} \frac{w}{\varphi} \\
  r(\varphi)=R(P \rho \varphi)^{\sigma-1} & \pi(\varphi)=\frac{1}{\sigma} r(\varphi)-f
  \end{array}
  $$

* Firms are heterogeneous in $\varphi$ 

* Variable profits are constant fraction of revenue and revenue is just a power function of productivity and other terms that are same across firms

<u>Decentralized equilibrium is efficient</u>

See Dixit and Stiglitz (1977) and Dhingra and Morrow (2019)

* Lemma 1: Decentralized equilibrium solves revenue maximization:

$$
\max _{q_{i}, n} \int_{0}^{n} p_{i}\left(q_{i}\right) q_{i} \mathrm{d} i \quad \text { s.t. } n f+\int_{0}^{n} q_{i} / \varphi_{i} \mathrm{d} i \leq L
$$
* Social planner solves:

$$
\max _{q_{i}, n} \int_{0}^{n} q_{i}^{\frac{\sigma-1}{\sigma}} \mathrm{d} i \quad \text { s.t. } n f+\int_{0}^{n} q_{i} / \varphi_{i} \mathrm{d} i \leq L
$$
- Constraints are the same so we just have to make utilities match &rightarrow; CES preferences and constant marginal costs make $r(\varphi) \propto \varphi^{\sigma-1}, q(\varphi) \propto \varphi^{\sigma} \Rightarrow p_{i}\left(q_{i}\right) q_{i} \propto q_{i}^{\frac{\sigma-1}{\sigma}},$ so solutions coincide
  - It's a particular functional form that gives happy coincidences - knife-edge case for so many different properties of consumer demand!
- Thus, many aggregate properties of Melitz (2003) coincide with
those of perfectly competitive models
- As is so often the case, CES is a very special demand system. So we market coinciding with perfect competition case
- Dhingra and Morrow is about whether this holds with heterogeneous firms 

<u>Aggregate outcomes (closed economy)</u>

* End up with something that looks like Krugman model
* But $\tilde{\varphi}$ is endogenous and may depend on trade costs

<u>Entry and Exit</u>

* In stationary equilibrium, active firm earns $\pi(\varphi)$ each period
* There is a unique productivity cutoff, given fixed costs
* The conditional pdf is $\mu(\varphi)$ 

SKIPPING A LOT OF MATH HERE



## Revisiting many questions with firm heterogeneity

Melitz and Redding (2014) Handbook of International economics chapter for overview of extentions

<u>Bernard, Redding, and Schott (2007)</u>

* Are firms a new mechanism that can overturn the neoclassical mechanism of factor intensity and factor abundance
* Introduce multiple industries that vary in factor intensity and countries that vary in factor abundance 
* Think of interaction between firm reallocations and multiple factors of production within a firm

<u>Melitz and Ottaviano (2008) - Variable Markups</u>

* Linear demand delivers variable markups 
* Market size affect markups, profits, and productivity cutoff in closed economy 

<u>Chaney (2008) - Trade Elasticity</u>

* 