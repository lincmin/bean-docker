# 使用轻量级的 Python 基础镜像
FROM python:3.11-slim

# 设置环境变量，确保 Python 输出直接打印到日志，不进行缓冲
ENV PYTHONUNBUFFERED=1 \
    FAVA_HOST=0.0.0.0 \
    FAVA_PORT=5000

# 安装构建依赖（部分 Beancount 组件和插件可能需要编译）以及 git
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libxml2-dev \
    libxslt-dev \
    && rm -rf /var/lib/apt/lists/*

# 升级 pip 并安装核心组件及插件
# 注：fava-portfolio-returns 直接从 GitHub 仓库安装以获取最新支持
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
    beancount \
    fava \
    fava-dashboards \
    beangrow \
    git+https://github.com/andreasgerstmayr/fava-portfolio-returns.git

# 创建数据挂载目录
WORKDIR /data

# 暴露 Fava 默认端口
EXPOSE 5000

# 默认启动命令，运行 fava 并加载 /data/main.beancount 账本
CMD ["fava", "--host", "0.0.0.0", "/data/main.beancount"]
