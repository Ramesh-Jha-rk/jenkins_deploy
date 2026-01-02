# Quick Start Guide

## 5-Minute Setup for Jenkins Deployments

### For Public Repositories

1. **Create Jenkins Pipeline Job**
   - Jenkins Dashboard → New Item → Pipeline
   - Name: "deploy-public-repo"

2. **Configure Pipeline**
   - Definition: Pipeline script from SCM
   - SCM: Git
   - Repository URL: `https://github.com/Ramesh-Jha-rk/jenkins_deploy.git`
   - Script Path: `Jenkinsfile`

3. **Run with Parameters**
   ```
   REPO_TYPE: public
   GIT_REPO_URL: https://github.com/your-username/your-repo.git
   GIT_BRANCH: main
   DEPLOY_ENV: staging
   ```

### For Private Repositories

1. **Add Credentials to Jenkins**
   - Manage Jenkins → Manage Credentials
   - Add Credentials → Username with password
   - Username: Your GitHub username
   - Password: Personal Access Token
   - ID: `github-creds`

2. **Create Jenkins Pipeline Job**
   - Same as public repository setup

3. **Run with Parameters**
   ```
   REPO_TYPE: private
   GIT_REPO_URL: https://github.com/your-username/private-repo.git
   GIT_BRANCH: main
   GIT_CREDENTIALS: github-creds
   DEPLOY_ENV: staging
   ```

## Using the Setup Script

### Generate Jenkins Job Configuration Automatically

**For Public Repo:**
```bash
./setup-jenkins-deployment.sh \
  --type public \
  --url https://github.com/user/repo.git \
  --branch main \
  --env staging
```

**For Private Repo:**
```bash
./setup-jenkins-deployment.sh \
  --type private \
  --url https://github.com/user/private-repo.git \
  --branch main \
  --creds github-creds \
  --env production
```

This generates `jenkins-job-config.xml` that you can import into Jenkins.

## Using Example Jenkinsfiles

Copy the appropriate example to your project:

**Node.js Public Project:**
```bash
cp examples/Jenkinsfile.nodejs-public /path/to/your/project/Jenkinsfile
```

**Python Private Project:**
```bash
cp examples/Jenkinsfile.python-private /path/to/your/project/Jenkinsfile
```

**Docker Public Project:**
```bash
cp examples/Jenkinsfile.docker-public /path/to/your/project/Jenkinsfile
```

## Creating GitHub Personal Access Token

1. GitHub Settings → Developer settings → Personal access tokens
2. Generate new token (classic)
3. Select scopes: `repo` (all), `workflow`
4. Copy the token (you won't see it again!)
5. Use this token as password in Jenkins credentials

## Common Issues

**Error: "Credentials required for private repository"**
- Solution: Provide the GIT_CREDENTIALS parameter

**Error: "Authentication failed"**
- Solution: Verify credentials are correct and have proper permissions

**Error: "Branch not found"**
- Solution: Check branch name is correct (case-sensitive)

## Next Steps

1. Customize the Build, Test, and Deploy stages for your application
2. Add environment-specific configuration
3. Set up notifications (email, Slack, etc.)
4. Configure automated triggers (webhooks, schedules)

For detailed documentation, see [README.md](README.md).
