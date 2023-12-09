#!/bin/bash
# Exit on error
sudo setcap 'cap_net_bind_service=+ep' AuthServer
# Set mysql config parameters based on evironment variables
for file in /DarkflameServer/build/sharedconfig.ini; do
    sed -i "s/mysql_host.*/mysql_host=$MYSQL_HOST/g" $file
    sed -i "s/mysql_database.*/mysql_database=$MYSQL_DATABASE/g" $file
    sed -i "s/mysql_username.*/mysql_username=$MYSQL_USERNAME/g" $file
    sed -i "s/mysql_password.*/mysql_password=$MYSQL_PASSWORD/g" $file
    sed -i "s/client_location.*/client_location=\/LegoFiles/g" $file
    sed -i "s/external_ip.*/external_ip=$EXTERNAL_IP/g" $file
    echo "Updated settings in \"$file\" from environment vars"
done

for file in /DarkflameServer/build/masterconfig.ini; do
    sed -i "s/master_ip.*/master_ip=$MASTER_IP/g" $file
done

# Run the DLU Server
./build/MasterServer
