# ROS2_PLAYGROUND
ワークショップ等の用途に向けて、ROS2の実行環境を手軽に作成できるDockerイメージです。

## 実行方法
1. レポジトリをクローンします。
```bash
git clone https://github.com/reina314/ROS2_playground.git
```
2. `docker-compose.yml`を開き、作成するユーザ数を指定します。
```yaml
build:
      context: .
      args:
        NUM_USERS: 4
```
上の`NUM_USERS`は、ビルド時の引数を指定します。
```yaml
environment:
      - NUM_USERS=4
```
一方、上の`NUM_USERS`は、コンテナ作成時の環境変数を指定します。

3. Dockerコンテナを起動します。初回起動時は、イメージのビルドのために時間がかかります。
```bash
cd ROS2_playground
docker-compose up -d
```
4. コンテナにSSH接続します。デフォルトのポート番号は`2222`です。クレデンシャルは、管理者アカウントが`admin:admin`、一般ユーザが`user1:user1`, `user2:user2`, ...となります。
```bash
ssh admin@<IP Address> -p 2222
```