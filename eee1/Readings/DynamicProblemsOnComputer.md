## Dynamic Problems on Computer

2 types of problems in pset

1. Simple discrete time problem with different demand curves
2. Third question is a real options problem - given stochastic oil expectation, when do I want to drill



Ultimately the way to solve it is to set up the Bellman:
$$
V(s)=\max _{a}\left\{\pi(a, s)+\delta \int V\left(s^{\prime}\right) d P\left(s^{\prime} \mid a, s\right)\right\}
$$

* Trying to solve for this non-analytic value function
  * Third function floating around is the policy function
* Idea is tp take the problem and discretize state and control spaces (one big vector for each)
  1. For each state, the value function is a vector, $V_s$. Policy function is another big vector. Bellman maps these $V_s$ into itself 
  2. Solve the Bellman equation through value function iteration. Take initial guess for what value function is, and maximizing the Bellman function, holding current guess fixed. Picked he action that maximizes that, which gives you a value function, and keep plugging back in. Value function is guaranteed to converge if you run it enough times (because it's a contraction mapping)
* Curse of dimensionality (not the case in the problem set): state spaces grow up very very quickly 
* Sparse matrix tells computer to only store non-zero values - very useful for saving on RAM