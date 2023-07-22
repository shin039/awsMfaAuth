# awsMfaAuth

## 設定

### awsmfa.cmd
下記3点に適当な値を設定する。<br>
mfa_serial=MFA認証に使用するMFAデバイスのARN<br>
profile=MFA認証用のプロファイル名<br>
awscli_args=MFA認証を行うawsコマンド実行時に指定する引数があれば指定する<br>

(例) <br>
set mfa_serial=arn:aws:iam::999999999999:mfa/username<br>
set profile=mfa<br>
set awscli_args=--profile formfa<br>


### base_credentials
mfa認証で取得する情報と結合するcredentialsファイル<br>
配下のファイルを全て結合する<br>

(例: base_credentials/default)<br>
[default]<br>
aws_access_key_id = A0DUMMY0KEYID0DAYO<br>
aws_secret_access_key = dummyN05ecret4ccessK3y<br>

## 事前準備
jqコマンドを使います。<br>
windows版にはバイナリを入れてあります。<br>
linux, mac版は各自でjqコマンドをインストールして使えるようにしてください。<br>
