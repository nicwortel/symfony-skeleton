<?php
declare(strict_types=1);

use Symfony\Component\Dotenv\Dotenv;

// The check is to ensure we don't use .env in production
if (!isset($_SERVER['APP_ENV'])) {
    (new Dotenv())->load(__DIR__ . '/../../.env');
}
