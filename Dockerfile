FROM jenkins/jenkins:lts

USER root

# Docker CLI 설치에 필요한 패키지 설치
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    python3-pip \
    python3-venv  # python3-venv 패키지 추가

# Docker의 공식 GPG 키 추가
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

# Docker 저장소 추가
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# Docker CLI 설치
RUN apt-get update && apt-get install -y docker-ce-cli

# Jenkins 사용자를 Docker 그룹에 추가
RUN groupadd docker && usermod -aG docker jenkins

# kubectl 설치
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# 작업 디렉토리 설정
WORKDIR /app

# requirements.txt 복사
COPY requirements.txt /app/requirements.txt

# 가상 환경 생성 및 패키지 설치
RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

# Flask 애플리케이션 코드 복사
COPY app.py /app/app.py

# 포트 설정
EXPOSE 5000

# Flask 애플리케이션 실행
CMD ["bash", "-c", "source venv/bin/activate && python3 app.py"]

USER jenkins
