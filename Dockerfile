FROM python:3.12-slim

WORKDIR /app

COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

# Create a non-root user
RUN useradd --create-home --uid 10001 appuser \
    && chown -R appuser:appuser /app

# Run the application as a non-root user
USER 10001

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "main:app"]
