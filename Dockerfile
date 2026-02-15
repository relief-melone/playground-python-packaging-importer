ARG SSH_PRIVATE_KEY

FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim


RUN apt-get update -y && apt-get install -y --no-install-recommends \
    git \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /app

COPY . /app

RUN --mount=type=ssh \
    mkdir -p -m 0700 ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts && \
    ssh -T -o StrictHostKeyChecking=no git@github.com || true && \
    uv sync --frozen

ENV PATH=/app/.venv/bin/:/app/:$PATH

CMD [ "python3", "main.py" ]
