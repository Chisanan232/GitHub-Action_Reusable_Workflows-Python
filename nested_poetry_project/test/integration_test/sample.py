import nested_python_src.sample
import logging
import pytest


@pytest.fixture(scope="function")
def get_hello_python() -> str:
    return nested_python_src.sample.hello_python()


def test_sample(get_hello_python: str) -> None:
    logging.info("Start Integration test.")
    assert get_hello_python == "Hello Python", "The return value should be 'Hello Python'."
    logging.info("This is Integration test done.")

