# awsMfaAuth

mfa認証して取得した一時的セキュリティ認証情報を反映したcredentialsファイルを自動生成し~/.aws/credentialsに配置します。<br>
configファイルは別途、各自で用意して下さい。<br>
<br>
本実行ファイルでは、base_credentialsディレクトリ配下にmfa認証したcredentialsを含むファイルを生成した後、<br>
base_credentialsディレクトリ配下にあるすべてのファイルを結合して新しくcredentialsファイルを生成して~/.aws配下に配置します。<br>

## 事前準備
jqコマンドを使います。<br>
windows版にはバイナリを入れてあります。<br>
linux, mac版は各自でjqコマンドをインストールして使えるようにしてください。<br>

## 設定

### awsmfa.cmd
下記3点に適当な値を設定する。<br>
- mfa_serial=MFA認証に使用するMFAデバイスのARN<br>
- profile=MFA認証用のプロファイル名<br>
- awscli_args=MFA認証を行うawsコマンド実行時に指定する引数があれば指定する<br>

(例) <br>
set mfa_serial=arn:aws:iam::999999999999:mfa/username<br>
set profile=mfa　※mfa認証した後に使用するプロファイル名を設定する<br>
set awscli_args=--profile profile_name    ※mfa認証(aws sts get-session-token実行)のためにプロファイルなどの指定があれば設定。<br>


### base_credentials
mfa認証で取得する情報と結合するcredentialsファイル<br>
配下のファイルを全て結合して新しいcredentialsファイルを生成する<br>

(例: base_credentials/default)<br>
[default]<br>
aws_access_key_id = A0DUMMY0KEYID0DAYO<br>
aws_secret_access_key = dummyN05ecret4ccessK3y<br>

## 使い方
```bash
# Linux, Mac
$ ./awsmfa.sh トークンコード

# Windows
> awsmfa トークンコード
```
