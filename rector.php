<?php

declare(strict_types=1);

use Rector\CodeQuality\Rector\Class_\InlineConstructorDefaultToPropertyRector;
use Rector\CodeQuality\Rector\If_\ExplicitBoolCompareRector;
use Rector\CodingStyle\Rector\ClassMethod\MakeInheritedMethodVisibilitySameAsParentRector;
use Rector\Config\RectorConfig;
use Rector\Doctrine\Set\DoctrineSetList;
use Rector\Set\ValueObject\LevelSetList;
use Rector\Set\ValueObject\SetList;
use Rector\Strict\Rector\Empty_\DisallowedEmptyRuleFixerRector;
use Rector\Symfony\Set\SymfonySetList;
use Rector\TypeDeclaration\Rector\Property\TypedPropertyFromStrictConstructorRector;

return RectorConfig::configure()
    // register single rule
    ->withRules([
        InlineConstructorDefaultToPropertyRector::class,
        TypedPropertyFromStrictConstructorRector::class,
    ])
    ->withSets([
        DoctrineSetList::ANNOTATIONS_TO_ATTRIBUTES,
        LevelSetList::UP_TO_PHP_82,
        SymfonySetList::ANNOTATIONS_TO_ATTRIBUTES,
        SymfonySetList::SYMFONY_CODE_QUALITY,
        SymfonySetList::SYMFONY_71,
        SetList::CODE_QUALITY,
        SetList::CODING_STYLE,
        SetList::PHP_83,
    ])
    ->withPreparedSets(
        deadCode: true,
        codeQuality: true
    )
    ->withSkip([
        DisallowedEmptyRuleFixerRector::class,
        MakeInheritedMethodVisibilitySameAsParentRector::class,
        ExplicitBoolCompareRector::class,
    ])
;
