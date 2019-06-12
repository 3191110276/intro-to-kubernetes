FROM alpine:3.9

RUN apk add --no-cache python3

RUN pip3 install --upgrade pip

COPY /app/requirements.txt ./requirements.txt
RUN pip3 install -r requirements.txt

COPY /app/ ./

EXPOSE 5000

CMD ["python3", "app.py"]

