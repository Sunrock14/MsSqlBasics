# Mssql Tsql Komutları

## Docker Mssql Kurulumu
Bilgisayar üzerinde sürekli olarak mssql çalıştırmak yerine, veritabanını docker üzerinde çalıştırabiliriz.
İlk olarak Docker Hub üzerinden ilgili imajı kontrol edelim.
https://hub.docker.com/_/microsoft-mssql-server


    ```Script
    --docker pull mcr.microsoft.com/mssql/server:2022-latest

    --docker run 
        --name MyMsSql_Container_Name
        -e 'ACCEPT_EULA=Y' 
        -e 'SA_PASSWORD=MyStringSqlPassword0012' 
        -e 'MSSQL_PID=Developer' 
        -p 1433:1433 
        -h sqlServer2022 
        -d mcr.microsoft.com/mssql/server:2022-latest

    ```
