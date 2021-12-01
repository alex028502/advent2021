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


def test_demo2020(tmp_path, sut_dir):
    input_file_path = input_file(tmp_path, 1721, 979, 366, 299, 675, 1456)

    process = subprocess.Popen(
        ["racket", "%s/demo2020/program.rkt" % sut_dir, input_file_path],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )

    output = process.communicate()[0].decode("utf-8").strip()
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

    process = subprocess.Popen(
        ["racket", "%s/1/program.rkt" % sut_dir, input_file_path],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )

    output = process.communicate()[0].decode("utf-8").strip()
    assert output == "7"
