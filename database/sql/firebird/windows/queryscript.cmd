set P_SQLFILE=%1
set P_LOGFILE=%2

set XURMDB_CHARSET=%URMDB_CHARSET:windows-=WIN%
%FBPATH%\isql -q -u %URMDB_USER% -p %URMDB_PWD% -ch %XURMDB_CHARSET% -i %P_SQLFILE% "%URMDB_DBHOST%:%URMDB_DBNAME%" > %P_LOGFILE% 2>&1
SET status=%errorlevel%
echo status=%status%

if %status% == 0 exit /B 0
exit /B 1
