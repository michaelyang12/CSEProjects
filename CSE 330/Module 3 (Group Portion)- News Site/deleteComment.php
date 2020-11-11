<?php
    session_start();

    //Make sure user is logged in
    if(!isset($_SESSION['user'])) {
        header("Location: index.php?error=You must be logged in to post");
        die();
    }

    //Make sure token exists to prevent CSRF attack. Will log user out and redirect back to home page
    if(!isset($_POST['token'])) {
        $_SESSION['user'] = "";
        session_destroy();
        echo "Token not set";
        header("Location: index.php?error=You are not permitted to do that");
        die;
    }

    //Check to make sure user's token matches up with given token. Will log user out and redirect back to home page
    if(!hash_equals($_SESSION['token'], $_POST['token'])){
        $_SESSION['user'] = "";
        session_destroy();
        header("Location: index.php?error=You are not permitted to do that");
        die("Request forgery detected");
    }

    //connect to database with wustl user
    $conn = new mysqli('localhost', 'wustl_inst', 'wustl_pass', 'news_site');

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    //Delete commend from database
    $query = $conn->prepare('DELETE FROM comments WHERE id=?');
    $query->bind_param("i", $_POST['commentId']);
    $query->execute();

    //Send user back to post
    header("Location: post.php?post=".$_POST['postId']);
?>