import sys

# originally defined the library in C to make it easier to translate each line
# but then changed my mind to make the assembly a little easier to read
print("int mul(int a, int b) { return a * b; }")
print("int add(int a, int b) { return a + b; }")
print("int div(int a, int b) { return a / b; }")
print("int mod(int a, int b) { return a % b; }")
print("int eql(int a, int b) { return (a == b) ? 1 : 0; }")

print("int main(int argc, char * argv[]) {")
print("  int w = 0; int x = 0; int y = 0; int z = 0;")

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
        # if cmd == "eql":
        #     print("  %s = (%s == %s) ? 1 : 0;" % (var, var, val))
        #     continue
        # print("  %s = %s %s %s;" % (var, var, ops[cmd], val))
        print("  %s = %s(%s, %s);" % (var, cmd, var, val))

# also tried changing to return z == 0; to see if that made a difference but
# it didn't, and this one can be tested a little easier with the test program
print("  return z;")
print("}")
