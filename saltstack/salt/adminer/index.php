<?php
$_GET['pgsql'] = 'localhost';
$_GET['username'] = '{{ pillar['postgresql']['user'] }}';
$_GET['password'] = '{{ pillar['postgresql']['password'] }}';

require_once 'adminer.php';
