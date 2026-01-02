#!/bin/bash

# Jenkins Deployment Setup Script
# This script helps configure Jenkins for deploying public and private repositories

set -e

echo "======================================"
echo "Jenkins Deployment Configuration Setup"
echo "======================================"
echo ""

# Function to display usage
usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -t, --type TYPE         Repository type (public/private)"
    echo "  -u, --url URL           Git repository URL"
    echo "  -b, --branch BRANCH     Git branch (default: main)"
    echo "  -e, --env ENV           Environment (staging/production)"
    echo "  -c, --creds CRED_ID     Jenkins credentials ID (required for private repos)"
    echo ""
    echo "Example:"
    echo "  $0 --type public --url https://github.com/user/repo.git --branch main --env staging"
    echo "  $0 --type private --url https://github.com/user/repo.git --creds github-creds --env production"
    exit 1
}

# Default values
REPO_TYPE=""
GIT_URL=""
BRANCH="main"
ENVIRONMENT="staging"
CREDENTIALS=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -t|--type)
            REPO_TYPE="$2"
            shift 2
            ;;
        -u|--url)
            GIT_URL="$2"
            shift 2
            ;;
        -b|--branch)
            BRANCH="$2"
            shift 2
            ;;
        -e|--env)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -c|--creds)
            CREDENTIALS="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate required parameters
if [[ -z "$REPO_TYPE" ]] || [[ -z "$GIT_URL" ]]; then
    echo "Error: Repository type and URL are required"
    usage
fi

# Validate repository type
if [[ "$REPO_TYPE" != "public" ]] && [[ "$REPO_TYPE" != "private" ]]; then
    echo "Error: Repository type must be 'public' or 'private'"
    exit 1
fi

# Validate credentials for private repos
if [[ "$REPO_TYPE" == "private" ]] && [[ -z "$CREDENTIALS" ]]; then
    echo "Error: Credentials ID is required for private repositories"
    exit 1
fi

# Display configuration
echo "Configuration Summary:"
echo "----------------------"
echo "Repository Type: $REPO_TYPE"
echo "Git URL: $GIT_URL"
echo "Branch: $BRANCH"
echo "Environment: $ENVIRONMENT"
if [[ "$REPO_TYPE" == "private" ]]; then
    echo "Credentials ID: $CREDENTIALS"
fi
echo ""

# Generate Jenkins job configuration XML
echo "Generating Jenkins job configuration..."

cat > jenkins-job-config.xml << EOF
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job@2.40">
  <description>Deployment pipeline for $REPO_TYPE repository</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <hudson.model.ParametersDefinitionProperty>
      <parameterDefinitions>
        <hudson.model.ChoiceParameterDefinition>
          <name>REPO_TYPE</name>
          <description>Repository type</description>
          <choices class="java.util.Arrays\$ArrayList">
            <a class="string-array">
              <string>$REPO_TYPE</string>
            </a>
          </choices>
        </hudson.model.ChoiceParameterDefinition>
        <hudson.model.StringParameterDefinition>
          <name>GIT_REPO_URL</name>
          <description>Git repository URL</description>
          <defaultValue>$GIT_URL</defaultValue>
        </hudson.model.StringParameterDefinition>
        <hudson.model.StringParameterDefinition>
          <name>GIT_BRANCH</name>
          <description>Git branch to deploy</description>
          <defaultValue>$BRANCH</defaultValue>
        </hudson.model.StringParameterDefinition>
        <hudson.model.StringParameterDefinition>
          <name>DEPLOY_ENV</name>
          <description>Deployment environment</description>
          <defaultValue>$ENVIRONMENT</defaultValue>
        </hudson.model.StringParameterDefinition>
      </parameterDefinitions>
    </hudson.model.ParametersDefinitionProperty>
  </properties>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@2.87">
    <scm class="hudson.plugins.git.GitSCM" plugin="git@4.7.1">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>$GIT_URL</url>
EOF

if [[ "$REPO_TYPE" == "private" ]]; then
    cat >> jenkins-job-config.xml << EOF
          <credentialsId>$CREDENTIALS</credentialsId>
EOF
fi

cat >> jenkins-job-config.xml << EOF
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/$BRANCH</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
    </scm>
    <scriptPath>Jenkinsfile</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
EOF

echo "✓ Jenkins job configuration saved to: jenkins-job-config.xml"
echo ""
echo "Next Steps:"
echo "1. Create a new Pipeline job in Jenkins"
echo "2. Use the generated jenkins-job-config.xml to configure the job"
echo "3. Or manually configure the job with the parameters shown above"
echo "4. Run the pipeline to deploy your application"
echo ""
echo "Setup complete!"
