#!/bin/bash
# setup.sh - Chỉ dành cho BOOTSTRAP (Mồi hạ tầng)

# 1. Khai báo chế độ an toàn
set -e
export DEBIAN_FRONTEND=noninteractive

# 2. Cài đặt các gói tối thiểu để hệ thống vận hành và Ansible kết nối
apt-get update -y
apt-get install -y curl unzip git netcat-openbsd software-properties-common

# 3. Tạo SWAP 2GB (Đảm bảo máy không bị treo khi Ansible chạy các tác vụ nặng)
if [ ! -f /swapfile ]; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

# 4. Cài đặt Tailscale và Join mạng
# Đây là bước duy nhất nên làm ở Terraform để Ansible có thể SSH qua IP Tailscale ngay lập tức
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --authkey=${TS_KEY} --hostname=${HOST_NAME} --ssh --accept-dns=true --advertise-tags=tag:webserver

# 5. Cấu hình SSH Deploy Key (Để Ansible có thể dùng quyền root để clone code thuận tiện)
mkdir -p /root/.ssh
echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
ssh-keyscan github.com >> /root/.ssh/known_hosts

echo "HẠ TẦNG CƠ BẢN ĐÃ SẴN SÀNG - ANSIBLE CÓ THỂ BẮT ĐẦU CẤU HÌNH PHP/NGINX/LARAVEL"