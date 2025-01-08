# uwgda-image-living - GDA Docker Environment

This repository contains the configuration for building the GDA Docker environment. The image is automatically built and published to GitHub Container Registry when changes are made to the environment configuration.

## Image Location
The Docker image is published to: `ghcr.io/UW-GDA/uwgda-image-living`

## Usage
To use this image:

```bash
docker pull ghcr.io/uw-gda/uwgda-image-living:latest
```

## Modifying the Environment
1. Update `environment.yml` to add/remove conda packages
2. Update `apt.txt` to add/remove system packages
3. Commit and push changes to main branch
4. GitHub Actions will automatically build and publish a new image
