<?php
    session_start();

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

    if(isset($_POST['changed'])) {

        //update table with sanitized input
        $query = $conn->prepare('UPDATE comments SET comment=? WHERE id=?');
        $query->bind_param("si", $_POST['comment'], $_POST['id']);
        $query->execute();

        header("Location: post.php?post=".$_POST['postId']);
    } else {

        $comment = "";

        $query = 'SELECT * FROM comments WHERE id="'.$_POST['commentId'].'"';
        $result = mysqli_query($conn, $query);
        while($row = mysqli_fetch_array($result)) {
            $comment = $row['comment'];
        }
    }
 
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Comment</title>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
    <link rel="stylesheet" href="/news/main.css">

</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light sticky-top">
        <a class="navbar-brand" href="#">News Website</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/news">Home</a>
                </li>
                <li class="nav-item active">
                    <a class="nav-link" href="/news/news.php">News</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/news/account.php">Account</a>
                </li>
            </ul>
            <?php
                //Display user header and logout button
                echo '<p class="mr-sm-2">Welcome '.$_SESSION["user"].'</p>';
                echo '<form action="news.php" method="GET" class="form-inline my-2 my-lg-0">';
                echo '<button class="btn btn-success" type="submit" name="logout" value="logout">Logout</button>';
                echo '</form>';

            ?>       
        </div>
    </nav>
    <div class="container">
        <h1 class="center-text" style="margin-top: 20px">Edit Comment</h1>
        <div class="col-sm-12">
        
            <!-- Form to edit comment -->
            <form action="editComment.php" method="POST">
                <div class="form-group">
                <label for="body">Type comment here</label>
                    <textarea id="body" class="form-control" name="comment" rows="10" required><?php echo $comment; ?></textarea>
                </div>
                <!-- CSRF Token -->
                <input type="hidden" name="token" value="<?php echo $_SESSION['token']; ?>"/>
                <input type="hidden" name="id" value="<?php echo $_POST['commentId']; ?>"/>
                <input type="hidden" name="postId" value="<?php echo $_POST['postId']; ?>"/>
                <button type="submit" class="btn btn-primary" name="changed" value="true">Edit</button>
            </form>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
</body>
</html>