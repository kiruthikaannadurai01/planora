# 🧱 Multi-Architecture DevOps Project

A comprehensive Docker and Kubernetes deployment project supporting multiple architectures (AMD64, ARM64).

## 📊 Architecture Overview

```
User → Frontend (Nginx) → Backend API (Node.js) → Database (PostgreSQL)
          ↓
   Docker Multi-Arch Images
          ↓
   Kubernetes Orchestration
```

## 📁 Project Structure

```
multi-arch-devops-project/
│
├── frontend/
│   ├── Dockerfile
│   └── index.html
│
├── backend/
│   ├── Dockerfile
│   ├── app.js
│   └── package.json
│
├── docker-compose.yml
│
├── k8s/
│   ├── frontend-deployment.yaml
│   ├── backend-deployment.yaml
│   ├── database.yaml
│   └── services.yaml
│
├── scripts/
│   ├── build-multiarch.sh
│   ├── build-local.sh
│   └── deploy-k8s.sh
│
└── README.md
```

## 🚀 Quick Start

### Local Development with Docker Compose

#### Prerequisites
- Docker & Docker Compose installed
- Git

#### Steps

1. **Clone/Navigate to project:**
   ```bash
   cd d:\app
   ```

2. **Build and start services:**
   ```bash
   docker-compose up --build
   ```

3. **Access services:**
   - Frontend: http://localhost:8080
   - Backend: http://localhost:3000
   - PostgreSQL: localhost:5432

4. **Stop services:**
   ```bash
   docker-compose down
   ```

### Multi-Architecture Docker Build

#### Prerequisites
- Docker with buildx support
- Docker Hub account (or private registry)

#### Steps

1. **Set your Docker Hub username:**
   ```bash
   export DOCKER_HUB_USER="yourusername"
   ```

2. **Make build script executable:**
   ```bash
   chmod +x scripts/build-multiarch.sh
   ```

3. **Run multi-arch build:**
   ```bash
   ./scripts/build-multiarch.sh
   ```

   This builds for:
   - `linux/amd64` (Intel/AMD 64-bit)
   - `linux/arm64` (ARM 64-bit - Raspberry Pi, Apple Silicon, AWS Graviton)

### Kubernetes Deployment

#### Prerequisites
- Kubernetes cluster (Minikube, K3s, Kind, or managed K8s)
- kubectl configured

#### Setup Kubernetes

**Option 1: Minikube (easiest for local)**
```bash
minikube start
```

**Option 2: K3s (lightweight)**
```bash
curl -sfL https://get.k3s.io | sh -
```

**Option 3: Kind (Docker-based)**
```bash
kind create cluster --name devops
```

#### Deploy to Kubernetes

1. **Update image references in k8s/ files** (replace `yourdockerhub` with your registry):
   ```bash
   sed -i 's/yourdockerhub/your-username/g' k8s/*.yaml
   ```

2. **Deploy using script:**
   ```bash
   chmod +x scripts/deploy-k8s.sh
   ./scripts/deploy-k8s.sh
   ```

   Or manually:
   ```bash
   kubectl apply -f k8s/
   ```

3. **Check deployment:**
   ```bash
   kubectl get pods
   kubectl get services
   ```

4. **Access services** (with Minikube):
   ```bash
   # Frontend
   minikube service frontend-service
   
   # Backend
   minikube service backend-service
   ```

## 🔧 Components

### Frontend
- **Tech:** Nginx
- **Port:** 80 (container) → 8080 (docker-compose) / 30008 (K8s)
- **Features:** Static HTML served via Nginx

### Backend
- **Tech:** Node.js + Express
- **Port:** 3000
- **Endpoint:** GET / → "Hello from Backend 🚀"

### Database
- **Tech:** PostgreSQL 13
- **Port:** 5432
- **Credentials:** postgres/example

## 📦 Docker Compose Commands

```bash
# Build images
docker-compose build

# Start services
docker-compose up

# Start in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Remove volumes
docker-compose down -v
```

## ☸️ Kubernetes Commands

```bash
# Apply all manifests
kubectl apply -f k8s/

# Check deployments
kubectl get deployments
kubectl get pods
kubectl get services

# View logs
kubectl logs <pod-name>

# Port forward to access services
kubectl port-forward svc/frontend-service 8080:80
kubectl port-forward svc/backend-service 3000:3000

# Delete deployment
kubectl delete -f k8s/

# Get detailed info
kubectl describe pod <pod-name>
kubectl describe deployment <deployment-name>
```

## 🏗️ Architecture Details

### Multi-Architecture Support

The project supports building for multiple CPU architectures:

- **AMD64**: Standard Intel/AMD 64-bit processors (servers, desktops)
- **ARM64**: Apple Silicon, Raspberry Pi 4+, AWS Graviton, etc.

Benefits:
- ✅ Run on any hardware
- ✅ Better performance on native architecture
- ✅ Cost savings with ARM-based instances

### Kubernetes Replicas

- **Frontend:** 2 replicas
- **Backend:** 2 replicas
- **Database:** 1 replica (stateful)

### Service Types

- **Frontend Service:** NodePort (port 30008)
- **Backend Service:** NodePort (port 30007)
- **Database Service:** ClusterIP (internal only)

## 🔐 Security Considerations

For production:

1. **Secrets Management**
   ```bash
   kubectl create secret generic db-password --from-literal=password=secure-password
   ```

2. **Resource Limits** (already configured in deployments)

3. **Network Policies**
   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: backend-policy
   spec:
     podSelector:
       matchLabels:
         app: backend
     ingress:
       - from:
           - podSelector:
               matchLabels:
                 app: frontend
   ```

4. **Image Scanning**
   - Use private registries
   - Scan images for vulnerabilities
   - Keep base images updated

## 🛠️ Troubleshooting

### Docker Issues

**Container won't start:**
```bash
docker-compose logs backend
docker inspect <container-id>
```

**Port conflicts:**
```bash
# Change port in docker-compose.yml
# Free up ports on host
```

### Kubernetes Issues

**Pod stuck in pending:**
```bash
kubectl describe pod <pod-name>
# Check resource requests vs available resources
```

**Service not accessible:**
```bash
kubectl get svc
kubectl port-forward svc/frontend-service 8080:80
```

**Image pull errors:**
```bash
# Use local images or ensure registry credentials
kubectl create secret docker-registry regcred \
  --docker-server=<registry> \
  --docker-username=<user> \
  --docker-password=<password>
```

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com)
- [Docker Buildx Documentation](https://docs.docker.com/build/architecture/)
- [Kubernetes Documentation](https://kubernetes.io/docs)
- [Minikube Guide](https://minikube.sigs.k8s.io/)

## 📝 License

MIT License

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

---

**Last Updated:** April 28, 2026
