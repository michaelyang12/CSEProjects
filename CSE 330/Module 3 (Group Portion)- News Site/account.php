<?php

    session_start();

    //Send User back to homepage if not logged in
    if(!isset($_SESSION['user'])) {
        header("Location: index.php?error=You must be logged in to do this");
        die();
    }

    $firstName = "";
    $lastName = "";
    $email = $_SESSION['user'];
    $birthday = "";

    //connect to database with wustl user
    $conn = new mysqli('localhost', 'wustl_inst', 'wustl_pass', 'news_site');

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    //Get First name, last name, email, and birthday of user from database
    $query = 'SELECT firstName, lastName, email, birthday FROM users WHERE ID='.$_SESSION['userid'].'';
    $result = mysqli_query($conn, $query);
    while($row = mysqli_fetch_array($result)) {

        //Sanitize input
        $firstName = mysqli_real_escape_string($conn, $row['firstName']);
        $lastName = mysqli_real_escape_string($conn, $row['lastName']);
        $email = mysqli_real_escape_string($conn, $row['email']);
        $birthday = mysqli_real_escape_string($conn, $row['birthday']);
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
                <li class="nav-item">
                    <a class="nav-link" href="/news/news.php">News</a>
                </li>
                <li class="nav-item active">
                    <a class="nav-link" href="/news/account.php">Account</a>
                </li>
            </ul>
            <?php
           
               //Display Welcome and logout button if user is logged in
                echo '<p class="mr-sm-2" style="margin-top: 8px;">Welcome '.$_SESSION["user"].'</p>';
                echo '<form action="news.php" method="GET" class="form-inline my-2 my-lg-0">';
                echo '<button class="btn btn-success" type="submit" name="logout" value="logout">Logout</button>';
                echo '</form>';
            ?>       
        </div>
    </nav>
    <div class="row">

        <!-- Vertical Selections to navigate through user's profile -->
        <div class="col-2">
            <div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
            <a class="nav-link active" data-toggle="pill" href="#general-settings-tab" role="tab" aria-selected="true">Profile</a>
            <a class="nav-link" data-toggle="pill" href="#posts" role="tab" aria-selected="false">Posts</a>
            <a class="nav-link" data-toggle="pill" href="#comments" role="tab" aria-selected="false">Comments</a>
            </div>
        </div>

        <!-- User profile content -->
        <div class="col-8">
            <div class="tab-content">

            <!-- Profile Section -->
            <div class="tab-pane fade show active" id="general-settings-tab" role="tabpanel">
                <?php
                    //Display Error to user if one exists. If no error will display success message
                    if(isset($_GET['error'])) {

                        //Escape output for error or success
                        echo '<div class="alert alert-danger alert-dismissible fade show" role="alert">'.htmlspecialchars($_GET['error']).'<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>';
                    } else if (isset($_GET['success'])) {
                        echo '<div class="alert alert-success alert-dismissible fade show" role="alert">'.htmlspecialchars($_GET['success']).'<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>';
                    }
                ?>
                <h1 class="center-text" style="padding-top: 20px;">Profile</h1>

                <!-- Display Profile to user -->
                <p>Name: <?php  echo $firstName." ".$lastName?></p>
                <p>Email: <?php  echo $email?></p>
                <p>Birthday: <?php  echo $birthday?></p>
                <h2 class="center-text">Edit Profile</h2>

                <!-- Form to change profile -->
                <form action="editProfile.php" method="POST">
                    <div class="form-row">
                        <div class="form-group col-sm-6">
                            <label for="firstName">First Name</label>
                            <input type="text" class="form-control" id="firstName" name="firstName">
                        </div>
                        <div class="form-group col-sm-6">
                            <label for="lastName">Last Name</label>
                            <input type="text" class="form-control" id="lastName" name="lastName">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-sm-8">
                            <label for="email">Email</label>
                            <input type="email" class="form-control" id="email" name="email">
                        </div>
                        <div class="form-group col-sm-4">
                            <label for="birthday">Birthday</label>
                            <input type="date" class="form-control" id="birthday" name="birthday">
                        </div>
                    </div>

                    <!-- CSRF Token -->
                    <input type="hidden" name="token" value="<?php echo $_SESSION['token'];?>" />
                    <button type="submit" class="btn btn-primary" name="id" value=<?php echo $_SESSION['userid'];?>>Change</button>
                </form>
            </div>

            <!-- Posts Section -->
            <div class="tab-pane fade" id="posts" role="tabpanel">
            <h1>All Posts</h1>
                <?php
                    //Display all posts created by the user to the user
                    $query = 'SELECT * FROM posts';
                    $result = mysqli_query($conn, $query);
                    $posts = array();
                    $counter = 0;
                    while($row = mysqli_fetch_array($result)) {
                        $posts[$counter] = $row;
                        $counter++;
                    }
                    
                    //Creates posts in reverse order so most recent post is on top
                    for($i = count($posts) -1; $i >= 0; $i--) {
                        
                        //Makes sure post is owned by user
                        if(mysqli_real_escape_string($conn, $posts[$i]['userid']) == $_SESSION['userid']) {

                           //Creates posts with sanitized data from database
                            createCardDelete(
                                mysqli_real_escape_string($conn, $posts[$i]['title']),
                                mysqli_real_escape_string($conn, $posts[$i]['bodyText']), 
                                mysqli_real_escape_string($conn, $posts[$i]['link']), 
                                mysqli_real_escape_string($conn, $posts[$i]['email']), 
                                mysqli_real_escape_string($conn, $posts[$i]['id'])
                            );
                        }
                    }
                ?>
            </div>

            <!-- Comments Section -->
            <div class="tab-pane fade" id="comments" role="tabpanel">
                <h1>All Comments</h1>
                <?php
                    $query = 'SELECT * FROM comments WHERE userId='.$_SESSION['userid'];
                    $result = mysqli_query($conn, $query);
                    $comments = array();
                    $counter = 0;

                    //Fills comments array with data from the database
                    while($row = mysqli_fetch_array($result)) {
                        $comments[$counter] = $row;
                        $counter++;
                    }

                    //Creates comments in reverse order so most recent comment is on top
                    for($i = count($comments) -1; $i >= 0; $i--) {

                        //Creates comments with sanitized data from database
                        createCommentGoTo(
                            mysqli_real_escape_string($conn, $comments[$i]['comment']), 
                            mysqli_real_escape_string($conn, $comments[$i]['email']), 
                            mysqli_real_escape_string($conn, $comments[$i]['postId'])
                        );
                    }
                ?>
            </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap Scripts -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>

</body>
</html>
<?php
    //Function to create story card
    function createCard($title, $bodyText, $link, $user, $id) {
        echo '<div class="card col-md-12 border-dark mb-3" style="margin-bottom: 20px;">';
        echo '<div class="card-body">';
        echo '<h5 style="display: inline;" class="card-title">'.$title.' - By: '.$user.'</h5>';
        echo '<hr>';
        echo '<p class="card-text">'.$bodyText.'</p>';
        if(isset($link) && $link != "") {
            echo '<hr>';
            echo '<a href="'.$link.'" style="float: left; margin-right: 20px;" target="_blank" class="card-link">Link</a>';
        }
        echo '<form action="post.php" method="GET">';
        echo '<button class="btn btn-primary" type="submit" name="post" value="'.$id.'">Go To Post</button>';
        echo '</form>';
        echo '</div>';
        echo '</div>';
    }

    //Creates comment card with go to post button
    function createCommentGoTo($comment, $user, $postId) {
        echo '<div class="card col-md-12 border-dark mb-3" style="margin-bottom: 20px;">';
        echo '<div class="card-body">';
        echo '<p class="card-text">'.$user.' - '.$comment.'</p>';
        echo '<form action="post.php" method="GET">';
        echo '<button class="btn btn-primary" type="submit" name="post" value="'.$postId.'">Go To Post</button>';
        echo '</form>';
        echo '</div>';
        echo '</div>';
    }

    //Creates post card with delete button
    function createCardDelete($title, $bodyText, $link, $user, $id) {
        echo '<div class="card col-md-12 border-dark mb-3" style="margin-bottom: 20px;">';
        echo '<div class="card-body">';
        echo '<h5 style="display: inline;" class="card-title">'.$title.' - By: '.$user.'</h5>';
        echo '<hr>';
        echo '<p class="card-text">'.$bodyText.'</p>';
        if(isset($link) && $link != "") {
            echo '<hr>';
            echo '<a href="'.$link.'" style="float: left; margin-right: 20px;" target="_blank" class="card-link">Link</a>';
        }
        echo '<form action="post.php" method="GET">';
        echo '<button class="btn btn-primary" type="submit" name="post" value="'.$id.'">Go To Post</button>';
        echo '</form>';
        echo '<form action="deletePost.php" method="POST">';
        //CSRF Token
        echo '<input type="hidden" name="token" value="'.$_SESSION['token'].'"/>';
        echo '<input type="hidden" name="post_id" value="'.$id.'"/>';
        echo '<button class="btn btn-warning" type="submit" >Delete</button>';
        echo '<input name="edit" type="hidden" value="true">';
        echo '</form>';
        echo '</div>';
        echo '</div>';
    }

?>