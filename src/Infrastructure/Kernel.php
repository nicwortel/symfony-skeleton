<?php

declare(strict_types=1);

namespace Vendor\Project\Infrastructure;

use Symfony\Bundle\FrameworkBundle\Kernel\MicroKernelTrait;
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;
use Symfony\Component\HttpKernel\Kernel as BaseKernel;
use Symfony\Component\Routing\Loader\Configurator\RoutingConfigurator;

use function dirname;
use function is_file;

class Kernel extends BaseKernel
{
    use MicroKernelTrait;

    protected function configureContainer(ContainerConfigurator $container): void
    {
        $container->import('../../config/{packages}/*.yaml');
        $container->import('../../config/{packages}/' . $this->environment . '/*.yaml');

        $path = dirname(__DIR__, 2) . '/config/services.php';

        if (is_file(dirname(__DIR__, 2) . '/config/services.yaml')) {
            $container->import('../../config/{services}.yaml');
            $container->import('../../config/{services}_' . $this->environment . '.yaml');
        } elseif (is_file($path)) {
            (require $path)($container->withPath($path), $this);
        }
    }

    protected function configureRoutes(RoutingConfigurator $routes): void
    {
        $routes->import('../../config/{routes}/' . $this->environment . '/*.yaml');
        $routes->import('../../config/{routes}/*.yaml');

        $path = dirname(__DIR__, 2) . '/config/routes.php';

        if (is_file(dirname(__DIR__, 2) . '/config/routes.yaml')) {
            $routes->import('../../config/{routes}.yaml');
        } elseif (is_file($path)) {
            (require $path)($routes->withPath($path), $this);
        }
    }
}
