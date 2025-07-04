<?php
// Ativa exibição de erros
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json; charset=utf-8');
require __DIR__ . '/../Auth/auth.php';

$userId = requireAuth();

// Busca dados do usuário no banco
global $pdo;
$stmt = $pdo->prepare("
    SELECT user_id, role_id, name, phone, email, is_active
      FROM users
     WHERE user_id = :id
");
$stmt->execute([':id' => $userId]);
$user = $stmt->fetch();

if (!$user) {
    http_response_code(404);
    echo json_encode(['error' => 'Usuário não encontrado']);
    exit;
}


echo json_encode([
    'authorized' => true,
    'user'       => $user
]);
