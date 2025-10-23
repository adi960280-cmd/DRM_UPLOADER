# Use Debian-based Python slim image
FROM python:3.11-slim-bullseye

# Set working directory
WORKDIR /app

# Copy all files from current directory
COPY . .

# Install system dependencies (Debian/Ubuntu)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    libffi-dev \
    libc6-dev \
    ffmpeg \
    aria2 \
    make \
    cmake \
    unzip \
    wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install Bento4
RUN wget -q https://github.com/axiomatic-systems/Bento4/archive/v1.6.0-639.zip && \
    unzip v1.6.0-639.zip && \
    cd Bento4-1.6.0-639 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    cp mp4decrypt /usr/local/bin/ && \
    cd ../.. && \
    rm -rf Bento4-1.6.0-639 v1.6.0-639.zip

# Upgrade pip and install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Expose port if using Gunicorn
EXPOSE 8000

# Set the command to run your application
CMD ["sh", "-c", "gunicorn app:app & python3 main.py"]
