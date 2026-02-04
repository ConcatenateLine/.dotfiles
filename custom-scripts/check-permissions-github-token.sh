#!/bin/bash

# GitHub Repository Permission Tester
# Usage: ./test_github_permissions.sh <github-username> <github-token> <repo-name>

# Check if required arguments are provided
if [ $# -ne 3 ]; then
    echo "Error: Missing required arguments"
    echo "Usage: $0 <github-username> <github-token> <repo-name>"
    exit 1
fi

# Set variables from command line arguments
GITHUB_USERNAME="$1"
GITHUB_TOKEN="$2"
REPO_NAME="$3"
API_URL="https://api.github.com/repos/$GITHUB_USERNAME/$REPO_NAME"

echo "🔍 Testing GitHub repository permissions..."
echo "Repository: $GITHUB_USERNAME/$REPO_NAME"
echo ""

# Function to make API requests with error handling
make_request() {
    local method="$1"
    local endpoint="$2"
    local data="$3"
    
    local response
    local status_code
    
    if [ -z "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X "$method" \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github+json" \
            "${API_URL}${endpoint}" 2>/dev/null)
    else
        response=$(echo "$data" | curl -s -w "\n%{http_code}" -X "$method" \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Content-Type: application/json" \
            -H "Accept: application/vnd.github+json" \
            -d @- "${API_URL}${endpoint}" 2>/dev/null)
    fi
    
    status_code=$(echo "$response" | tail -n1)
    response=$(echo "$response" | sed '$d')
    
    echo "$response"
    echo "Status Code: $status_code"
    
    if [[ $status_code -ge 200 && $status_code -lt 300 ]]; then
        return 0
    else
        return 1
    fi
}

# Test 1: Check repository access
echo "🔹 Testing repository access..."
make_request "GET" ""
if [ $? -ne 0 ]; then
    echo "❌ Failed to access repository. Check if the repository exists and your token has the correct permissions."
    exit 1
fi

echo ""

# Test 2: Check user permissions
echo "🔹 Checking your permissions..."
permission_response=$(make_request "GET" "/collaborators/$GITHUB_USERNAME/permission")
if [ $? -eq 0 ]; then
    permission_level=$(echo "$permission_response" | grep -o '"permission": *"[^"]*"' | cut -d'"' -f4)
    echo "✅ You have '$permission_level' permissions on this repository."
    
    if [[ "$permission_level" == "admin" || "$permission_level" == "write" ]]; then
        # Test 3: Test write access by creating a test issue
        echo "🔹 Testing write access by creating a test issue..."
        timestamp=$(date +"%Y%m%d%H%M%S")
        issue_data='{"title":"Test Write Access '${timestamp}'","body":"This is a test issue to verify write access. You can safely delete this issue."}'
        
        issue_response=$(echo "$issue_data" | make_request "POST" "/issues")
        if [ $? -eq 0 ]; then
            issue_url=$(echo "$issue_response" | grep -o '"html_url": *"[^"]*"' | head -1 | cut -d'"' -f4)
            echo "✅ Successfully created test issue: $issue_url"
            echo "   You can delete this issue after verifying access."
        else
            echo "❌ Failed to create test issue. You might not have write access."
        fi
    else
        echo "ℹ️ You don't have write permissions on this repository."
    fi
else
    echo "❌ Failed to check permissions. You might not have access to this repository."
fi

echo ""
echo "✅ Permission check completed."

