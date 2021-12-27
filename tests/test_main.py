import subprocess
import os
import uuid
import sys

import pytest


@pytest.fixture
def test_dir():
    return os.path.dirname(os.path.realpath(__file__))


@pytest.fixture
def sut_dir(test_dir):
    return os.path.dirname("%s/../" % test_dir)


@pytest.fixture
def data_dir(test_dir):
    return "%s/data" % test_dir


def input_file(folder, *args):
    input_text = "\n".join(map(str, args)) + "\n"
    return raw_input_file(folder, input_text)


def raw_input_file(folder, input_text):
    input_file_path = "%s/%s.txt" % (folder, uuid.uuid1())
    with open(input_file_path, "w") as f:
        f.write(input_text)
    return input_file_path


def get_output(program, *args):
    return get_output_from("racket", program, *args)


def get_output_from(*args):
    process = subprocess.Popen(
        args,
        stdout=subprocess.PIPE,
    )

    return process.communicate()[0].decode("utf-8").strip()


@pytest.mark.parametrize("implementation", ["original", "recursive"])
def test_demo2020(tmp_path, sut_dir, implementation):
    input_file_path = input_file(tmp_path, 1721, 979, 366, 299, 675, 1456)

    output = get_output(
        "%s/00/%s.rkt" % (sut_dir, implementation),
        input_file_path,
    )
    assert output == "514579"


day_1_cases = [
    ["original", [], "7"],
    ["recursive", ["1"], "7"],
    ["recursive", ["3"], "5"],  # part ii
]


@pytest.mark.parametrize("case", day_1_cases)
def test_1(tmp_path, sut_dir, case):
    implementation, args, answer = case
    input_file_path = input_file(
        tmp_path,
        199,
        200,
        208,
        210,
        200,
        207,
        240,
        269,
        260,
        263,
    )

    output = get_output(
        "%s/01/%s.rkt" % (sut_dir, implementation),
        *(args + [input_file_path]),
    )
    assert output == answer


# I redid the program and then I after reading the manual again, I wrote a new
# program - I could have modified an old program if I had done it recursively
# but in part-i the order didn't matter and now it does
day_2_cases = [
    ["program", "150"],
    ["again", "150"],
    ["part-ii", "900"],
]


@pytest.mark.parametrize("case", day_2_cases)
def test_2(tmp_path, sut_dir, case):
    version, answer = case
    input_file_path = input_file(
        tmp_path,
        "forward 5",
        "down 5",
        "forward 8",
        "up 3",
        "down 8",
        "forward 2",
    )

    output = get_output("%s/02/%s.rkt" % (sut_dir, version), input_file_path)
    assert output == answer


def test_3(tmp_path, sut_dir):
    input_file_path = input_file(
        tmp_path,
        "00100",
        "11110",
        "10110",
        "10111",
        "10101",
        "01111",
        "00111",
        "11100",
        "10000",
        "11001",
        "00010",
        "01010",
    )

    output = get_output("%s/03/program.rkt" % sut_dir, input_file_path)
    assert output == "198\n230"  # part i and part ii


def test_4(data_dir, sut_dir):
    # stop generating the file - the sample data are getting harder to turn
    # into a python list before turning back into a text file
    # easier to skip the middle man now
    # and that means we can load the test input in the repl
    input_file_path = "%s/04.txt" % data_dir

    output = get_output("%s/04/program.rkt" % sut_dir, input_file_path)
    assert output == "(4512 1924)"  # part i and part ii together


def test_4_flipped(data_dir, sut_dir, tmp_path):
    # since their example only deals with rows, I need to flip the whole
    # problem in python to make sure that it'll work for matching columns
    # and to do that I have to recreate all the array loading logic here
    original_input_file_path = "%s/04.txt" % data_dir
    with open(original_input_file_path) as f:
        original_content = f.read()

    # split it on the blank lines
    # in the implementation we depended on counting the lines
    # having filtered out the line breaks
    chunks = original_content.strip().split("\n\n")

    adjusted_content = chunks[0] + "\n\n"

    # quickly test the helpers we are gonna use
    assert trim_matrix_str(chunks[1]) == format_matrix(parse_matrix(chunks[1]))
    for chunk in chunks[1:]:
        matrix = parse_matrix(chunk)
        print(matrix)
        # print(list(zip*matrix))
        adjusted_content += format_matrix(zip(*matrix)) + "\n\n"

    print(adjusted_content)

    input_file_path = raw_input_file(tmp_path, adjusted_content)

    output = get_output("%s/04/program.rkt" % sut_dir, input_file_path)
    assert output == "(4512 1924)"


