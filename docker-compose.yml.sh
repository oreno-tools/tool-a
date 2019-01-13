cat << YAML
version: '3'
services:
  tool-a:
    image: $(aws sts get-caller-identity --query=Account --output=text).dkr.ecr.ap-northeast-1.amazonaws.com/oreno-docker-image/tool-a:latest
    container_name: tool-a
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - .:/work
      - ${HOME}/.aws:/root/.aws
    working_dir: /work
    entrypoint: /usr/local/bin/tool-a
YAML
