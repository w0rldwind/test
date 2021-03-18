#!/bin/bash
echo "Какую bee установить? (1-8)"
read n
let "port=$n+1"

mkdir ~/bees/bee$n
mkdir ~/bees/bee$n/bee
mkdir ~/bees/bee$n/bee/cfg
mkdir ~/bees/bee$n/bee/data

mkdir ~/bees/bee$n/clef
mkdir ~/bees/bee$n/clef/cfg
mkdir ~/bees/bee$n/clef/data

wget -O ~/bees/bee$n/bee/bee https://github.com/ethersphere/bee/releases/download/v0.5.2/bee-linux-amd64
chmod +x ~/bees/bee$n/bee/bee
wget -O ~/bees/bee$n/clef/bee-clef https://github.com/ethersphere/bee-clef/releases/download/v0.4.9/bee-clef-linux-amd64
chmod +x ~/bees/bee$n/clef/bee-clef
wget -O ~/bees/bee$n/clef/cfg/4byte.json https://raw.githubusercontent.com/ethersphere/bee-clef/master/packaging/4byte.json
wget -O ~/bees/bee$n/clef/cfg/rules.js https://raw.githubusercontent.com/ethersphere/bee-clef/master/packaging/rules.js

cp ~/bees/bee.yaml ~/bees/bee$n/bee/cfg/
cp ~/bees/bee-clef-service ~/bees/bee$n/clef/
cp ~/bees/bee.service /etc/systemd/system/bee$n.service
cp ~/bees/bee-clef.service /etc/systemd/system/bee-clef$n.service
cp ~/bees/cashout.sh ~/cashout$n.sh

sed -i 's/api-addr: :2633/api-addr: :'$port'633/' ~/bees/bee$n/bee/cfg/bee.yaml
sed -i 's/clef-signer-endpoint: \x2Froot\x2Fbees\x2Fbee1\x2Fclef\x2Fdata\x2Fclef.ipc/clef-signer-endpoint: \x2Froot\x2Fbees\x2Fbee'$n'\x2Fclef\x2Fdata\x2Fclef.ipc/' ~/bees/bee$n/bee/cfg/bee.yaml
sed -i 's/config: \x2Froot\x2Fbees\x2Fbee1\x2Fbee\x2Fcfg\x2Fbee.yaml/config: \x2Froot\x2Fbees\x2Fbee'$n'\x2Fbee\x2Fcfg\x2Fbee.yaml/' ~/bees/bee$n/bee/cfg/bee.yaml
sed -i 's/data-dir: \x2Froot\x2Fbees\x2Fbee1\x2Fbee\x2Fdata/data-dir: \x2Froot\x2Fbees\x2Fbee'$n'\x2Fbee\x2Fdata/' ~/bees/bee$n/bee/cfg/bee.yaml
sed -i 's/debug-api-addr: 127.0.0.1:2635/debug-api-addr: 127.0.0.1:'$port'635/' ~/bees/bee$n/bee/cfg/bee.yaml
sed -i 's/p2p-addr: :2634/p2p-addr: :'$port'634/' ~/bees/bee$n/bee/cfg/bee.yaml
sed -i 's/tracing-service-name: bee1/tracing-service-name: bee'$n'/' ~/bees/bee$n/bee/cfg/bee.yaml

sed -i 's/bee=bee1/bee=bee'$n'/' ~/bees/bee$n/clef/bee-clef-service
sed -i 's/DATA_DIR=\x2Froot\x2Fbees\x2Fbee1\x2Fclef\x2Fdata/DATA_DIR=\x2Froot\x2Fbees\x2Fbee'$n'\x2Fclef\x2Fdata/' ~/bees/bee$n/clef/bee-clef-service
sed -i 's/CONFIG_DIR=\x2Froot\x2Fbees\x2Fbee1\x2Fclef\x2Fcfg/CONFIG_DIR=\x2Froot\x2Fbees\x2Fbee'$n'\x2Fclef\x2Fcfg/' ~/bees/bee$n/clef/bee-clef-service

sed -i 's/ExecStart=\x2Froot\x2Fbees\x2Fbee1\x2Fbee\x2Fbee start --config \x2Froot\x2Fbees\x2Fbee1\x2Fbee\x2Fcfg\x2Fbee.yaml/ExecStart=\x2Froot\x2Fbees\x2Fbee'$n'\x2Fbee\x2Fbee start --config \x2Froot\x2Fbees\x2Fbee'$n'\x2Fbee\x2Fcfg\x2Fbee.yaml/' /etc/systemd/system/bee$n.service
sed -i 's/ExecStart=\x2Froot\x2Fbees\x2Fbee1\x2Fclef\x2Fbee-clef-service start/ExecStart=\x2Froot\x2Fbees\x2Fbee'$n'\x2Fclef\x2Fbee-clef-service start/' /etc/systemd/system/bee-clef$n.service
sed -i 's/ExecStop=\x2Froot\x2Fbees\x2Fbee1\x2Fclef\x2Fbee-clef-service stop/ExecStop=\x2Froot\x2Fbees\x2Fbee'$n'\x2Fclef\x2Fbee-clef-service stop/' /etc/systemd/system/bee-clef$n.service

sed -i 's/DEBUG_API=http:\x2F\x2Flocalhost:1635/DEBUG_API=http:\x2F\x2Flocalhost:'$port'635/' ~/cashout$n.sh

echo "0 */6 * * * /bin/bash /root/cashout$n.sh cashout-all >> /root/cash$n.log 2>&1		<--- Скопируй для добавления в планировщик (crontab -e). Продолжение установки через 10 сек..."

sleep 10

./clef.sh init $n

systemctl daemon-reload
systemctl start bee-clef$n
sleep 10
systemctl start bee$n
journalctl --lines=100 --follow --unit bee$n