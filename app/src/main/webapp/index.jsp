<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>CI/CD Expertise - Abayomi</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #0f2027, #203a43, #2c5364);
            color: #fff;
            text-align: center;
            padding: 50px;
        }
        h1 {
            font-size: 3em;
            margin-bottom: 20px;
            color: #00d8ff;
        }
        .tools {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-top: 40px;
            flex-wrap: wrap;
        }
        .tool {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px 30px;
            border-radius: 12px;
            font-size: 1.5em;
            box-shadow: 0 0 10px rgba(0,0,0,0.5);
            transition: transform 0.3s ease;
        }
        .tool:hover {
            transform: scale(1.1);
            background: rgba(255, 255, 255, 0.2);
        }
        footer {
            margin-top: 60px;
            font-size: 1em;
            color: #aaa;
        }
    </style>
</head>
<body>
    <h1>CI/CD Expertise Showcase</h1>
    <div class="tools">
        <div class="tool">Jenkins</div>
        <div class="tool">ArgoCD</div>
        <div class="tool">AWS EKS</div>
        <div class="tool">Terraform</div>
    </div>
    <footer>
        Deployed via CI/CD Pipeline | Powered by Jenkins + ArgoCD
    </footer>
</body>
</html>
