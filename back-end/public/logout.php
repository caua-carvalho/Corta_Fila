<?php
// public/logout.php
// 1) Ativa exibição de erros
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json; charset=utf-8');
require __DIR__ . '/../Auth /auth.php';

$token = getBearerToken();
if ($token) {
    revokeToken($token);
}

echo json_encode(['success' => true]);
