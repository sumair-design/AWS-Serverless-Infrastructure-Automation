import importlib.util
from pathlib import Path


def load(name):
    path = Path(__file__).parents[1] / "lambda" / f"{name}.py"
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_start_handler_exists():
    assert callable(load("start_instances").lambda_handler)


def test_stop_handler_exists():
    assert callable(load("stop_instances").lambda_handler)
