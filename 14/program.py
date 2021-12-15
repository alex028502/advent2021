import sys

# game plan
# NNCB
# add Nx2 Cx1 Bx1
# NN NC CB
# C  B  H
# add Cx1 Bx1 Hx1
# total Cx2 Bx2 Hx1 Nx2
# NC CN NB BC

steps = int(sys.argv[1])
input_file = sys.argv[2]

rules = {}
template = ""
with open(input_file) as f:
    for line in f:
        if line.strip() == "":
            continue
        if "->" in line:
            k, v = map(lambda x: x.strip(), line.split("->"))
            rules[k] = v
        else:
            template = line.strip()

score = {}
pairs = {}


def increment_dict_at(d, k, inc=1):
    d[k] = d.get(k, 0) + inc


for i in range(0, len(template) - 1):
    pairs[template[i : i + 2]] = 1

for x in template:
    increment_dict_at(score, x)

for i in range(steps):
    new_pairs = {}
    for pair, f in pairs.items():
        increment_dict_at(score, rules[pair], f)
        increment_dict_at(
            new_pairs,
            pair[0] + rules[pair],
            f,
        )
        increment_dict_at(
            new_pairs,
            rules[pair] + pair[1],
            f,
        )

    pairs = new_pairs

print(max(score.values()) - min(score.values()))
