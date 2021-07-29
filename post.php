<html>
<head>
        <title>Post Processing Page</title>
</head>
<body>
<h2>You Sent:</h2>
<table>
<?php 


    foreach ($_POST as $key => $value) {
        echo "<tr>";
        echo "<td><b>";
        echo $key;
        echo "</b></td>";
        echo "<td>";
        echo $value;
        echo "</td>";
        echo "</tr>";
        }


?>
</table>
</body>
</html>
     