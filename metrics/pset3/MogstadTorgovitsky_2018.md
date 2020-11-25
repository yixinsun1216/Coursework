# Identification and Extrapolation of Causal Effects with Instrumental Variables


## 2 Model

$$
Y=D Y_{1}+(1-D) Y_{0}
$$

<u>Selection into treatment:</u>

Under standard exogeneity assumption $Z$, the monotonicity condition is equivalent to the existence of a weakly separable selection (or choice) equation:
$$
D=\mathbb{1}[v(X, Z)-U \geq 0] \tag{2}
$$
$v$ is an unknown function and $U$ is continuously distributed random variable

<u>Assumptions:</u>

1. $D$ is determined by by (2) 

2. $\left(Y_{0}, Y_{1}, U\right) \perp Z \mid X$ holds true, where $\perp$ denotes conditional independence.

3. $U$ is continuously distributed, conditional on $X$.

   * Given assumption 3, one can normalize the distribution of $U|X = x$ to be uniformly distributed over $[0,1]$ for every $x$
     $$
     v(x, z) \Rightarrow p(x,z) \equiv P[D=1|X=x,Z=z]
     $$

   * Rewrite (2) as
     $$
     D=\mathbb{1}[U \leq p(X, Z)], \quad \text { where } \quad U \mid X=x, Z=z \sim \operatorname{Unif}[0,1] \text { for all } x, z
     $$
     

<u>MTE and Reponse Functions</u>
$$
\operatorname{MTE}(u, x) \equiv E\left[Y_{1}-Y_{0} \mid U=u, X=x\right]
$$

* Dependence of MTE on $u$ for a fixed $x$ allows for unobserved heterogeneity in treatment effects, as indexed by an individuals latent propensity to choose treatment, $u$. The choice equation implies that given $X$, individuals with LOWER values of $U$ are more likely to take treatment, regardless of their realization of $Z$. 

* MTE function that is declining in $u$ indicates individuals who are more likely to choose $D=1$ also experience larger gains in $Y$ from receiving the treatment 

* Work with MTR instead of MTE
  $$
  m_{0}(u, x) \equiv E\left[Y_{0} \mid U=u, X=x\right] \quad \text { and } \quad m_{1}(u, x) \equiv E\left[Y_{1} \mid U=u, X=x\right] \\
  MTE(u,x) = m_1(u,x) - m_0(u,x)
  $$

  * Working with MTR functions instead of MTE functions allows one to consider parameters and estimands that depend on $m_0$ and $m_1$ asymmetrically



<u>Running Numerical Illustration</u>

* $D$ is a binary indicator for purchasing a mosquito net

* $Z$ is an experimentally varied subsidy for the net. 

  * $Z \in\{1,2,3,4\},$ with $Z=4$ denoting the most generous subsidy
  * $P[Z=z]=1 / 4$ for each of $z=1,2,3,4$
  * $p(1)=0.12, \quad p(2)=0.29, \quad p(3)=0.48, \quad$ and $\quad p(4)=0.78$

* No covariates, for simplicity

* $Y \in \{0,1\}$ indicator for whether an individual is infected by malaria

* MTR
  $$
  m_{0}(u)=0.9-1.1 u+0.3 u^{2} \quad and \quad m_{1}(u)=0.35-0.3 u-0.05 u^{2} \\
  \text{so that} \quad m_{1}(u)-m_{0}(u)=-0.55+0.8 u-0.35 u^{2}
  $$

  * MTR decreasing in $u$ for both treated and untreated states. Aka individuals less likely to purchase mosquito net are also less likely to be afflicted by malaria
  * Think of this as individuals have private knowledge of their personal vulnerability to the disease
  * Mosquito nets reduce incidence of malaria for all individuals, but MTE is nonconstant and is larger for individuals who are more likely to purchase the net 



## Target Parameters

$$
\beta^{\star} \equiv E\left[\int_{0}^{1} m_{0}(u, X) \omega_{0}^{\star}(u, X, Z) \mathrm{d} u\right]+E\left[\int_{0}^{1} m_{1}(u, X) \omega_{1}^{\star}(u, X, Z) \mathrm{d} u\right]
$$

![image-20201115110527196](C:\Users\Yixin Sun\AppData\Roaming\Typora\typora-user-images\image-20201115110527196.png)

