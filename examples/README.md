# Jenkins Deployment Examples

This directory contains example Jenkinsfiles for common deployment scenarios with both public and private repositories.

## Available Examples

### 1. Node.js Public Repository (`Jenkinsfile.nodejs-public`)

Deploy a Node.js application from a public GitHub repository.

**Features:**
- Checkout from public repository
- Install npm dependencies
- Build the application
- Run tests
- Deploy the application

**Usage:**
```bash
# Use this Jenkinsfile for public Node.js projects
# No credentials required
```

### 2. Python Private Repository (`Jenkinsfile.python-private`)

Deploy a Python application from a private GitHub repository with credentials.

**Features:**
- Checkout from private repository using credentials
- Setup Python virtual environment
- Install requirements
- Run pytest tests
- Deploy to staging or production

**Usage:**
```bash
# Configure Jenkins credentials first
# Use credential ID: github-creds
# Select environment: staging or production
```

### 3. Docker Public Repository (`Jenkinsfile.docker-public`)

Build and deploy a Docker application from a public repository.

**Features:**
- Checkout from public repository
- Build Docker image
- Test Docker image
- Push to Docker registry
- Deploy container

**Usage:**
```bash
# Ensure Docker is installed on Jenkins agent
# Configure Docker registry credentials if needed
```

## How to Use These Examples

### Step 1: Choose the Right Example

Select the example that matches your project type and repository visibility:
- Public repository → Use examples without credentials
- Private repository → Use examples with credentials parameter

### Step 2: Copy to Your Project

Copy the relevant Jenkinsfile to your project repository:

```bash
cp examples/Jenkinsfile.nodejs-public /path/to/your/project/Jenkinsfile
```

### Step 3: Customize for Your Project

Edit the Jenkinsfile to match your project requirements:
- Update default parameter values
- Modify build commands
- Add or remove stages
- Configure deployment steps

### Step 4: Configure Jenkins Job

1. Create new Pipeline job in Jenkins
2. Configure it to use the Jenkinsfile from your repository
3. Set up credentials (if using private repository)
4. Run the pipeline

## Common Customizations

### Adding Environment Variables

```groovy
environment {
    NODE_ENV = 'production'
    API_URL = 'https://api.example.com'
}
```

### Adding Notifications

```groovy
post {
    success {
        emailext (
            subject: "Deployment Successful",
            body: "The deployment completed successfully",
            to: "team@example.com"
        )
    }
}
```

### Adding Approval Steps

```groovy
stage('Approve Deployment') {
    steps {
        input message: 'Deploy to production?', ok: 'Deploy'
    }
}
```

### Using SSH Keys Instead of Username/Password

```groovy
checkout([
    $class: 'GitSCM',
    branches: [[name: "*/${params.GIT_BRANCH}"]],
    userRemoteConfigs: [[
        url: params.GIT_REPO_URL,
        credentialsId: 'ssh-key-credential-id'  // Use SSH key credential
    ]]
])
```

## Best Practices

1. **Always use credentials manager** for sensitive data
2. **Clean workspace** after each build (`cleanWs()`)
3. **Use parameterized builds** for flexibility
4. **Add proper error handling** in scripts
5. **Include notifications** for build status
6. **Test in staging** before deploying to production
7. **Use version tags** for Docker images
8. **Keep credentials secure** - never hardcode them

## Troubleshooting

### Common Issues

**Issue: Permission denied when accessing repository**
- Solution: Check that credentials are properly configured in Jenkins
- Verify that the credential ID matches what's used in the Jenkinsfile

**Issue: Build fails at dependency installation**
- Solution: Ensure the build agent has the required runtime (Node.js, Python, etc.)
- Check that package manager is installed on the agent

**Issue: Docker commands not found**
- Solution: Install Docker on the Jenkins agent
- Add Jenkins user to the docker group: `sudo usermod -aG docker jenkins`

## Additional Resources

- [Jenkins Pipeline Documentation](https://www.jenkins.io/doc/book/pipeline/)
- [Jenkins Credentials Plugin](https://plugins.jenkins.io/credentials/)
- [Git Plugin Documentation](https://plugins.jenkins.io/git/)

## Contributing

Feel free to add more examples for other languages and frameworks!
