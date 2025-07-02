<?php
// public/validate.php
header('Content-Type: application/json; charset=utf-8');
require __DIR__ . '/../src/auth.php';

$userId = requireAuth();

// Busca dados básicos do usuário
global $pdo;
$stmt = $pdo->prepare("
    SELECT user_id, role_id, name, phone, email, is_active
      FROM users
     WHERE user_id = :id
");
$stmt->execute([':id' => $userId]);
$user = $stmt->fetch();

echo json_encode([
    'authorized' => true,
    'user'       => $user
]);
