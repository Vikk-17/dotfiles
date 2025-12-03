# Download the docker credential pass from the docker release page github
# chmod 777 docker-credential-pass
# mv it to /usr/local/bin
#
gpg2 --gen-key
pass init "<Your Name>"
sed -i '0,/{/s/{/{\n\t"credsStore": "pass",/' ~/.docker/config.json
docker login
