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

USER jenkins
