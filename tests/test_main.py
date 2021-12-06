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
        "%s/demo2020/%s.rkt" % (sut_dir, implementation),
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
        "%s/1/%s.rkt" % (sut_dir, implementation),
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

    output = get_output("%s/2/%s.rkt" % (sut_dir, version), input_file_path)
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

    output = get_output("%s/3/program.rkt" % sut_dir, input_file_path)
    assert output == "198\n230"  # part i and part ii


def test_4(data_dir, sut_dir):
    # stop generating the file - the sample data are getting harder to turn
    # into a python list before turning back into a text file
    # easier to skip the middle man now
    # and that means we can load the test input in the repl
    input_file_path = "%s/4.txt" % data_dir

    output = get_output("%s/4/program.rkt" % sut_dir, input_file_path)
    assert output == "(4512 1924)"  # part i and part ii together


def test_4_flipped(data_dir, sut_dir, tmp_path):
    # since their example only deals with rows, I need to flip the whole
    # problem in python to make sure that it'll work for matching columns
    # and to do that I have to recreate all the array loading logic here
    original_input_file_path = "%s/4.txt" % data_dir
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

    output = get_output("%s/4/program.rkt" % sut_dir, input_file_path)
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
    input_file_path = "%s/5.txt" % data_dir

    output = get_output("%s/5/program.rkt" % sut_dir, input_file_path)
    assert output == "12"


@pytest.mark.parametrize("how", [["racket", "rkt"], [sys.executable, "py"]])
@pytest.mark.parametrize("what", [[18, 26], [80, 5934], [256, 26984457539]])
def test_6(tmp_path, sut_dir, how, what):
    interpreter, ext = how
    n, answer = what
    input_file_path = input_file(tmp_path, "3,4,3,1,2")

    output = get_output_from(
        interpreter,
        "%s/6/program.%s" % (sut_dir, ext),
        str(n),
        input_file_path,
    )
    assert output == str(answer)