def parse_matrix(matrix_string):
    # not using any filter or map in these tests
    # trying to make them as non functional as possible
    matrix = []
    for line in matrix_string.split("\n"):
        matrix.append(line.replace("  ", " ").strip().split(" "))
    return matrix


def format_matrix(matrix):
    result = []
    for line in matrix:
        result.append(" ".join(line))
    return "\n".join(result)


def trim_matrix_str(matrix_string):
    old_lines = matrix_string.split("\n")
    new_lines = []
    for line in old_lines:
        new_line = line
        while "  " in new_line:
            new_line = new_line.replace("  ", " ")
        new_lines.append(new_line.strip())
    return "\n".join(new_lines)


# we no longer support day 5 part i
def test_5_2(data_dir, sut_dir):
    input_file_path = "%s/05.txt" % data_dir

    output = get_output("%s/05/program.rkt" % sut_dir, input_file_path)
    assert output == "12"


@pytest.mark.parametrize("how", [["racket", "rkt"], [sys.executable, "py"]])
@pytest.mark.parametrize("what", [[18, 26], [80, 5934], [256, 26984457539]])
def test_6(tmp_path, sut_dir, how, what):
    interpreter, ext = how
    n, answer = what
    input_file_path = input_file(tmp_path, "3,4,3,1,2")

    output = get_output_from(
        interpreter,
        "%s/06/program.%s" % (sut_dir, ext),
        str(n),
        input_file_path,
    )
    assert output == str(answer)


def test_7(tmp_path, sut_dir):
    input_file_path = input_file(tmp_path, "16,1,2,0,4,2,7,1,2,14")

    output = get_output("%s/07/program.rkt" % sut_dir, input_file_path)
    assert output == "part i: 37\npart ii: 168"


def test_8(data_dir, sut_dir):
    input_file_path = "%s/08.txt" % data_dir

    output = get_output("%s/08/program.rkt" % sut_dir, input_file_path)
    assert output == "26\n61229"


def test_9(data_dir, sut_dir):
    input_file_path = "%s/09.txt" % data_dir

    output = get_output("%s/09/program.rkt" % sut_dir, input_file_path)
    assert output == "15\n1134"


def test_10(data_dir, sut_dir):
    input_file_path = "%s/10.txt" % data_dir

    output = get_output("%s/10/program.rkt" % sut_dir, input_file_path)
    assert output == "part i: 26397\npart ii: 288957"


# if I turn everything into a string in the test with str then I can put int
# or string into the test cases!
test_cases_11 = [
    ["11-mini", 0, 0],  # nothing
    ["11-mini", 1, 9],  # shown in example
    ["11-mini", 2, 9],  # shown in example
    ["11", 0, 0],  # nothing
    ["11", 1, 0],  # nothing after first step in example
    ["11", 2, 35],  # counted 35 in example
    ["11", 3, 80],  # counted 45 in next frame in example
    ["11", 10, 204],  # given in example
    ["11", 100, 1656],  # given in example
    ["11-special", 100, 20],  # two independent octopuses
    ["11-special", "--predict-synchroflash", "infinity"],  # "no solution"
    ["11", "--predict-synchroflash", 195],  # part ii example
]


@pytest.mark.parametrize("case", test_cases_11)
def test_11(data_dir, sut_dir, case):
    f, turns, answer = case
    input_file_path = "%s/%s.txt" % (data_dir, f)
    output = get_output(
        "%s/11/program.rkt" % sut_dir,
        str(turns),
        input_file_path,
    )

    assert output == str(answer)


