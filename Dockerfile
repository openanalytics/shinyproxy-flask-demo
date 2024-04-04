FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app/ /app

EXPOSE 8080

CMD ["gunicorn", "main:app", "--bind", "0.0.0.0:8080"]
