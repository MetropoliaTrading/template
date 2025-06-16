# tests/features/steps.py

import json
import re
from pytest_bdd import scenarios, when, then, parsers
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

# Point to both feature files
scenarios("../unit/../features/hello.feature",   # adjust if needed
          "../unit/../features/health.feature")


@when(parsers.re(r'I send a GET request to "(?P<path>.+)"'))
def send_get(path):
    return client.get(path)


@then(parsers.re(r'the response status code should be (?P<code>\d+)'))
def check_status(send_get, code):
    assert send_get.status_code == int(code)


@then("the response JSON should be:")
def check_json_exact(send_get, doc_string):
    expected = json.loads(doc_string)
    assert send_get.json() == expected


@then(parsers.re(r'the response JSON should contain keys "(?P<keys>.+)"'))
def json_contains_keys(send_get, keys):
    expected_keys = set(k.strip() for k in keys.split("and"))
    assert expected_keys.issubset(send_get.json().keys())


@then(parsers.re(r'the "(?P<field>.+)" field should equal "(?P<value>.+)"'))
def check_field_value(send_get, field, value):
    assert send_get.json()[field] == value


@then("the \"timestamp\" field should be an ISO8601 UTC string ending with \"Z\"")
def check_timestamp_format(send_get):
    ts = send_get.json().get("timestamp", "")
    # very loose ISO check
    assert re.match(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z$", ts)
