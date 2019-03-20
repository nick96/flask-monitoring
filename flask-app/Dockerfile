FROM python:3.7

WORKDIR /app

COPY ./requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

COPY ./app.py /app/app.py

EXPOSE 5000

ENTRYPOINT ["flask", "run", "--host", "0.0.0.0"]
