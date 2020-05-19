from os import path
import pandas as pd

from ganalytics import SendData

base_path = path.dirname(__file__)


def main():

    df_customers = pd.read_csv(path.join(base_path, "data/customers.csv"))
    df_products = pd.read_csv(path.join(base_path, "data/products.csv"))

    ga = SendData("ecommerce-raw-bart.s3.us-east-1.amazonaws.com", "UA-166855025-1",)

    df_sample_products = df_products.sample(frac=0.7).reset_index(drop=True)

    for index, row in df_sample_products.iterrows():
        print(f'Send Product {row["sku"]}')

        r = ga.ga_send_pageview(
            f'/products/{row["sku"]}.html',
            f'Bart Recomendation | Produto - {row["title"]}',
            df_customers.sample().iloc[0]["uuid"],
        )
        print(r.status_code)


if __name__ == "__main__":
    main()
