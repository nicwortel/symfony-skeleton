#!/bin/bash

sed -i 's/App\\/Vendor\\Project\\Infrastructure\\/g' bin/console public/index.php

mv src/Controller/ src/Infrastructure/Controller/

rm -f src/Kernel.php

vendor/bin/phpcbf || true
