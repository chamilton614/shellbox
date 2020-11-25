@echo off

REM Set the OpenShift Project to use
set PROJECT=%1

REM Check if Project was passed in
if /I "%PROJECT%" EQU "" (
    REM Usage
    echo "setup-shellbox myproject"
) else (
    REM Create the Build Config
    oc new-build --strategy docker --binary --docker-image centos:centos7 --name shellbox -n %PROJECT%
    echo.

    REM Start the Build
    oc start-build shellbox --from-dir . --follow -n %PROJECT%
    echo.

    REM Deploy the Application
    oc new-app shellbox --name shellbox -n %PROJECT%
    echo.
)