import subprocess
import sys

# from trials and errors like this
# ./a.out 77797977999997 || echo $?
# it seems that a lot of digits don't effect the outcome but they migth effect
# it under certain conditions because there are a lot of == 0 and stuff in the
# code but let's see if th highest number of the digits that seem to matter is
# the answer

exe = sys.argv[1]

trial = 20000000
while True:
    trial = trial - 1
    if "0" in str(trial):
        continue
    template = "%s%s%s9%s9%s%s99999%s"
    arg = template % tuple(str(trial))[1:]
    p = subprocess.Popen(
        [
            exe,
            arg,
        ],
    )
    p.communicate()
    if not p.returncode:
        print(arg)
        break
