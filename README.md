# Jenkins Deploy

A Jenkins pipeline configuration for deploying applications from both public and private Git repositories.

## Features

- 🔓 **Public Repository Support**: Deploy from publicly accessible Git repositories
- 🔐 **Private Repository Support**: Deploy from private repositories using secure credentials
- 🚀 **Multiple Environments**: Support for staging and production deployments
- 📦 **Flexible Configuration**: Parameterized builds for different deployment scenarios
- 🔄 **Multi-Repository Deployment**: Deploy multiple repositories in a single pipeline

## Quick Start

### Prerequisites

- Jenkins server (2.x or higher)
- Git plugin installed in Jenkins
- Credentials plugin for private repository access

### Basic Usage

1. **Create a new Jenkins Pipeline job**
2. **Configure the pipeline to use the Jenkinsfile from this repository**
3. **Set up required parameters** (see Configuration section below)

## Configuration

### Jenkinsfile Parameters

The main `Jenkinsfile` accepts the following parameters:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `REPO_TYPE` | Choice | `public` | Repository type (`public` or `private`) |
| `GIT_REPO_URL` | String | - | Git repository URL |
| `GIT_BRANCH` | String | `main` | Git branch to deploy |
| `GIT_CREDENTIALS` | Credentials | - | Credentials ID for private repos (required only for private) |
| `DEPLOY_ENV` | String | `staging` | Deployment environment (`staging` or `production`) |

### Setting Up Credentials for Private Repositories

1. **Go to Jenkins Dashboard** → **Manage Jenkins** → **Manage Credentials**
2. **Add new credentials**:
   - Kind: Username with password
   - Username: Your Git username
   - Password: Your Git personal access token or password
   - ID: A meaningful identifier (e.g., `github-creds`)
3. **Use the credential ID** in the `GIT_CREDENTIALS` parameter

## Usage Examples

### Example 1: Deploy from Public Repository

```groovy
// Pipeline parameters:
REPO_TYPE: public
GIT_REPO_URL: https://github.com/username/public-repo.git
GIT_BRANCH: main
DEPLOY_ENV: staging
```

### Example 2: Deploy from Private Repository

```groovy
// Pipeline parameters:
REPO_TYPE: private
GIT_REPO_URL: https://github.com/username/private-repo.git
GIT_BRANCH: main
GIT_CREDENTIALS: github-creds
DEPLOY_ENV: production
```

### Example 3: Multi-Repository Deployment

Use the `Jenkinsfile.multi` for deploying multiple repositories:

```bash
# This pipeline deploys multiple public and private repositories
# Configure the repository list in the Jenkinsfile.multi
```

## Pipeline Stages

The deployment pipeline consists of the following stages:

1. **Checkout**: Clones the repository (with or without credentials)
2. **Build**: Builds the application
3. **Test**: Runs automated tests
4. **Deploy**: Deploys to the specified environment

## Customization

### Adding Build Commands

Edit the `Build` stage in the Jenkinsfile:

```groovy
stage('Build') {
    steps {
        script {
            // Add your build commands
            sh 'npm install'
            sh 'npm run build'
            // or
            sh 'mvn clean package'
            // or
            sh 'docker build -t myapp:latest .'
        }
    }
}
```

### Adding Test Commands

Edit the `Test` stage in the Jenkinsfile:

```groovy
stage('Test') {
    steps {
        script {
            // Add your test commands
            sh 'npm test'
            // or
            sh 'mvn test'
            // or
            sh 'pytest'
        }
    }
}
```

### Adding Deployment Commands

Edit the `Deploy` stage in the Jenkinsfile:

```groovy
stage('Deploy') {
    steps {
        script {
            if (params.DEPLOY_ENV == 'production') {
                // Production deployment commands
                sh 'kubectl apply -f k8s/production/'
            } else {
                // Staging deployment commands
                sh 'kubectl apply -f k8s/staging/'
            }
        }
    }
}
```

## Configuration File

The `deployment-config.yml` file provides example configurations for different deployment scenarios. You can customize this file to match your deployment requirements.

## Security Best Practices

- ✅ **Never commit credentials** to the repository
- ✅ **Use Jenkins credentials manager** for sensitive data
- ✅ **Use personal access tokens** instead of passwords
- ✅ **Limit credential scope** to only what's needed
- ✅ **Regularly rotate credentials**
- ✅ **Use SSH keys** when possible instead of passwords

## Troubleshooting

### Issue: "Credentials required for private repository"

**Solution**: Ensure you've provided a valid `GIT_CREDENTIALS` parameter when deploying private repositories.

### Issue: Authentication failed

**Solution**: Verify that:
- The credentials ID is correct
- The personal access token has the required permissions
- The repository URL is correct

### Issue: Branch not found

**Solution**: Check that the specified branch exists in the repository.

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is open source and available under the MIT License.
