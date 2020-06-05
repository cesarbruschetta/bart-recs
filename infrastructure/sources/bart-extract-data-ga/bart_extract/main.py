import os
import sys
import json
import argparse
import logging
from logging import config as l_config

from uuid import uuid4
from bart_extract.ga_reporting import GoogleAnalyticsReporting


# SET LOGGER

SUB_DICT_CONFIG = {"level": "DEBUG", "handlers": [], "propagate": False}
l_config.dictConfig(
    {
        "version": 1,
        "formatters": {
            "default": {
                "format": "%(asctime)s %(levelname)-5.5s [%(name)s] %(message)s",
                "datefmt": "%Y-%m-%d %H:%M:%S",
            }
        },
        "handlers": {
            "console": {
                "level": "DEBUG",
                "class": "logging.StreamHandler",
                "formatter": "default",
                "stream": "ext://sys.stdout",
            }
        },
        "loggers": {},
        "root": {"level": "DEBUG", "handlers": ["console"]},
    }
)

def run(sargs):
    parser = argparse.ArgumentParser()
    parser.add_argument("--loglevel", default="INFO")
    parser.add_argument(
        "--ga-viewId", required=True,
    )
    parser.add_argument(
        "--ga-credential", required=True,
    )
    parser.add_argument(
        "--s3-path", required=True,
    )

    ################################################################################################
    args, _ = parser.parse_known_args(sargs)

    # CHANGE LOGGER
    level = getattr(logging, args.loglevel.upper())
    logger = logging.getLogger()
    logger.setLevel(level)

    logger.info("Iniciando o processamento...")
    reporting = GoogleAnalyticsReporting(
        view_id=args.ga_viewId, credentials_json_dict=json.loads(args.ga_credential)
    )

    dataset = reporting.extract_data(d_ago="1")
    dataset.to_parquet(os.path.join(args.s3_path, "ga_pageviews", f"{uuid4()}.parquet"))

    logger.info(f"Processamento Finalizado, dataset gerado {len(dataset)} linhas")

    return 0