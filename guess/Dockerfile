FROM python:3.10-slim

WORKDIR /app

COPY . .

COPY ../repository ../repository
COPY ../requirements.txt .
COPY ../start-backend.sh .

RUN pip install --no-cache-dir -r requirements.txt
RUN chmod +x start-backend.sh

CMD ["./start-backend.sh"]
