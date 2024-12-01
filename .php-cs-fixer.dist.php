<?php

use PhpCsFixer\Config;
use PhpCsFixer\Finder;
use PhpCsFixer\Runner\Parallel\ParallelConfigFactory;

if (!file_exists(__DIR__.'/src')) {
    exit(0);
}

// @link https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/blob/master/doc/rules/index.rst
return (new Config())
    ->setParallelConfig(ParallelConfigFactory::detect())
    ->setRules([
        '@PhpCsFixer' => true,
        '@Symfony' => true,
        'modernize_strpos' => true,
        'protected_to_private' => false,
        'native_constant_invocation' => ['strict' => false],
        'single_blank_line_at_eof' => true,
        'php_unit_test_class_requires_covers' => false,
        'phpdoc_to_comment' => false,
    ])
    ->setRiskyAllowed(true)
    ->setFinder(
        (new Finder())
            ->in(__DIR__)
            ->exclude(['var', 'vendor'])
    )
    ->setCacheFile('.php-cs-fixer.cache')
    ;