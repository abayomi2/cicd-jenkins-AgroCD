<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>CI/CD Expertise</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #0f2027;  /* dark gradient */
            background: linear-gradient(to right, #2c5364, #203a43, #0f2027);
            color: #fff;
            margin: 0;
            padding: 2rem;
        }
        .title {
            background: #1f4037;
            background: linear-gradient(to right, #76b852, #8DC26F);
            color: white;
            padding: 1rem;
            border-radius: 10px;
            text-align: center;
            font-size: 2rem;
            margin-bottom: 2rem;
        }
        .tool {
            margin-bottom: 2rem;
            padding: 1rem;
            border-left: 5px solid #fff;
            background-color: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
        }
        .jenkins { border-color: #d33833; }
        .argocd { border-color: #00bfff; }
        .eks     { border-color: #ffcc00; }
        .terraform { border-color: #844fba; }

        h2 {
            margin: 0 0 0.5rem;
        }

        .desc {
            font-size: 1rem;
            color: #e0e0e0;
        }
    </style>
</head>
<body>

    <div class="title">�� CI/CD EXPERTISE HIGHLIGHT 🌟</div>

    <div class="tool jenkins">
        <h2>🔧 Jenkins</h2>
        <p class="desc">Automates build, test, and deployment workflows<br>
        Integrated with GitHub and SonarQube for full lifecycle management</p>
    </div>

    <div class="tool argocd">
        <h2>🚀 ArgoCD</h2>
        <p class="desc">Declarative GitOps continuous delivery for Kubernetes<br>
        Real-time synchronization and automated deployment of manifests</p>
    </div>

    <div class="tool eks">
        <h2>☁️ AWS EKS</h2>
        <p class="desc">Secure, scalable Kubernetes clusters in the cloud<br>
        Managed control plane, node groups, and IAM integration</p>
    </div>

    <div class="tool terraform">
        <h2>�� Terraform</h2>
        <p class="desc">Infrastructure as Code (IaC) to provision cloud resources<br>
        Modular, reusable templates for multi-environment setup</p>
    </div>

</body>
</html>
