FROM python:3.11-slim-bullseye AS base

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=appuser
ENV APPUSER=$USER LANG=C.UTF-8 LC_ALL=C.UTF-8 PYTHONUNBUFFERED=1 PYTHONDONTWRITEBYTECODE=1 WORKDIR=/app
WORKDIR $WORKDIR
RUN useradd --skel /dev/null --create-home $APPUSER
RUN chown $APPUSER:$APPUSER $WORKDIR
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        binutils \
        build-essential \
        git \
        gdal-bin \
        libgdal-dev \
        libpq-dev \
	    libpq5 \
        postgresql-client-13 \
        ssh
USER $APPUSER
COPY --chown=$APPUSER . .
WORKDIR django
RUN python3 -m pip install --user --no-cache-dir -e .
RUN python3 -m pip install --user --no-cache-dir -r tests/requirements/py3.txt
RUN python3 -m pip install --user --no-cache-dir psycopg2
WORKDIR /
CMD sleep infinity
