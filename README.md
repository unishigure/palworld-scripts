# Palworld Scripts

- サービス化\
  ゲームサーバが停止しても、自動で再起動するようサービスで起動する
- ゲームサーバの定期自動停止\
  毎日1,5,9,13,17,21時の4時間毎に、REST API からゲームサーバの停止をするスクリプト\
  サービス化しておくことで、停止後に自動で再起動される

## 前提

- Ubuntu 環境
- バージョン`0.2.0.6`以降（REST API利用）
- `steam` ユーザでホームディレクトリに `SteamCMD` をインストールしている\
  [SteamCMD - Valve Developer Community](https://developer.valvesoftware.com/wiki/SteamCMD#Ubuntu)
- インストールディレクトリを変更せずに Palworld Dedicated Server をインストールしている\
  [Palworld tech guide - Dedicated server guide](https://tech.palworldgame.com/dedicated-server-guide#linux)

ゲームサーバ設定ファイル：\
`/home/steam/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini`

デフォルトゲームサーバ設定ファイル：\
`/home/steam/Steam/steamapps/common/PalServer/DefaultPalWorldSettings.ini`

## Usage

### Service 化

`/etc/systemd/system` 以下に `palworld-dedicated.service` を配置

デーモンの再起動

```bash
sudo systemctl daemon-reload
```

サービスの有効化

```bash
sudo systemctl enable palworld-dedicated.service
```

サービスの起動

```bash
sudo systemctl start palworld-dedicated.service
```

サービスの状態確認

```bash
sudo systemctl status palworld-dedicated
```

（サービスの停止）

```bash
sudo systemctl stop palworld-dedicated
```

---

### Scheduled Restart

#### ゲームサーバの設定

ゲームサーバ設定ファイル `PalWorldSettings.ini` を編集する\
なければ `DefaultPalWorldSettings.ini` をコピー、リネームして `PalWorldSettings.ini` とする

※ 改行などを入れてはいけないらしいので注意

`ServerPassword` に、任意の管理者用パスワードを設定する

```ini
ServerPassword="{YourPassword}"
```

`RESTAPIEnabled` を有効にする

```ini
RESTAPIEnabled=True
```

#### 環境変数の設定

ゲームサーバ設定ファイル `PalWorldSettings.ini` の\
`AdminPassword` に設定したパスワードを、環境変数 `PAL_ADMIN_PASS` として、`.bash_profile` に設定する

```bash
echo export PAL_ADMIN_PASS={AdminPassword} >> /home/steam/.bash_profile
```

#### cron の設定

`steam` ユーザで `/home/steam/PalScripts` と `/home/steam/PalScripts/log` ディレクトリを作成

```bash
sudo su - steam
mkdir /home/steam/PalScripts /home/steam/PalScripts/log
```

`/home/steam/PalScripts` 以下に `scheduled_palserver_restart.sh` を配置\
以下コマンドで、所有者と権限を設定する

```bash
sudo chown steam:steam /home/steam/PalScripts/scheduled_palserver_restart.sh
sudo chmod 744 /home/steam/PalScripts/scheduled_palserver_restart.sh
```

`/etc/cron.d` 以下に `pal_restart_cron` を配置\
以下コマンドで、所有者と権限を設定する

```bash
sudo chown root:root /etc/cron.d/pal_restart_cron
sudo chmod 644 /etc/cron.d/pal_restart_cron
```

cron の再起動

```bash
sudo service cron restart
```

cron の状態確認

```bash
sudo service cron status
```

```bash
sudo tail -f /var/log/syslog | grep CRON
```

## Ref

- [Palworld tech guide - Dedicated server guide](https://tech.palworldgame.com/dedicated-server-guide)
- [最大32人 パルワールド Linux 専用サーバの建て方 (AlmaLinux) #Linux - Qiita](https://qiita.com/naoya-i/items/e907a6b949e5da36d532)
- [/etc/cron.dへ置くファイルにはownerとpermissionに制約があるっぽい - モヒカンメモ](https://blog.pinkumohikan.com/entry/etc-cron.d-has-restriction-for-permission-and-owner)
- [ubuntuでcronを動かす方法-水色のパンダ団日記](https://pandadannikki.blogspot.com/2023/03/crontab.html)
- [crontabでdateコマンドを実行 – エラーの向こうへ](https://tech.mktime.com/entry/365)
- [cronでバッチを設定する #Linux - Qiita](https://qiita.com/kiiimiis/items/4b8d0ff0e6891e5df868)
- [cronで処理を実行させた際に環境変数が読み込まれない件【小ネタ】 | bassbone's blog](https://blog.bassbone.tokyo/archives/1311)
- [コマンドの出力結果からANSIエスケープシーケンスのカラーリングを取り除く方法 | ゲンゾウ用ポストイット](https://genzouw.com/entry/2023/02/09/090044/3229/)
