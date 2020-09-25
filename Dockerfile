FROM python:3.8-alpine

COPY ./requirements.txt /

RUN mkdir /code \
    && apk add --update --virtual .build_deps g++ gcc python3-dev openssl openssl-dev \
    && apk add git libxml2 libxml2-dev libxslt libxslt-dev ansible libffi libffi-dev \
    && pip install -r requirements.txt \
    && apk del .build_deps

WORKDIR /code

COPY panw-gse.skillets/* /code/