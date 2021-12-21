import sys

input_file = sys.argv[1]


def increment_line(line, n):
    return "".join(
        list(
            map(
                lambda x: str((x + n - 1) % 9 + 1),
                list(map(int, list(line.strip()))),
            )
        )
    )


def wider_line(line):
    return "".join(
        list(
            map(
                lambda x: increment_line(line, x),
                range(5),
            )
        )
    )


with open(input_file) as f:
    lines = f.readlines()

for series in range(5):
    for line in lines:
        print(increment_line(wider_line(line), series))


#### remember to test with diff right in ci file
