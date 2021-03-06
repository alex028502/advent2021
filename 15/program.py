import sys

input_file = sys.argv[1]

caves = []
risk_totals = {
    (0, 0): 0,
}


with open(input_file) as f:
    for line in f:
        l = list(map(int, list(line.strip())))
        ls = [l]
        big_list = []
        for ll in ls:
            big_list = big_list + ll

        caves.append(big_list)


def get_risk_level(x, y):
    w, h = dims()
    # there are no zero-risk caves
    # so just use zero for one that do not exist
    if x < 0 or x >= w or y < 0 or y >= h:
        return None
    return caves[y][x]


def dims():
    return [
        len(caves[0]),
        len(caves),
    ]


def neighbours(x, y):
    return list(
        filter(
            lambda xy: get_risk_level(*xy),
            [
                (x - 1, y),
                (x + 1, y),
                (x, y + 1),
                (x, y - 1),
            ],
        )
    )


for i in range(10000):
    assert i < 3000, "should not take so long"
    risk_totals_copy = dict(risk_totals)
    assert risk_totals_copy == risk_totals, "????"
    # use copy to iterate to trick safeguards
    for xy, risk in risk_totals_copy.items():
        x, y = list(xy)
        for neighbour in neighbours(x, y):
            nx, ny = list(neighbour)
            calculated_new_risk = get_risk_level(nx, ny) + risk
            if risk_totals.get((nx, ny)):
                if risk_totals[(nx, ny)] <= calculated_new_risk:
                    continue

            risk_totals[(nx, ny)] = calculated_new_risk

    if risk_totals_copy == risk_totals:
        break


def fmt(num):
    return str(num + 1000)[1:]


for y in range(dims()[1]):
    sys.stderr.write(
        "|".join(
            map(lambda x: fmt(risk_totals[(x, y)]), range(dims()[0])),
        )
        + "\n"
    )

print(risk_totals[tuple(map(sum, (zip(dims(), (-1, -1)))))])
