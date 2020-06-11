""" module to methods to main  """
import pandas as pd
import logging


logger = logging.getLogger(__name__)


def run():
    logger.info("Iniciando o processamento...")
    
    dataset = pd.read_parquet("s3://prd-lake-raw-bart/ga_pageviews")
    dataset.drop_duplicates(
        subset=["product_id", "customer_id","timestamp"], 
        keep=False,
        inplace=True,
    )
    dataset.sort(columns=["timestamp"], inplace =True)
    dataset.to_parquet("s3://prd-lake-raw-bart/interactions.parquet")
    
    logger.info(f"Processamento Finalizado, dataset gerado {len(dataset)} linhas")
    return 0


if __name__ == "__main__":
    run()
