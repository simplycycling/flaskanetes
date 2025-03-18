.PHONY: test build run clean

test:
	. venv/bin/activate && pytest app/tests/

build:
	docker build -t flaskanetes:latest app/

run:
	docker run -p 5001:5000 flaskanetes:latest

clean:
	find . -type d -name "__pycache__" -exec rm -r {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.pyd" -delete
	find . -type f -name ".coverage" -delete
	find . -type d -name "*.egg-info" -exec rm -r {} +
	find . -type d -name "*.egg" -exec rm -r {} +
	find . -type d -name ".pytest_cache" -exec rm -r {} + 