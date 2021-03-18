#!/bin/bash
cd
mkdir bees
wget -O ~/bees/bee-clef-service https://raw.githubusercontent.com/w0rldwind/test/main/bee-clef-service
wget -O ~/bees/clef.sh https://raw.githubusercontent.com/w0rldwind/test/main/clef.sh
wget -O ~/bees/bee-clef.service https://raw.githubusercontent.com/w0rldwind/test/main/bee-clef.service
wget -O ~/bees/bee.service https://raw.githubusercontent.com/w0rldwind/test/main/bee.service
wget -O ~/bees/bee.yaml https://raw.githubusercontent.com/w0rldwind/test/main/bee.yaml
wget -O ~/bees/upd.sh https://raw.githubusercontent.com/w0rldwind/test/main/upd.sh
wget -O ~/bees/cashout.sh https://raw.githubusercontent.com/w0rldwind/test/main/cashout.sh

chmod +x ~/bees/upd.sh
chmod +x ~/bees/clef.sh
chmod +x ~/bees/bee-clef-service
chmod +x ~/bees/bee.service
chmod +x ~/bees/bee-clef.service
chmod +x ~/bees/cashout.sh
