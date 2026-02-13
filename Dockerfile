FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

RUN apt-get update -y && \
    apt-get install -y git

COPY . /app
RUN uv sync

ENV PATH=/app/.venv/bin/:/app/:$PATH

CMD [ "python3", "main.py" ]
