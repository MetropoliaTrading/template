# tests/features/test_steps.py
"""Shared step definitions for all BDD feature files."""

import json
import re
from pathlib import Path

from fastapi.testclient import TestClient
from pytest_bdd import scenarios, when, then, parsers

from app.main import app

client = TestClient(app)

# --- Dynamically load each .feature file in this directory ------------------
feature_dir = Path(__file__).parent
for feature_path in feature_dir.glob("*.feature"):
    scenarios(str(feature_path))

# -----------------------------------------------------------------------------
# Generic step implementations
# -----------------------------------------------------------------------------

@when(parsers.parse('I send a GET request to "{path}"'))
def send_get(path):
    """Send an HTTP GET to the given path and return the response."""
    return client.get(path)


@then(parsers.parse("the response status code should be {code:d}"))
def check_status(send_get, code):
    assert send_get.status_code == code


@then("the response JSON should be:")
def check_exact_json(send_get, doc_string):
    assert send_get.json() == json.loads(doc_string)


@then(parsers.re(r'the response JSON should contain keys "(?P<keys>.+)"'))
def check_json_keys(send_get, keys):
    expected = {k.strip() for k in re.split(r",|and", keys)}
    assert expected.issubset(send_get.json().keys())


@then(parsers.parse('the "{field}" field should equal "{value}"'))
def check_field_value(send_get, field, value):
    assert send_get.json()[field] == value


@then('the "timestamp" field should be an ISO8601 UTC string ending with "Z"')
def check_timestamp_format(send_get):
    ts = send_get.json().get("timestamp", "")
    iso_regex = r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z$"
    assert re.fullmatch(iso_regex, ts)
