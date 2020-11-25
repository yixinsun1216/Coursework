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