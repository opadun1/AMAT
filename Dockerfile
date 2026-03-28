FROM ghcr.io/astral-sh/uv:0.11.2 AS uv-stage
FROM python:3.14-alpine

# Install uv
COPY --from=uv-stage /uv /uvx /bin/

WORKDIR /AMAT

# Copy files needed for uv
COPY pyproject.toml uv.lock ./

# Install dependencies using uv
RUN uv sync --frozen --no-install-project

# Set path variable to use the virtual environment
ENV PATH="/AMAT/.venv/bin:$PATH"

# Copy the rest of the application code
COPY . .

# Run tests using pytest
CMD ["sh", "-c", "pytest -m ${MARKER:-'not slow'} -n ${NUM_CORES:-auto}"]
