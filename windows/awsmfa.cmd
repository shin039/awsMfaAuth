@echo off

REM ----------------------------------------------------------------------------
REM Args Check
REM ----------------------------------------------------------------------------
rem �������Ȃ��ꍇ�͏I������
if "%~1"=="" (
  echo �������Ƀg�[�N���R�[�h���w�肵�Ă�������
  exit /b
)

REM ----------------------------------------------------------------------------
REM Settings
REM ----------------------------------------------------------------------------
set mfa_serial=<Set Your Mfa Devices ARN>
set profile=<Set Your Profile Name>
set awscli_args=<Set Aws Cli Args>

REM ----------------------------------------------------------------------------
REM Statics
REM ----------------------------------------------------------------------------
set current_dir=%~dp0
set base_credentials="%current_dir%base_credentials"
set jq=%current_dir%\jq-win64.exe

set time_tmp=%time: =0%
set now=%date:/=%%time_tmp:~0,2%%time_tmp:~3,2%%time_tmp:~6,2%
set tmp_file=tmp_%now%

set credentials=%homedrive%%homepath%\.aws\credentials
set token_code=%~1

REM ----------------------------------------------------------------------------
REM Main
REM ----------------------------------------------------------------------------

REM Fetch AWS
aws %awscli_args% sts get-session-token --serial-number %mfa_serial% --token-code %token_code% > %tmp_file% 
if not "%ERRORLEVEL%"  == "0" (
  if exist %tmp_file% erase %tmp_file%
  exit /b
)

REM Create credentials file by profile
setlocal
  set cmd1="type %tmp_file% | %jq% -r ".Credentials.AccessKeyId""
  set cmd2="type %tmp_file% | %jq% -r ".Credentials.SecretAccessKey""
  set cmd3="type %tmp_file% | %jq% -r ".Credentials.SessionToken""
  for /f "usebackq delims=" %%A in (`%cmd1%`) do set accessKeyId=%%A
  for /f "usebackq delims=" %%A in (`%cmd2%`) do set secretAccessKey=%%A
  for /f "usebackq delims=" %%A in (`%cmd3%`) do set sessionToken=%%A

  echo;                                          >  %base_credentials%\%profile%
  echo # --------------------                    >> %base_credentials%\%profile%
  echo # %profile%                               >> %base_credentials%\%profile%
  echo # --------------------                    >> %base_credentials%\%profile%
  echo [%profile%]                               >> %base_credentials%\%profile%
  echo aws_access_key_id     =%accessKeyId%      >> %base_credentials%\%profile%
  echo aws_secret_access_key =%secretAccessKey%  >> %base_credentials%\%profile%
  echo aws_session_token     =%sessionToken%     >> %base_credentials%\%profile%
  echo;
endlocal

REM Delete temp file
if exist %tmp_file% erase %tmp_file%

REM backup credentials
REM �o�b�N�A�b�v����������Ă��������Ƃ�
REM if exist %credentials% copy /Y %credentials% %credentials%.%now%
REM ���O�̃o�b�N�A�b�v�����ł����Ƃ�
if exist %credentials% copy /Y %credentials% %credentials%.autobackup > nul

REM create new credentials
echo; > %credentials%
for /f "usebackq" %%A in (`dir /b %base_credentials%`) do type %base_credentials%\%%A >> %credentials%

