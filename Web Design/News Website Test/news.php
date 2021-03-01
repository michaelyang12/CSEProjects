<?php
    session_start();

    //Logout user if url contains logout
    if(isset($_GET['logout'])) {
        $_SESSION['user'] = "";
        session_destroy();
        header("Location: index.php");
    }

    //connect to database with wustl user
    $conn = new mysqli('localhost', 'wustl_inst', 'wustl_pass', 'news_site');

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    } 

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>News</title>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
    <link rel="stylesheet" href="/news/main.css">

</head>
<body>
    <!-- Navbar to navigate website -->
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
                //Display Welcome and logout button if user is logged in
                if(isset($_SESSION["user"])) {
                    echo '<p class="mr-sm-2" style="margin-top: 8px;">Welcome '.$_SESSION["user"].'</p>';
                    echo '<form action="index.php" method="GET" class="form-inline my-2 my-lg-0">';
                    echo '<button class="btn btn-success" type="submit" name="logout" value="logout">Logout</button>';
                    echo '</form>';
                } else {
                    //Display login form if user is not logged in
                    echo '<form action="login.php" method="POST" class="form-inline my-2 my-lg-0">';
                    echo '<input class="form-control mr-sm-2" type="email" placeholder="Email" aria-label="email" name="email-login">';
                    echo '<input class="form-control mr-sm-2" type="password" placeholder="Password" aria-label="password" name="password-login">';
                    echo '<button class="btn btn-success">Login</button>';
                    echo '</form>';
                }
            ?>       
        </div>
    </nav>
    <div class="news-header center-text">
        <h2>Check out most recent posts</h2>
        
        <!-- Form to create new Post -->
        <form method="POST" action="createPost.php">
            <p>Create new post now!</p>

            <!-- CSRF Token -->
            <input type="hidden" name="token" value="<?php echo $_SESSION['token'];?>" />
            <button class="btn btn-primary" type="submit" id="create-post">Post</button>
        </form>
    </div>
    <div class="container">
        <div class="row">

            <!-- PHP script to show all posts in order of creation -->
           <?php
                $query = 'SELECT * FROM posts';
                $result = mysqli_query($conn, $query);
                $posts = array();
                $counter = 0;
                while($row = mysqli_fetch_array($result)) {
                    $posts[$counter] = $row;
                    $counter++;
                }
                for($i = count($posts) -1; $i >= 0; $i--) {

                    //Creates posts with sanitized data from database
                    createCard(
                        mysqli_real_escape_string($conn, $posts[$i]['title']),
                        mysqli_real_escape_string($conn, $posts[$i]['bodyText']), 
                        mysqli_real_escape_string($conn, $posts[$i]['link']), 
                        mysqli_real_escape_string($conn, $posts[$i]['email']), 
                        mysqli_real_escape_string($conn, $posts[$i]['id'])
                    );
                }
           ?>
        </div>
    </div>

    <!-- Bootstrap Javascript scripts -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>

</body>
</html>
<?php
    //Create full post function
    function createCard($title, $bodyText, $link, $user, $id) {
        echo '<div class="card col-md-12 border-dark mb-3" style="margin-bottom: 20px;">';
        echo '<div class="card-body">';
        echo '<h5 style="display: inline;" class="card-title">'.$title.' - By: '.$user.'</h5>';
        echo '<hr>';
        echo '<p class="card-text">'.$bodyText.'</p>';
        if(isset($link) && $link != "") {
            echo '<hr>';
            //<button class="btn">
            echo '<a href="'.$link.'" style="float: left; margin-right: 20px;" target="_blank" class="card-link">Link</a>';
            //</button>
        }
        echo '<form action="post.php" method="GET">';
        echo '<button class="btn btn-primary" type="submit" name="post" value="'.$id.'">Go To Post</button>';
        echo '</form>';
        echo '</div>';
        echo '</div>';
    }
?>