"""  """
import logging
import pkg_resources
import argparse
from os import path

from generate import datasets


base_path = path.dirname(path.dirname(__file__))


def tools_parser(sargs):
    parser = argparse.ArgumentParser(
        description="Simulator data set to recomendation cli (bart-recs)"
    )
    parser.add_argument("--loglevel", default="INFO")

    # packtools_version = pkg_resources.get_distribution("simulator").version
    # parser.add_argument("--version", action="version", version=packtools_version)

    subparsers = parser.add_subparsers(title="Commands", metavar="", dest="command")

    # GENERATION Datasets
    parents_customers = argparse.ArgumentParser(add_help=False)
    parents_customers.add_argument(
        "--desc-path",
        "-d",
        default=path.join(base_path, "datasets"),
        help="Pasta onde sera salvo os dataset gerados",
    )
    parents_customers.add_argument(
        "--rows", "-r", default=1000, help="Quantidades de Linhas geradas", type=int,
    )
    parents_customers.add_argument(
        "--format",
        "-f",
        default="csv",
        choices=["csv", "json"],
        nargs="+",
        help="Formato do arquivo de saida que sera salvo",
        required=True,
    )
    parents_customers.add_argument(
        "script",
        choices=["customers", "products"],
        help="Arquivo que sera gerado pelo processo",
    )

    subparsers.add_parser(
        "generation", help="", parents=[parents_customers,],
    )

    # Send Ping GA

    ################################################################################################
    args = parser.parse_args(sargs)

    # CHANGE LOGGER
    level = getattr(logging, args.loglevel.upper())
    logger = logging.getLogger()
    logger.setLevel(level)

    if args.command == "generation":

        func = getattr(datasets, args.script)
        dataset = func(args.rows)

        if args.format == "csv":
            dataset.to_csv(path.join(args.desc_path, f"{args.script}.csv"))
        if args.format == "json":
            dataset.to_json(
                path.join(args.desc_path, f"{args.script}.csv"),
                orient="records",
                indent=4,
            )

    else:
        raise SystemExit(
            "Vc deve escolher algum parametro, ou '--help' ou '-h' para ajuda"
        )

    return 0