* ATE, ATT, and ATU can all be defined without reference to the choice model

  

### PRTE

* Relevance of ATE, ATT, and ATU is dubious when requiring or preventing treatment is conceptually or ethically infeasible

  * Policy discussions are focused on interventions that change the costs or benefits of choosing certain activities while still allowing for individuals to freely select into these activities. 
  * Ex: mandating mosquito net is not an interesting counterfactual. A more feasible, interesting, and relevant policy intervention would be to provide subsidies to purchase a mosquito net, taking into account the potential benefits of usage and costs of subsidization

* Consider policies that change $p$ and/or $Z$ but are assumed to have no impact on $(Y_0, Y_1, U, X)$ 

* A policy $a$ in this class can be summarized by a pair $\left(p^{a}, Z^{a}\right),$ consisting of a function $p^{a}$ that maps $\left(X, Z^{a}\right)$ to [0,1] and a random variable $Z^{a}$ that satisfies assumption 2. Both the function, $p^{a}$, and the joint distribution of $\left(X, Z^{a}\right)$ are assumed to be known or identified.

* A policy with these properties generates random variables representing treatment choice and outcomes under the policy. Treatment choice under a policy $a$ is given by
  $$
  D^{a} \equiv \mathbb{1}\left[U \leq p^{a}\left(X, Z^{a}\right)\right]
  $$
  The outcome of $Y$ that would be observed under policy $a$ is therefore
  $$
  Y^{a}=D^{a} Y_{1}+\left(1-D^{a}\right) Y_{0}
  $$
  Given two policies, $a_{1}$ and $a_{0}$, Heckman \& Vytlacil (1999,2005) define the PRTE of $a_{1}$ relative
  to $a_{0}$ as
  $$
  \mathrm{PRTE} \equiv \frac{E\left[Y^{a_{1}}\right]-E\left[Y^{a_{0}}\right]}{E\left[D^{a_{1}}\right]-E\left[D^{a_{0}}\right]}
  $$
  where it is assumed that $E\left[D^{a_{1}}\right] \neq E\left[D^{a_{0}}\right],$ i.e., that the policy change also changes the overall proportion of individuals who receive treatment. ${ }^{9}$

![image-20201115111447594](C:\Users\Yixin Sun\AppData\Roaming\Typora\typora-user-images\image-20201115111447594.png)

* LATE is a particular example of a PRTE



## General Framework for Inference About Causal Effects

* Any cross moment of $Y$ with a known identified function of $(D, X, Z)$ can also be expressed as the weighted sum of the two MTR functions, $m_0, m_1$ 

* Let $s$ be a known or identified measurable function of $(d, x, z)$ and define
  $$
  \beta_{s} \equiv E[s(D, X, Z) Y]
  $$

  * For any $s$, 
    $$
    \begin{array}{l}
    \beta_{s}=E\left[\int_{0}^{1} m_{0}(u, X) \omega_{0 s}(u, X, Z) \mathrm{d} u\right]+E\left[\int_{0}^{1} m_{1}(u, X) \omega_{1 s}(u, X, Z) \mathrm{d} u\right] \\
    \text { where } \omega_{0 s}(u, x, z) \equiv s(0, x, z) \mathbb{1}[u>p(x, z)] \\
    \text { and } \omega_{1 s}(u, x, z) \equiv s(1, x, z) \mathbb{1}[u \leq p(x, z)]
    \end{array}
    $$

  * Call the function $s$ an IV-like specification and call the quantity $\beta_s$ that $s$ generates an IV-like estimand 

![image-20201115112719776](C:\Users\Yixin Sun\AppData\Roaming\Typora\typora-user-images\image-20201115112719776.png)



### From What We Know to What We want

* IV-like estimands are features of the observable data

* IV-like estimands are not equal to the target parameter and thus are not themselves objects of interests

  * But they are weighted averages of the underlying MTR functions, implying that only some MTR functions are consistent with a given value of an IV-like estimand 
  * Thus, only some values of the target parameter, $\beta^\star$, are consistent with a given IV-like stimand 

* $\mathcal{S}$ is a collection of IV-like specifications $s$ chosen by the researcher

* Corresponding to each $s \in \mathcal{S}$ is a $\beta_s \equiv E[s(D,X,Z)Y]$ 

