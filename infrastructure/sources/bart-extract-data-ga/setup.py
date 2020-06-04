from setuptools import setup, find_packages

setup(
    name="bart_extract",
    version="0.1",
    packages=find_packages(
        exclude=["*.tests", "*.tests.*", "tests.*", "tests"]
    )
) 