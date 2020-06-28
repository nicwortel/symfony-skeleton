#!/bin/bash

sed -i 's/App\\/Vendor\\Project\\Infrastructure\\/g' bin/console public/index.php config/routes.yaml config/services.yaml
sed -i 's/src\//src\/Infrastructure\//g' config/services.yaml

mv src/Controller/ src/Infrastructure/Controller/

rm -f src/Kernel.php phpunit.xml.dist

vendor/bin/phpcbf || true

sed -i '/###/d' .gitignore
sed -i '/^$/d' .gitignore
sort .gitignore -o .gitignore

# Remove this script
sed -i '/setup\.sh/d' composer.json
rm setup.sh
