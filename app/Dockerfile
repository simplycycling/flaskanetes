# Build stage
FROM python:3.11-slim as builder

WORKDIR /app
COPY requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt

# Final stage
FROM python:3.11-slim

WORKDIR /app
COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/requirements.txt .
COPY src/ ./src/

RUN pip install --no-cache /wheels/*

ENV FLASK_APP=src/main.py
ENV FLASK_ENV=production
ENV WORKERS=4
ENV TIMEOUT=120

EXPOSE 5000

# Add health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Run with multiple workers, timeout, and access logging
CMD ["sh", "-c", "gunicorn --workers=${WORKERS} --timeout=${TIMEOUT} --bind=0.0.0.0:5000 --access-logfile=- --error-logfile=- src.main:app"] 