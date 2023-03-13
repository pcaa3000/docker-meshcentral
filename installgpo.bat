@echo off

rem Se verifica que el agente aún no esté instalado.
if exist "%programfiles%\Mesh Agent\MeshAgent.exe" goto end
IF "%PROCESSOR_ARCHITECTURE%"=="x86" (
    "\\shared\meshagent32.exe" -fullinstall
) else ( "\\shared\meshagent64.exe" -fullinstall )

:end
