<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quiz App - Login</title>
<style>
    body { font-family: Arial, sans-serif; display: grid; place-items: center; min-height: 80vh; background-color: #f4f4f4; }
    form { background: #fff; border: 1px solid #ccc; padding: 25px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    div { margin-bottom: 15px; }
    label { display: block; margin-bottom: 5px; font-weight: bold; }
    input[type="text"], input[type="password"] { width: 300px; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
    input[type="submit"] { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
    input[type="submit"]:hover { background-color: #0056b3; }
    h2 { text-align: center; }
</style>
</head>
<body>

    <form action="login" method="post">
        <h2>Quiz App Login</h2>
        <div>
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div>
            <input type="submit" value="Login">
        </div>
    </form>

</body>
</html>