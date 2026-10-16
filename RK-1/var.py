import random as rd

Variant = 14
rd.seed(Variant+86554338)

Numbers_of_problems = [rd.sample(range(5),1)[0]+1, rd.sample(range(5),1)[0]+1, rd.sample(range(5),1)[0]+1]
print(Numbers_of_problems)
