# Bart Extract GA

[![PyPI version](https://badge.fury.io/py/bart-extract-ga.svg)](https://badge.fury.io/py/bart-extract-ga)

Extract event views to Google Analytics

## Install
```
$ pip install bart-extract-ga
```

## Modules

* `extract.processor.extract_yesterday`: exports data from D-1
* `extract.processor.extract_by_date_ranger`: exports data from date specified in the parameters, `start_date` and `end_date`


## Usage

```python
from extract.processor import extract_yesterday

extract_yesterday(
    ga_viewId="ga:123456789",
    ga_credential="/tmp/credentials/GA_credentials.json",
    s3_path="s3://prd-lake-raw-bart",
)

```

## Obs

* **s3_path**: the path can be a local path or a path to an AWS S3 bucket