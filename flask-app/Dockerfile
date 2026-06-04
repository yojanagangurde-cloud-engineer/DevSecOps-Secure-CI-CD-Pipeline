FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN useradd -m appuser
USER appuser
EXPOSE 5001
CMD ["gunicorn", "--bind", "0.0.0.0:5001", "app:app", "--workers", "3"]