# the funny thing about this program is that it's work for two boards in the
# same file and I didn't even plan that! I am going to take advantage of that
# for part two take advantage of this for error checking
def test_11_special_case(data_dir, sut_dir, tmp_path):
    turns = 2
    # we know we have two cases for two files for 2 turns
    matching_cases = list(filter(lambda case: case[1] == turns, test_cases_11))
    assert len(matching_cases) == 2
    # generate a combined input file with a blank line between
    # want to use existing helpers so using cat to combine the files
    # could have made the middle file '-' and then piped in \n but then again
    # would have to modify helpers
    # and since this test is sort of an extra curricular activity
    # I don't want to modify too many things if I don't have to
    spacer_file = raw_input_file(tmp_path, "\n")
    combined_input = get_output_from(
        "cat",
        "%s/%s.txt" % (data_dir, matching_cases[0][0]),
        spacer_file,
        "%s/%s.txt" % (data_dir, matching_cases[1][0]),
    )

    input_file_path = raw_input_file(tmp_path, combined_input)
    answer = matching_cases[0][2] + matching_cases[1][2]

    output = get_output(
        "%s/11/program.rkt" % sut_dir,
        str(turns),
        input_file_path,
    )

    assert output == str(answer)


test_12_examples = ["small", "medium", "large", "small-ii", "large-ii"]


@pytest.mark.parametrize("example", test_12_examples)
def test_12(data_dir, sut_dir, example):
    # use an if this time instead of a list
    # so the test output looks nicer
    sample = example  # names could be better!
    part = "i"
    if example == "small":
        answer = "10"
    elif example == "small-ii":
        sample = "small"
        part = "ii"
        answer = "36"
    elif example == "medium":
        answer = "19"
    elif example == "large-ii":
        sample = "large"
        answer = 226
    else:
        assert example == "large"
        answer = "226"

    input_file_path = "%s/12-%s.txt" % (data_dir, sample)
    output = get_output(
        "%s/12/program.rkt" % sut_dir,
        part,
        input_file_path,
    )

    if example == "large-ii":
        # we don't know the answer by we know that it is higher than the part i
        # answer, and this will at least make sure we can calculate something
        # that big
        assert int(output) >= answer
    else:
        assert output == answer


def test_13(data_dir, sut_dir, tmp_path):
    input_file_path = "%s/13.txt" % data_dir
    original_sample_output_file_path = "%s/13-output.txt" % data_dir
    expected_output_file_path = "%s/13.txt" % tmp_path

    # ----------------
    # funny thing happend - I originally decided to use diff to see if the
    # files were the same so that I didn't have to open the expected output
    # file here, but then I realised that there are all these extra dots at
    # the bottom, and I am not going to need those to say what is written
    # and so it is easier to ignore them, but now I need to process the
    # so no it turns out I _do_ have to do something to the sample output
    # but I have already done all this cool stuff with piping subprocesses
    # around, so I am just gonna generate a file (with grep this time) using
    # and get rid of the blank lines - I am kind of cheating because I know
    # that there are no blank columns on the ends in the example except that
    # and I could just change my sample output file but I think this is better
    # because I have a record of the relationship between what is in the
    # question and my test

    with open(expected_output_file_path, "w") as f:
        p = subprocess.Popen(
            [
                "grep",
                "#",
                original_sample_output_file_path,
            ],
            stdout=f,
        )
        p.communicate()
        assert not p.returncode

    # end of funny thing that happened
    # ----------------

    # this script writes the number of points after each step to stderr
    # and then the final picture to stdout
    # (like the number of points is the log)

    # using diff to compare instead of capture stderr and stdout
    # to avoid opening the expected output file
    # this isn't any easier or better than just capture the output and
    # getting the content of the file and asserting that they are the same
    # I just want to learn to hook two processes together in python while I
    # am here

    diff_process = subprocess.Popen(
        ["diff", "-", expected_output_file_path],
        stdin=subprocess.PIPE,
    )

    sut_process = subprocess.Popen(
        [
            "racket",
            "%s/13/program.rkt" % sut_dir,
            input_file_path,
        ],
        stdin=subprocess.PIPE,
        stderr=subprocess.PIPE,
        stdout=diff_process.stdin,
    )

    stderr = sut_process.communicate()[1].decode("utf-8").strip()
    # stdout, stderr = map(
    #     lambda x: x.decode("utf-8").strip(),
    #     process.communicate()
    # )

    with open(input_file_path) as f:
        initial_number_of_dots = len(
            list(filter(lambda x: "," in x, f.readlines()))
        )

    diff_process.communicate()
    # only assert the corret answer to part i, and the initlal number that we
    # can calculate - if the real thing messes up the arrows, and puts them on
    # every line, I have no way of testing that with our two fold sample
    # but no big deal - just like how I don't test the final \n in every
    # program because I strip the output before asserting

    # just assert what I know about the log
    # first is number of dots
    # second number is the part i answer and has an arrow
    assert stderr.startswith("%s\n17<-\n" % initial_number_of_dots)
    # there are three answers total
    assert len(stderr.split("\n")) == 3
    # no other arrows
    assert stderr.count("<-") == 1

    # diff is checked by the process above but if it fails the diff will be
    # in the pytest log that it shows
    assert not diff_process.returncode


