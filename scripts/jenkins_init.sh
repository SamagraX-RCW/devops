#! /bin/bash

# This script does the following things
# * Installs JDK - 11, Jenkins
# * Starts Jenkins service
# * Retrieves initial root token and create username=admin and password=admin
# * Downloads and install all recommended services
# * Creates symbolic links of rcw jobs inside jenkins
# * Restart Jenkins to load new jobs

sudo apt update

# Install Java SDK 11
sudo apt install -y openjdk-11-jdk

# Download and Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install fontconfig openjdk-11-jre
sudo apt-get install jenkins

# Start Jenkins
sudo systemctl start jenkins

# Enable Jenkins to run on Boot
sudo systemctl enable jenkins

#install python3
sudo apt update 
sudo apt install software-properties-common -y 
sudo add-apt-repository ppa:deadsnakes/ppa 
sudo apt install Python3.10

url=http://localhost:8080
password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

read -p "Enter username: " input_username
read -p "Enter password: " input_password
read -p "Enter full name: " input_fullname
read -p "Enter email: " input_email

# URL encode the inputs using Python
username=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$input_username', safe=''))")
new_password=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$input_password', safe=''))")
fullname=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$input_fullname', safe=''))")
email=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$input_email', safe=''))")

# Print the encoded values
echo "Encoded username: $username"
echo "Encoded password: $new_password"
echo "Encoded full name: $fullname"
echo "Encoded email: $email"

# GET THE CRUMB AND COOKIE
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "admin:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

# MAKE THE REQUEST TO CREATE AN ADMIN USER
curl -X POST -u "admin:$password" $url/setupWizard/createAdminUser \
     -H "Connection: keep-alive" \
     -H "Accept: application/json, text/javascript" \
     -H "X-Requested-With: XMLHttpRequest" \
     -H "$full_crumb" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     --cookie $cookie_jar \
     --data-raw "username=$username&password1=$new_password&password2=$new_password&fullname=$fullname&email=$email&Jenkins-Crumb=$only_crumb&json=%7B%22username%22%3A%20%22$username%22%2C%20%22password1%22%3A%20%22$new_password%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22$new_password%22%2C%20%22fullname%22%3A%20%22$fullname%22%2C%20%22email%22%3A%20%22$email%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D&core%3Aapply=&Submit=Save&json=%7B%22username%22%3A%20%22$username%22%2C%20%22password1%22%3A%20%22$new_password%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22$new_password%22%2C%20%22fullname%22%3A%20%22$fullname%22%2C%20%22email%22%3A%20%22$email%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D"

cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$user:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

# MAKE THE REQUEST TO DOWNLOAD AND INSTALL REQUIRED MODULES
curl -X POST -u "$user:$password" $url/pluginManager/installPlugins \
-H 'Connection: keep-alive' \
-H 'Accept: application/json, text/javascript, */*; q=0.01' \
-H 'X-Requested-With: XMLHttpRequest' \
-H "$full_crumb" \
-H 'Content-Type: application/json' \
-H 'Accept-Language: en,en-US;q=0.9,it;q=0.8' \
--cookie $cookie_jar \
--data-raw "{'dynamicLoad':true,'plugins':['cloudbees-folder','antisamy-markup-formatter','build-timeout','credentials-binding','timestamper','ws-cleanup','ant','gradle','workflow-aggregator','github-branch-source','pipeline-github-lib','pipeline-stage-view','git','ssh-slaves','matrix-auth','pam-auth','ldap','email-ext','mailer'],'Jenkins-Crumb':'$only_crumb'}"

sudo ln -s ./jobs/RCW /var/lib/jenkins/jobs/RCW

chown -R jenkins:jenkins /var/lib/jenkins/jobs
chown -R jenkins:jenkins /home/devops/jobs/

sudo systemctl restart jenkins