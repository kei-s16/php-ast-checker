<?php
require '/php-ast/util.php';

$file = file_get_contents($argv[1]);

$ast = ast\parse_code($file, $version=90);
echo ast_dump($ast), "\n";
