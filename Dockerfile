# Dockerfile for viXTTS Demo
FROM python:3.10-slim

# Install system dependencies, including python3.10-dev and python3.10-venv
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    pkg-config \
    libssl-dev \
    git \
    python3.10-dev \
    python3.10-venv \
    && rm -rf /var/lib/apt/lists/*

# Install Rust toolchain (required for some dependencies)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Set working directory
WORKDIR /app

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Copy and install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy entire source code
COPY . .

# Debug: List files in /app
RUN ls -la /app

# Expose port (based on reverse proxy configuration)
EXPOSE 5001

# Health check for Gradio application
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:5001/ || exit 1

# Make run.sh executable
RUN chmod +x run.sh

# Run the application via run.sh
CMD ["./run.sh"]
