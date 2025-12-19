# rexbut Docker Images 🐳

Collection d'images Docker personnalisées pour l'infrastructure rexbut, construites automatiquement via GitHub Actions et hébergées sur GitHub Container Registry.

## 🚀 Démarrage rapide

### Installation des images

```bash
# Home Assistant avec version spécifique (recommandé)
docker pull ghcr.io/<votre-org>/homeassistant:2025.9

# Kubectl + Helm avec versions spécifiques
docker pull ghcr.io/<votre-org>/kubectl-helm:k8s-1.27.1-helm-3.11.3

# Ubuntu base avec traçabilité
docker pull ghcr.io/<votre-org>/ubuntu:latest
```

### Utilisation rapide

```bash
# Copier l'exemple de configuration
cp docker-compose.example.yml docker-compose.yml

# Modifier VOTRE_ORG dans le fichier
sed -i 's/VOTRE_ORG/votre-organisation/g' docker-compose.yml

# Lancer les services
docker-compose up -d
```

## 📦 Images disponibles

| Image | Description | Tag recommandé |
|-------|-------------|----------------|
| **ubuntu** | Ubuntu 22.04 base avec outils | `build-<id>` ou `latest` |
| **kubectl-helm** | Kubernetes CLI + Helm | `k8s-1.27.1-helm-3.11.3` |
| **network-ups-tools** | Gestion d'onduleurs UPS | `latest` |
| **homeassistant** | Home Assistant personnalisé | `2025.9` |

## 🏷️ Stratégie de tags

Chaque image utilise plusieurs tags pour différents cas d'usage :

### Home Assistant
```bash
ghcr.io/<org>/homeassistant:2025.9          # ✅ Production (version fixe)
ghcr.io/<org>/homeassistant:main            # 🔧 Dev (branche main)
ghcr.io/<org>/homeassistant:latest          # ⚠️  Tests uniquement
```

### Ubuntu
```bash
ghcr.io/<org>/ubuntu:build-123456789        # ✅ Production (ID pipeline)
ghcr.io/<org>/ubuntu:20231220-a1b2c3d4      # ✅ Production (date-commit)
ghcr.io/<org>/ubuntu:main                   # 🔧 Dev
ghcr.io/<org>/ubuntu:latest                 # ⚠️  Tests
```

### Kubectl-Helm
```bash
ghcr.io/<org>/kubectl-helm:k8s-1.27.1-helm-3.11.3  # ✅ Production
ghcr.io/<org>/kubectl-helm:main                     # 🔧 Dev
```

📖 **[Guide complet des tags](TAGS_GUIDE.md)**

## 📚 Documentation

- **[DOCKER_IMAGES.md](DOCKER_IMAGES.md)** - Documentation complète des images
- **[TAGS_GUIDE.md](TAGS_GUIDE.md)** - Guide détaillé du système de tags
- **[docker-compose.example.yml](docker-compose.example.yml)** - Exemple d'utilisation

## 🛠️ Développement

### Construire localement

```bash
# Script helper (recommandé)
chmod +x manage-images.sh
./manage-images.sh build ubuntu
./manage-images.sh build kubectl-helm

# Ou manuellement
docker build -t ubuntu-local ./ubuntu
```

### Tester les modifications

```bash
# Build toutes les images
./manage-images.sh build all

# Lister les images disponibles
./manage-images.sh list
```

## 🔐 Authentification

### Images publiques
Aucune authentification nécessaire.

### Images privées
```bash
# Avec Personal Access Token (PAT)
echo $GITHUB_PAT | docker login ghcr.io -u USERNAME --password-stdin

# Ou avec GitHub Token en CI
echo ${{ secrets.GITHUB_TOKEN }} | docker login ghcr.io -u ${{ github.actor }} --password-stdin
```

## 🔧 Configuration

### Modifier les versions

#### Home Assistant
Éditez `.github/workflows/docker-build.yml` :
```yaml
env:
  HOMEASSISTANT_VERSION: "2025.10"  # ← Nouvelle version
```

#### Kubectl/Helm
```yaml
- name: Extract metadata
  run: |
    echo "kube_version=1.28.0" >> $GITHUB_OUTPUT
    echo "helm_version=3.12.0" >> $GITHUB_OUTPUT
```

## 🚀 CI/CD

Le workflow GitHub Actions build et publie automatiquement les images :

### Déclencheurs
- ✅ Push sur n'importe quelle branche
- ✅ Déclenchement manuel (`workflow_dispatch`)

### Processus
1. Build `ubuntu` (image de base)
2. Build `kubectl-helm` et `network-ups-tools` (dépendent de ubuntu)
3. Build `homeassistant` (indépendant)
4. Publication sur ghcr.io avec tags multiples

### Visualiser les builds
```
https://github.com/<org>/<repo>/actions
```

## 📊 Architecture

```
┌─────────────────────────────────────────┐
│         GitHub Container Registry       │
│              (ghcr.io)                  │
└─────────────────────────────────────────┘
                    ▲
                    │
        ┌───────────┴───────────┐
        │   GitHub Actions      │
        │   (ARM64 builds)      │
        └───────────┬───────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
   ┌────▼────┐           ┌─────▼──────┐
   │ ubuntu  │           │homeassistant│
   └────┬────┘           └────────────┘
        │
   ┌────┴─────────────┐
   │                  │
┌──▼──────────┐  ┌───▼─────────────┐
│kubectl-helm │  │network-ups-tools│
└─────────────┘  └─────────────────┘
```

## 🤝 Contribution

1. Créer une branche feature
2. Modifier les Dockerfiles
3. Les images sont automatiquement buildées
4. Tester avec `ghcr.io/<org>/<image>:<votre-branche>`
5. Créer une Pull Request

## 📝 Exemples d'utilisation

### Docker Compose
```yaml
services:
  homeassistant:
    image: ghcr.io/rexbut/homeassistant:2025.9
    ports:
      - "8123:8123"
    volumes:
      - ./config:/config
```

### Kubernetes
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubectl-helm
spec:
  template:
    spec:
      containers:
      - name: kubectl
        image: ghcr.io/rexbut/kubectl-helm:k8s-1.27.1-helm-3.11.3
```

### Script bash
```bash
#!/bin/bash
docker run --rm \
  ghcr.io/rexbut/kubectl-helm:k8s-1.27.1-helm-3.11.3 \
  kubectl get pods
```

## 🐛 Résolution de problèmes

### Erreur d'authentification
```bash
# Vérifier la connexion
docker login ghcr.io -u USERNAME

# Vérifier les permissions du token
# Le PAT doit avoir le scope: read:packages, write:packages
```

### Image non trouvée
```bash
# Vérifier que l'image existe
docker pull ghcr.io/<org>/<image>:<tag>

# Lister les tags disponibles sur GitHub
# https://github.com/<org>/<repo>/packages
```

### Build échoué
```bash
# Vérifier les logs GitHub Actions
# https://github.com/<org>/<repo>/actions

# Tester localement
./manage-images.sh build <image-name>
```