# try something different so that I can read the case name
@pytest.mark.parametrize("case", ["rkt-10", "py-10", "py-40"])
def test_14(data_dir, sut_dir, case):
    input_file_path = "%s/14.txt" % data_dir
    ext, steps = case.split("-")

    if ext == "rkt":
        interpreter = "racket"
    else:
        assert ext == "py"
        interpreter = sys.executable

    answers = {
        "10": 1588,
        "40": 2188189693529,
    }

    output = get_output_from(
        interpreter,
        "%s/14/program.%s" % (sut_dir, ext),
        steps,
        input_file_path,
    )

    assert output == str(answers[steps])


# The program I wrote in racket only allows you to move right and down
# I assumed that from looking at their picture instead of reading the
# instructions carefully where it said "no diagonals" no I guess they would
# have said "no up and left" if they had meant that
# I am still leaving the racket program here to show that it passes with the
# example they gave, but I made up my own example after this that only work
# with my emergency python program


@pytest.mark.parametrize("language", [sys.exectutable, "racket"])
def test_15(data_dir, sut_dir, tmp_path, language):
    if language == "racket":
        program = "%s/15/program.rkt" % sut_dir
    else:
        assert "python" in language
        program = "%s/15/program.py" % sut_dir

    input_file_path = "%s/15.txt" % data_dir

    output = get_output_from(language, program, input_file_path)
    assert output == "40"

    # my was wrong somehow so first thing I am going to do is remove a line
    # from the bottom and see if I still get the right answer and maybe if I
    # am lucky the assymetry will lead to an error

    truncated_input_file_path = "%s/truncated.txt" % tmp_path

    with open(truncated_input_file_path, "w") as f:
        p = subprocess.Popen(
            [
                "head",
                "-n-1",
                input_file_path,
            ],
            stdout=f,
        )
        p.communicate()
        assert not p.returncode

    truncated_output = get_output_from(
        language,
        program,
        truncated_input_file_path,
    )
    assert truncated_output == "39"

    # change "square1" to 9 and prove that it doesn't change the answer
    square1_input_file_path = "%s/square1.txt" % tmp_path
    with open(input_file_path, "r") as original_f:
        with open(square1_input_file_path, "w") as modified_f:
            original_content = original_f.read()
            modified_content = "9" + original_content[1:]
            assert len(original_content) == len(modified_content)
            modified_f.write(modified_content)

    diff_p = subprocess.Popen(
        [
            "diff",
            square1_input_file_path,
            input_file_path,
        ],
    )
    diff_p.communicate()
    assert diff_p.returncode == 1, "2 means error; 1 means different"

    square1_output = get_output_from(
        language,
        program,
        square1_input_file_path,
    )
    assert square1_output == "40"


# it could be something like this

special_cases_15 = [
    [
        "1111",
        "9991",
        "1111",
        "1999",
        "1111",
    ],
    [
        "19111",
        "19191",
        "19191",
        "11191",
    ],
]


