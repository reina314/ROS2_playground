# ROS2_PLAYGROUND
ワークショップ等の用途に向けて、ROS2の実行環境を手軽に作成できるDockerイメージです。

## 実行方法
1. レポジトリをクローンします。
```bash
git clone https://github.com/reina314/ROS2_playground.git
```
2. Dockerコンテナを起動します。初回起動時は、イメージのビルドのために時間がかかります。
```bash
cd ROS2_playground
docker-compose up -d
```
3. コンテナにSSH接続します。デフォルトのポート番号は`2222`です。クレデンシャルは、管理者アカウントが`admin:admin`、一般ユーザーが`user1:user1`, `user2:user2`, ...となります。
```bash
ssh admin@<IP Address> -p 2222
```