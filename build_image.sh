docker build \
  --build-arg UID=$(cat /etc/passwd | grep "clang-jenkins" | cut -d":" -f3) \
  --build-arg GID=$(cat /etc/passwd | grep "clang-jenkins" | cut -d":" -f4) \
  --tag jenkins/clang \
  docker_image 
