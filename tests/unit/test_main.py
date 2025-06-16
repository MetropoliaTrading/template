# tests/unit/test_main.py

import pytest
from fastapi.testclient import TestClient
from app.main import app

class TestReadRoot:
    @classmethod
    def setup_class(cls):
        cls.client = TestClient(app)

    def test_read_root_success(self):
        response = self.client.get("/")
        assert response.status_code == 200
        assert response.headers["content-type"].startswith("application/json")
        assert response.json() == {"message": "Hello, World!"}

    def test_read_root_trailing_slash_equivalent(self):
        response = self.client.get("//")
        assert response.status_code == 200
        assert response.json() == {"message": "Hello, World!"}

    @pytest.mark.parametrize("method", ["post", "put", "delete", "patch", "options"])
    def test_other_methods_not_allowed(self, method):
        func = getattr(self.client, method)
        response = func("/")
        assert response.status_code == 405

    def test_response_structure_keys(self):
        body = self.client.get("/").json()
        assert set(body.keys()) == {"message"}
        assert isinstance(body["message"], str)
        assert "Hello" in body["message"]


class TestHealthCheck:
    @classmethod
    def setup_class(cls):
        cls.client = TestClient(app)

    def test_health_status_code_and_keys(self):
        response = self.client.get("/health")
        assert response.status_code == 200
        body = response.json()
        # Must have exactly 'status' and 'timestamp'
        assert set(body.keys()) == {"status", "timestamp"}
        assert body["status"] == "ok"

    def test_timestamp_format(self):
        response = self.client.get("/health")
        ts = response.json()["timestamp"]
        # Very basic ISO8601 check: ends with 'Z' and contains 'T'
        assert ts.endswith("Z")
        assert "T" in ts

    @pytest.mark.parametrize("method", ["post", "put", "delete", "patch", "options"])
    def test_health_other_methods_not_allowed(self, method):
        func = getattr(self.client, method)
        resp = func("/health")
        assert resp.status_code == 405
