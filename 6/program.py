import sys

input_timespan = int(sys.argv[1])
input_file = sys.argv[2]

with open(input_file, "r") as f:
    data = f.read().strip().split(",")


population = 9 * [0]

for fish in data:
    population[int(fish)] += 1

for i in range(input_timespan):
    new_population = population[1:] + [0]
    new_population[6] += population[0]
    new_population[8] += population[0]
    population = new_population

print(sum(population))
