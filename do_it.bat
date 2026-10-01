@echo off
cd /d "%~dp0"
cd

rem 1 Создание корневого сертификата Root CA
openssl.exe req -x509 -newkey rsa:4096 -passout pass:"HSEPassw0rd" -days 3650 -subj "/C=RU/ST=Moscow/L=Moscow/O=HSE/CN=HSE RootCA" -config openssl.cnf -extensions v3_ca -keyout rootca.key -out rootca.crt

rem ------------------------------------------------------------------------------------------------------------------------------------------------------
rem 2.1 Запрос на промежуточный серверный сертификат - mca
openssl.exe req -newkey rsa:4096 -passout pass:"HSEPassw0rd" -subj "/C=RU/ST=Moscow/L=Moscow/O=HSE/CN=MIEM" -config openssl.cnf -keyout groupmca.key -out groupmca.csr

rem 2.2 Подпись запроса и создание серверного сертификата
openssl.exe x509 -req -passin pass:"HSEPassw0rd" -in groupmca.csr -CA rootca.crt -CAkey rootca.key -CAcreateserial -days 365 -extfile openssl.cnf -extensions v3_mca -out groupmca.crt

rem ------------------------------------------------------------------------------------------------------------------------------------------------------
rem 3.1 Запрос на создание пользовательского сертификата
openssl.exe req -newkey rsa:4096 -passout pass:"HSEPassw0rd" -subj "/C=RU/ST=Moscow/L=Moscow/O=HSE/OU=MIEM/CN=Ivan Ivanov" -config openssl.cnf -keyout usercert.key -out usercert.csr

rem 3.2 Подпись запроса и создание пользовательского сертификата
openssl x509 -req -passin pass:"HSEPassw0rd" -in usercert.csr -CA groupmca.crt -CAkey groupmca.key -CAcreateserial -days 90 -extfile openssl.cnf -extensions usr_cert -out usercert.crt

rem ------------------------------------------------------------------------------------------------------------------------------------------------------
rem 4 Создание контейнера p12
type usercert.crt groupmca.crt rootca.crt > certs.crt

openssl.exe pkcs12 -export -passin pass:"HSEPassw0rd" -passout pass:"UserPass123" -in certs.crt -inkey usercert.key -out final.p12

rem 5 Установка
certutil -f -p UserPass123 -importpfx final.p12 NoExport
pause