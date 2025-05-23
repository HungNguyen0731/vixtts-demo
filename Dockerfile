# Dockerfile đơn giản cho ứng dụng Gradio (viXTTS Demo)
FROM python:3.11-slim

# Cài đặt system dependencies cần thiết
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    pkg-config \
    libssl-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt Rust toolchain
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Thiết lập working directory
WORKDIR /app

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Copy requirements và cài đặt dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy toàn bộ source code
COPY . .

# Debug: List files in /app
RUN ls -la /app

# Expose port (dựa trên reverse proxy configuration)
EXPOSE 5001

# Health check để kiểm tra ứng dụng Gradio
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:5001/ || exit 1

# Make run.sh executable
RUN chmod +x run.sh

# Chạy ứng dụng Gradio thông qua run.sh
CMD ["./run.sh"]
