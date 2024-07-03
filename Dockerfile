FROM jenkins/jenkins:lts

USER root

# Docker CLI 설치에 필요한 패키지 설치
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

# Docker의 공식 GPG 키 추가
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

# Docker 저장소 추가
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# Docker CLI 설치
RUN apt-get update && apt-get install -y docker-ce-cli

# Jenkins 사용자를 Docker 그룹에 추가
RUN groupadd docker && usermod -aG docker jenkins

# 필요한 Python 패키지 설치
RUN apt-get install -y python3-pip

# 작업 디렉토리 설정
WORKDIR /app

# requirements.txt 복사 및 설치
COPY requirements.txt /app/requirements.txt
RUN pip3 install -r requirements.txt

# Flask 애플리케이션 코드 복사
COPY hello.py /app/hello.py

# 포트 설정
EXPOSE 5000

# Flask 애플리케이션 실행
CMD ["python3", "hello.py"]

USER jenkins