* pair of MTR functions $m \equiv\left(m_{0}, m_{1}\right)$ to lie in some admissible set, $\mathcal{M}$.

  * Admissable set encodes a priori assumptions that the researcher wishes to maintain about the MTR functions, such as parametric or shape restrictions

* View weighted integrals for the target parameter and the IV-like estimands as functions of $m$
  $$
  \Gamma^{\star}(m) \equiv E\left[\int_{0}^{1} m_{0}(u, X) \omega_{0}^{\star}(u, X, Z) \mathrm{d} u\right]+E\left[\int_{0}^{1} m_{1}(u, X) \omega_{1}^{\star}(u, X, Z) \mathrm{d} u\right] \\
  \Gamma_{s}(m) \equiv E\left[\int_{0}^{1} m_{0}(u, X) \omega_{0 s}(u, X, Z) \mathrm{d} u\right]+E\left[\int_{0}^{1} m_{1}(u, X) \omega_{1 s}(u, X, Z) \mathrm{d} u\right]
  $$

* Now suppose that the data were generated according to the choice equation under assumptions 1-3 with MTR pair $m \in \mathcal{M}$, then $m$ must satisfy 
  $$
  \Gamma_{s}(m)=\beta_{s}, \quad \forall s\in \mathcal{S}
  $$
  So $m$ must lie in the set 
  $$
  \mathcal{M}_{\mathcal{S}} \equiv\left\{m \in \mathcal{M}: \Gamma_{s}(m)=\beta_{s} \text { for all } s \in \mathcal{S}\right\}
  $$

* Then, $\beta^\star$ must belong to the set 
  $$
  \mathcal{B}_{\mathcal{S}}^{\star} \equiv\left\{b \in \mathbb{R}: b=\Gamma^{\star}(m) \text { for some } m \in \mathcal{M}_{\mathcal{S}}\right\}
  $$

  * $\mathcal{B}_{\mathcal{S}}^{\star}$ is the set of values for the target parameter that could have been generated by MTR functions that are consistent with both the assumptions of the model and the values of the IV-like estimands that were observed in the data 

* Under weak conditions on $\mathcal{M}$, it is possible to show that $\mathcal{B}_{\mathcal{S}}^{\star}$ will be a closed interval, and the process of characterizing $\mathcal{B}_{\mathcal{S}}^{\star}$ can be simplified to solving 2 optimization problems:
  $$
  \begin{aligned}
  &\underline{\beta}^{\star} \equiv \inf _{m \in \mathcal{M}} \Gamma^{\star}(m) \quad \text { subject to } \quad \Gamma_{s}(m)=\beta_{s} \text { for all } s \in \mathcal{S}\\
  &\overline{\beta}^{\star} \equiv \sup _{m \in \mathcal{M}} \Gamma^{\star}(m) \quad \text { subject to } \quad \Gamma_{s}(m)=\beta_{s} \text { for all } s \in \mathcal{S}
  \end{aligned}
  $$
  

### Computing the Bounds

Replace $\mathcal{M}$ with finite dimensional linear space For every $m \equiv (m_0, m_1) \in \mathcal{M}$ , there exists a finite dimensional vector $\theta \equiv (\theta_0, \theta_1) \in \mathbb{R}^{K_0+K_1}$ such that 
$$
m_{d}(u, x)=\sum_{k=0}^{K_{d}} \theta_{d k} b_{d k}(u, x) \quad \text { for } d=0,1
$$
where $b_{d k}(u, x)$ are known basis functions. Then we have
$$
\begin{aligned}
\Gamma^{\star}(m) &=\sum_{d \in\{0,1\}} \sum_{k=0}^{K_{d}} \theta_{d k} E\left[\int_{0}^{1} b_{d k}(u, X) \omega_{d}^{\star}(u, X, Z) \mathrm{d} u\right] \\
& \equiv \sum_{d \in\{0,1\}} \sum_{k=0}^{K_{d}} \theta_{d k} \gamma_{d k}^{\star}, \quad \text { where } \gamma_{d k}^{\star} \equiv E\left[\int_{0}^{1} b_{d k}(u, X) \omega_{d}^{\star}(u, X, Z) \mathrm{d} u\right] \\
\Gamma_{s}(m)&=\sum_{d \in\{0,1\}} \sum_{k=0}^{K_{d}} \theta_{d k} \gamma_{s d k}, \quad \text { where } \gamma_{s d k} \equiv E\left[\int_{0}^{1} b_{d k}(u, X) \omega_{d s}(u, X, Z) \mathrm{d} u\right]
\end{aligned}
$$
Then the max problem reduces to the linear program:
$$
\bar{\beta}^{\star}=\max _{\theta \in \Theta} \sum_{d \in\{0,1\}} \sum_{k=0}^{K_{d}} \gamma_{d k}^{\star} \theta_{d k} \quad \text { subject to } \sum_{d \in\{0,1\}} \sum_{k=0}^{K_{d}} \gamma_{s d k} \theta_{d k}=\beta_{s} \text { for all } s \in \mathcal{S}
$$




