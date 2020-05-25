from random import randint
from simulator.tools import tools_parser


def lambda_handler(event, context):

    interactions = randint(100, 1000)
    tools_parser(
        [
            "send-data-ga",
            "pageview",
            "-c",
            "https://github.com/cesarbruschetta/bart-recs/datasets/customers.csv",
            "-p",
            "https://github.com/cesarbruschetta/bart-recs/datasets/products.csv",
            "-i",
            interactions,
        ]
    )
    return True
