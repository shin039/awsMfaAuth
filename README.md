# awsMfaAuth

## 設定

### awsmfa.cmd
下記3点に適当な値を設定する。
mfa_serial=MFA認証に使用するMFAデバイスのARN
profile=MFA認証用のプロファイル名
awscli_args=MFA認証を行うawsコマンド実行時に指定する引数があれば指定する

(例)
set mfa_serial=arn:aws:iam::999999999999:mfa/username
set profile=mfa
set awscli_args=--profile formfa


### base_credentials
mfa認証で取得する情報と結合するcredentialsファイル
配下のファイルを全て結合する

(例: base_credentials/default)
[default]
aws_access_key_id = A0DUMMY0KEYID0DAYO
aws_secret_access_key = dummyN05ecret4ccessK3y

## 事前準備
jqコマンドを使います。
windows版にはバイナリを入れてあります。
linux, mac版は各自でjqコマンドをインストールして使えるようにしてください。