---





# How the F Do I Do This Pset?

Maximization Problem:
$$
\bar{\beta}^{\star}=\max _{\theta \in \Theta} \sum_{d \in\{0,1\}} \sum_{k=0}^{K_{d}} \gamma_{d k}^{\star} \theta_{d k} \quad \text { subject to } \sum_{d \in\{0,1\}} \sum_{k=0}^{K_{d}} \gamma_{s d k} \theta_{d k}=\beta_{s} \text { for all } s \in \mathcal{S} \\
\gamma_{d k}^{\star} \equiv E\left[\int_{0}^{1} b_{d k}(u, X) \omega_{d}^{\star}(u, X, Z) \mathrm{d} u\right] \\
\gamma_{s d k} \equiv E\left[\int_{0}^{1} b_{d k}(u, X) \omega_{d s}(u, X, Z) \mathrm{d} u\right]
$$
Steps to Actually Implementing ATT

1. For each row of data, estimate propensity score using logit/probit

2. For each row of data, calculate weights for objective function:
   $$
   \omega_1^\star(u, z) = \frac{1[u \leq p(x, z)]}{P[D=1]} \\
   \omega_0^\star(u, z) = -\omega_{1}^{\star}(u, z)
   $$
   

3. Calculate 2 sets of $\beta_s$ and for each row of data, calculate weights for our IV-like estimands (Table 3)

   1.  IV: 
      $$
      \beta_s = \frac{\operatorname{Cov}(Y, Z)}{\operatorname{Cov}(D, Z)} \\
      s(d,z) = \frac{z-E[Z]}{\operatorname{Cov}(D, Z)}
      $$
      

   2. TSLS (jth component):
      $$
      \beta_s = e_{j}^{\prime}\left(\Pi E\left[\widetilde{Z} \tilde{X}^{\prime}\right]\right)^{-1}(\Pi E[\widetilde{Z} Y]) \\
      s(d,z) = e_{j}^{\prime}\left(\Pi E\left[\widetilde{Z} \tilde{X}^{\prime}\right]\right)^{-1} \Pi \widetilde{Z} \\
      \widetilde{X} \equiv\left[1, D, X^{\prime}\right]^{\prime} \\
      \widetilde{Z} \equiv\left[1, Z, X^{\prime}\right]^{\prime} \\
      \Pi \equiv E\left[\widetilde{X} \widetilde{Z}^{\prime}\right] E\left[\widetilde{Z} \widetilde{Z}^{\prime}\right]^{-1}
      $$
      

      Should we be using just the TSLS that doesn't change with with j? 

      Remember that
      $$
      \begin{array}{l}
      \omega_{0 s}(u, z) \equiv s(0, z) \mathbb{1}[u>p(z)] \\
      \omega_{1 s}(u, z) \equiv s(1, z) \mathbb{1}[u \leq p(z)]
      \end{array}
      $$

4. For each row of data, generate Bernstein polynomial basis:
   $$
   b_{k}^{K}(z) \equiv\left(\begin{array}{l}
   K \\
   k
   \end{array}\right) u^{k}(1-u)^{K-k}
   $$

5. Now I can compute $\gamma_{sdk}$ and $\gamma^\star_{dk}$ 

   1. so this should give me $m = \#s \times \#d \times k$  values for $\gamma_{sdk}$ (so $\#s  = 2$ and $\#d = 2$ in this case)
   2. and this should give me $\ell = \#d \times k$ values for $\gamma_{dk}$ 

   Now I am optimizing one objective function subject to 2 constraints. The constraints are 2 equations and $m$ unknown $\theta_{dk}$'s. 

6. Once I take the max and min from step 5 using gurobi, then I can solve for the max and min $\beta^\star$