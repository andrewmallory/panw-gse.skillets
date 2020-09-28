FROM python:3.8-alpine as builder

COPY ./requirements.txt /

ENV PATH="/opt/venv/bin:$PATH"

RUN mkdir /code \
    && mkdir /opt/venv \
    && python -m venv /opt/venv \
    && apk add --update --virtual .build_deps g++ gcc python3-dev openssl openssl-dev \
    && apk add libxml2 libxml2-dev libxslt libxslt-dev ansible libffi libffi-dev \
    && pip install -r requirements.txt \
    && apk del .build_deps \
    && rm -rf /opt/venv/lib/python3.8/site-packages/ansible_collections

WORKDIR /code

COPY panw-gse.skillets/* /code/

FROM python:3.8-alpine
COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /usr/lib/libxslt.so.1 /usr/lib/libxslt.so.1
COPY --from=builder /usr/lib/libexslt.so.0 /usr/lib/libexslt.so.0
COPY --from=builder /usr/lib/libxml2.so.2 /usr/lib/libxml2.so.2
COPY --from=builder /usr/lib/libgcrypt.so.20 /usr/lib/libgcrypt.so.20
COPY --from=builder /usr/lib/libgpg-error.so.0 /usr/lib/libgpg-error.so.0

ENV PATH="/opt/venv/bin:$PATH"

RUN apk add git

CMD 'ansible'