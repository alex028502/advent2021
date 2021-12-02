import subprocess
import os
import uuid

import pytest


@pytest.fixture
def sut_dir():
    test_dir = os.path.dirname(os.path.realpath(__file__))
    return os.path.dirname("%s/../" % test_dir)


def input_file(folder, *args):
    input_text = "\n".join(map(str, args)) + "\n"
    input_file_path = "%s/%s.txt" % (folder, uuid.uuid1())
    with open(input_file_path, "w") as f:
        f.write(input_text)
    return input_file_path


def get_output(program, input_file_path):
    process = subprocess.Popen(
        ["racket", program, input_file_path],
        stdout=subprocess.PIPE,
    )

    return process.communicate()[0].decode("utf-8").strip()


def test_demo2020(tmp_path, sut_dir):
    input_file_path = input_file(tmp_path, 1721, 979, 366, 299, 675, 1456)

    output = get_output("%s/demo2020/program.rkt" % sut_dir, input_file_path)
    assert output == "514579"


def test_1(tmp_path, sut_dir):
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

    output = get_output("%s/1/program.rkt" % sut_dir, input_file_path)
    assert output == "7"

def test_2(tmp_path, sut_dir):
    input_file_path = input_file(
        tmp_path,
        "forward 5",
        "down 5",
        "forward 8",
        "up 3",
        "down 8",
        "forward 2",
    )

    output = get_output("%s/2/program.rkt" % sut_dir, input_file_path)
    assert output == "150"
