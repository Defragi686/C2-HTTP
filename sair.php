
<?php
require_once 'classes/Usuario.php';
session_start();
if(!isset($_SESSION['id'])){
    header("Location: login.php");
    exit;
}
session_start();
unset($_SESSION['id']);
header("Location: index.php");
?>