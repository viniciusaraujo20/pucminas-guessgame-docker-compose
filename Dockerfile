FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV FLASK_APP=run.py
ENV FLASK_ENV=production

EXPOSE 5000

CMD ["sh", "start-backend.sh"]
