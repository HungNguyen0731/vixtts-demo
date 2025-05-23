# Dockerfile đơn giản cho ứng dụng Gradio
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

# Expose port cho Gradio (mặc định là 7860)
EXPOSE 7860

# Health check để kiểm tra ứng dụng Gradio
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:7860/ || exit 1

# Chạy ứng dụng Gradio
# Thay đổi 'app.py' thành tên file chính của bạn
CMD ["python", "main.py"]
# Nếu bạn muốn chạy trên port 8000 và cho phép external access:
# CMD ["python", "-c", "import app; app.demo.launch(server_name='0.0.0.0', server_port=8000)"]
