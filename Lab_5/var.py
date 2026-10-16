import random as rd

Variant = 14
rd.seed(Variant)

Numbers_of_problems = [i+1 for i in rd.sample(range(11),2)]
print(Numbers_of_problems)
