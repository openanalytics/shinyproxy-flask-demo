FROM ubuntu:20.04

ENV TZ=Europe
ENV PYTHONUNBUFFERED "1"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y python3-pip && \
    pip3 install flask gunicorn && \
    rm -rf /var/lib/apt/lists/*

COPY app /opt/app

EXPOSE 8080

WORKDIR /opt/app

CMD ["gunicorn", "main:app", "--bind", "0.0.0.0:8080"]