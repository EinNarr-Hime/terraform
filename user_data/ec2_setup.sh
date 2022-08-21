#!/bin/bash
yum update -y

### sshのポート番号を変更
sed -i -e 's!#Port 22!Port 60022!' /etc/ssh/sshd_config
systemctl restart sshd.service

# ----- dockerのセットアップ -----
amazon-linux-extras install -y docker
# ec2-userでdockerが利用できるように権限付与
gpasswd -a ec2-user docker
# docker サービス起動
service docker start
# 再起動後も自動でサービスが開始
systemctl enable docker
# ------------------------------

# ----- docker-composeのセットアップ -----
mkdir -p /usr/local/lib/docker/cli-plugins
# docker-composeのダウンロード
curl \
  -L https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-$(uname -s)-$(uname -m) \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
# 実行権限付与
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
# /usr/bin/に/usr/local/lib/docker/cli-plugins/docker-composeへのシンボリックリンクを設定
ln -s /usr/local/lib/docker/cli-plugins/docker-compose /usr/bin/docker-compose
# ------------------------------