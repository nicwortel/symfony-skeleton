#!/bin/bash

sed -i 's/App\\/Vendor\\Project\\Infrastructure\\/g' bin/console public/index.php config/routes.yaml

mv src/Controller/ src/Infrastructure/Controller/

rm -f src/Kernel.php

vendor/bin/phpcbf || true

sed -i '/###/d' .gitignore
sed -i '/^$/d' .gitignore
sort .gitignore -o .gitignore