@pytest.mark.parametrize("case", special_cases_15)
def test_15_special_cases(data_dir, sut_dir, tmp_path, case):
    program = "%s/15/program.py" % sut_dir
    right_answer = "13"

    input_file_path = "%s/back-n-forth.txt" % tmp_path
    with open(input_file_path, "w") as f:
        f.write("\n".join(case) + "\n")

    output = get_output_from(sys.executable, program, input_file_path)
    assert output == right_answer


def test_15_part_ii(data_dir, sut_dir, tmp_path):
    program = "%s/15/program.py" % sut_dir
    original_input_file_path = "%s/15.txt" % data_dir
    input_file_path = "%s/15.txt" % tmp_path

    with open(input_file_path, "w") as f:
        p = subprocess.Popen(
            [
                sys.executable,
                "%s/15/times5.py" % sut_dir,
                original_input_file_path,
            ],
            stdout=f,
        )
        p.communicate()
        assert not p.returncode

    p = subprocess.Popen(
        [
            "cat",
            input_file_path,
        ],
    )
    p.communicate()
    assert not p.returncode

    output = get_output_from(
        sys.executable,
        program,
        input_file_path,
    )
    assert output == "315"


# this is only one sample of 4 - most samples are covered by unit tests
def test_16_part_i(data_dir, sut_dir):
    input_file_path = "%s/16.txt" % data_dir

    output = get_output(
        "%s/16/program.rkt" % sut_dir,
        input_file_path,
        "--version-sum",
    )

    assert output == "31"


def test_16_part_ii(data_dir, sut_dir, tmp_path):
    input_file_path = raw_input_file(tmp_path, "880086C3E88112")
    output = get_output(
        "%s/16/program.rkt" % sut_dir,
        input_file_path,
    )

    assert output == "7"


def test_17(data_dir, sut_dir, tmp_path):
    input_file_path = raw_input_file(
        tmp_path,
        "target area: x=20..30, y=-10..-5",
    )
    output_i = get_output(
        "%s/17/part-i/program.rkt" % sut_dir,
        input_file_path,
    )

    assert output_i == "45"

    output_ii = get_output(
        "%s/17/part-ii/program.rkt" % sut_dir,
        input_file_path,
    )

    assert output_ii == "\n".join(
        [
            "45 <- answer to part i the hard way",
            "112 <- answer to part ii",
        ]
    )


def test_18(data_dir, sut_dir):
    input_file_path = "%s/18.txt" % data_dir
    output = get_output(
        "%s/18/program.rkt" % sut_dir,
        input_file_path,
    )

    assert output == "4140\n3993"


@pytest.mark.parametrize("n", [0, 1, 2])
def test_20(sut_dir, tmp_path, n):
    input_file_path = "%s/20.txt" % tmp_path

    with open(input_file_path, "w") as f:
        p = subprocess.Popen(
            [
                "racket",
                "-t",
                "%s/20/sample.rkt" % sut_dir,
                "-m",
            ],
            stdout=f,
        )
        p.communicate()
        assert not p.returncode

    output = get_output(
        "%s/20/program.rkt" % sut_dir,
        str(n),
        input_file_path,
    )

    expected_results = {
        0: 10,
        1: 24,
        2: 35,
    }

    assert output == str(expected_results[n])


# not parsing the input file today
# just passing in two arguments
def test_21(sut_dir):
    output = get_output_from(
        "%s/21/program.sh" % sut_dir,
        "4",
        "8",
        "--practice",
    )

    assert output == "739785"


def test_22(data_dir, sut_dir):
    assert (
        get_output_from(
            "%s/22/program.sh" % sut_dir,
            "%s/22.txt" % data_dir,
            "--initialization-procedure",
        )
        == "590784"
    )


def test_22_more(data_dir, sut_dir):
    # test data from part ii - they give a part i answer
    assert (
        get_output_from(
            "%s/22/program.sh" % sut_dir,
            "%s/22-ii.txt" % data_dir,
            "--initialization-procedure",
        )
        == "474140"
    )


def test_22_part_ii(data_dir, sut_dir):
    assert (
        get_output_from(
            "%s/22/program.sh" % sut_dir,
            "%s/22-ii.txt" % data_dir,
        )
        == "2758514936282235"
    )


