import sys

# originally defined the library in C to make it easier to translate each line
# but then changed my mind to make the assembly a little easier to read
# print("int mul(int a, int b) { return a * b; }")
# print("int add(int a, int b) { return a + b; }")
# print("int div(int a, int b) { return a / b; }")
# print("int mod(int a, int b) { return a % b; }")
# print("int eql(int a, int b) { return (a == b) ? 1 : 0; }")

print("int main(int argc, char * argv[]) {")
print("  long w = 0; long x = 0; long y = 0; long z = 0;")

inp_count = 0

ops = {
    "mul": "*",
    "add": "+",
    "div": "/",
    "mod": "%",
}

with open(sys.argv[1]) as file:
    for line in file:
        tokens = line.strip().split(" ")
        if tokens[0] == "inp":
            print("  %s = argv[1][%s] - 48;" % (tokens[1], inp_count))
            inp_count = inp_count + 1
            continue

        cmd, var, val = tokens
        if cmd == "eql":
            print("  %s = (%s == %s) ? 1 : 0;" % (var, var, val))
            continue
        if cmd == "mod":
            print("  if (%s < 0 || %s <= 0) return -10;" % (var, val))
        print("  %s = %s %s %s;" % (var, var, ops[cmd], val))
        # print("  %s = %s(%s, %s);" % (var, cmd, var, val))

# exit code don't work properly after 255 - so make sure that
# something like 512 doens't give us 0
print("  return (z > 200 || z < 0) ? 101 : z;")
print("}")
