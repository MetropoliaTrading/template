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
        # FastAPI normalizes multiple slashes to single
        assert response.status_code == 200
        assert response.json() == {"message": "Hello, World!"}

    @pytest.mark.parametrize("method", ["post", "put", "delete", "patch", "options"])
    def test_other_methods_not_allowed(self, method):
        func = getattr(self.client, method)
        response = func("/")
        assert response.status_code == 405

    def test_response_structure_keys(self):
        response = self.client.get("/")
        body = response.json()
        assert set(body.keys()) == {"message"}
        assert isinstance(body["message"], str)
        assert "Hello" in body["message"]