@pytest.mark.parametrize("input_mode", ["original", "modified"])
def test_24(data_dir, sut_dir, tmp_path, input_mode):
    input_file_path = "%s/24.txt" % tmp_path
    with open("%s/24.txt" % data_dir, "r") as original_f:
        with open(input_file_path, "w") as modified_f:
            original_content = original_f.read()
            if input_mode == "original":
                modified_content = original_content
                answer = "99"
            else:
                assert input_mode == "modified"
                # in the example z is 0 in most cases and 1 in the special case
                # but the real program has to search for a z=0 so to make it
                # more intesting, add an instruction to the end that inverts
                # the result - the original program is happy with the first try
                modified_content = "%sadd z -1\n" % original_content
                answer = "39"
            modified_f.write(modified_content)

    assert (
        get_output(
            "-t",
            "%s/24/module.rkt" % sut_dir,
            "-m",
            input_file_path,
        )
        == answer
    )


def test_24_more(data_dir, sut_dir, tmp_path):
    input_file_path = input_file(
        tmp_path,
        "inp w",
        "add z w",
        "mod z 2",
        "div w 2",
        "add y w",
        "mod y 2",
        "div w 2",
        "add x w",
        "mod x 2",
        "div w 2",
        "mod w 2",
    )

    assert (
        get_output(
            "-t",
            "%s/24/module.rkt" % sut_dir,
            "-m",
            input_file_path,
        )
        == "8"
    )


def test_24_c(data_dir, sut_dir, tmp_path):
    c_file_path = "%s/24.c" % tmp_path
    exe_path = "%s/24" % tmp_path
    transpiler_path = "%s/24/transpile.py" % sut_dir
    source_path = "%s/24.txt" % data_dir

    with open(c_file_path, "w") as f:
        p = subprocess.Popen(
            [
                sys.executable,
                transpiler_path,
                source_path,
            ],
            stdout=f,
        )
        p.communicate()
        assert not p.returncode

    p = subprocess.Popen(
        [
            "gcc",
            c_file_path,
            "-o",
            exe_path,
        ],
    )
    p.communicate()
    assert not p.returncode

    # the result of this program is in the exit code not stdout
    p = subprocess.Popen(
        [exe_path, "39"],
    )
    p.communicate()
    assert p.returncode == 1

    p = subprocess.Popen(
        [exe_path, "38"],
    )
    p.communicate()
    assert p.returncode == 0


def test_24_c2(data_dir, sut_dir, tmp_path):
    # this example program converts a number to binary but because the
    # "transpiler" produces a program that only returns z, I can only check the
    # last digit
    c_file_path = "%s/24.c" % tmp_path
    exe_path = "%s/24" % tmp_path
    transpiler_path = "%s/24/transpile.py" % sut_dir
    source_path = input_file(
        tmp_path,
        "inp w",
        "add z w",
        "mod z 2",
        "div w 2",
        "add y w",
        "mod y 2",
        "div w 2",
        "add x w",
        "mod x 2",
        "div w 2",
        "mod w 2",
    )

    with open(c_file_path, "w") as f:
        p = subprocess.Popen(
            [
                sys.executable,
                transpiler_path,
                source_path,
            ],
            stdout=f,
        )
        p.communicate()
        assert not p.returncode

    p = subprocess.Popen(
        [
            "gcc",
            c_file_path,
            "-o",
            exe_path,
        ],
    )
    p.communicate()
    assert not p.returncode

    # the result of this program is in the exit code not stdout
    p = subprocess.Popen(
        [exe_path, "8"],
    )
    p.communicate()
    assert p.returncode == 0

    p = subprocess.Popen(
        [exe_path, "9"],
    )
    p.communicate()
    assert p.returncode == 1

    p = subprocess.Popen(
        [exe_path, "0"],
    )
    p.communicate()
    assert p.returncode == 0

    p = subprocess.Popen(
        [exe_path, "1"],
    )
    p.communicate()
    assert p.returncode == 1


def test_25(data_dir, sut_dir):
    input_file_path = "%s/25.txt" % data_dir
    output = get_output(
        "-t",
        "%s/25/module.rkt" % sut_dir,
        "-m",
        input_file_path,
    )

    assert output == "58"
