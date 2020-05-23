import pandas as pd
from simulator.send_data_ga.client import SendData


def pageview(df_customers: pd.DataFrame, df_products: pd.DataFrame) -> None:

    ga = SendData(
        "ecommerce-raw-bart.s3-website-us-east-1.amazonaws.com", "UA-166855025-1"
    )

    df_sample_products = df_products.sample(frac=0.7).reset_index(drop=True)

    for index, row in df_sample_products.iterrows():
        print(f'Send Product {row["sku"]}')

        r = ga.ga_send_pageview(
            f'/products/{row["sku"]}.html',
            f'Bart Recomendation | {row["title"]}',
            row["sku"],
            df_customers.sample().iloc[0]["uuid"],
        )
        print(r.status_code)
