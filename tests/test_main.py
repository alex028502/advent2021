import subprocess
import os

import pytest


@pytest.fixture
def sut_dir():
    test_dir = os.path.dirname(os.path.realpath(__file__))
    return os.path.dirname("%s/../" % test_dir)


def test_demo2020(tmp_path, sut_dir):
    sample = [1721, 979, 366, 299, 675, 1456]
    input_text = "\n".join(map(str, sample)) + "\n"
    input_file_path = "%s/input.txt" % tmp_path
    with open(input_file_path, "w") as f:
        f.write(input_text)

    process = subprocess.Popen(
        ["racket", "%s/demo2020/program.rkt" % sut_dir, input_file_path],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )

    output = process.communicate()[0].decode("utf-8").strip()
    assert output == "514579"
