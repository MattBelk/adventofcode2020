steps, ns = 30000000, [18,11,9,0,5,1]
last, c = ns[-1], {n: i+1 for i, n in enumerate(ns)}
for i in range(len(ns), steps):
    c[last], last = i, i - c.get(last, i)
print(last)