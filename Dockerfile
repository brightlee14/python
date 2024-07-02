# Python 이미지를 베이스로 사용
FROM python:3.8-slim

# 작업 디렉토리 설정
WORKDIR /app

# 파이썬 스크립트를 컨테이너에 복사
COPY hello.py .

# 실행 명령 설정
CMD ["python", "hello.py"]
