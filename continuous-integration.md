# Continuous Integration

## Integrating GitLab and Jenkins

Set up ssh to access Git(Lab)
* `ssh-keygen -t rsa -C "coateds@outlook.com"`
* `cat ~/.ssh/id_rsa.pub`

##  New approach 3/27/19
* Use Gitlab CE 
* VagrantGitLabAsCode (Host: GitLabAsCode, IP: 192.168.16.8)
* On CentOSasCode, use /home/vagrant/gitrepositories/cicd-pipeline-train-schedule-jenkins as repo to push to project with the same name.
  * recreate on GitLabCE by hand and push origin master from repo

Box JenkinsDocker as Code

* http://jenkins.davecoate.com:8080 (Not https)
* logon coateds/HB!



This video!!
* This looks complicated, but might be necessary
* https://www.youtube.com/watch?v=SWl_XicACyk


On Jenkins system config:
* Gitlab
  * Connection name: GitLab
  * url: http://gitlabce.davecoate.com
  * Creds:  GitHubKey

Jenkins plugins
* GitLab Plugin, Gitlab Hook

Repository URL for job
* http://gitlabce.davecoate.com/root/cicd-pipeline-train-schedule-jenkins







## Build process through CI config 3/27
* Build GitLab Server (VagrantGitLabAsCode)
* Provision/Install gitlab-ce
  * See install-gitlab.rb for partial recipe and instructions
  * instructions configure for http://gitlabce.davecoate.com (NOT SSL!)
* Once GitLab is up
  * Sign in and create pw for root user
  * For now, everything will be done as root
  * Add ssh pub key
    * root user (icon upper right), settings, ssh keys
    * paste in key from client
      * `ssh-keygen -t rsa -C "coateds@outlook.com"`
      * `cat ~/.ssh/id_rsa.pub`
  * Create project
    * name: cicd-pipeline-train-schedule-jenkins
    * Public, no README
* From client, in Repo
  * `git remote rename origin old-origin`
  * `git remote add origin git@gitlabce.davecoate.com:root/cicd-pipeline-train-schedule-jenkins.git`
  * `git push origin master`
  * Confirm project has data in it

* In GitLab
  * Allow outbound
    * Go to the admin area
    * Go to Settings, Network
    * Go to Outbound Requests
    * Click the “Allow requests to the local network from hooks and services”   button.
    * Save the changes
  * Project:  cicd-pipeline-train-schedule-jenkins
  * settings, integrations
    * URL: http://192.168.16.5:8080/project/train-schedule
    * Does not work -->New_URL: http://jenkins.davecoate.com:8080/project-train-schedule
    * Push events
    * Do Not enable ssl verification
    * Add Webhook


* Build jenkins server (VagrantJenkinsDockerAsCode)
  * http://jenkins.davecoate.com:8080
  * Configuration should be restored from /vagrant in the recipe
    * logon with coateds/HB!
    * train-schedule job should already exist
  * Add Plugins
    * GitLab, Gitlab Hook
    * Install without restart
    * restart
  * (Re)configure train-schedule
    * Repository URL: git@gitlabce.davecoate.com:root/cicd-pipeline-train-schedule-jenkins.git
    * Add Credentials
      * Kind: SSH...
      * ID: git
      * Username: jenkins
      * Private Key: Enter directly from cat of ssh private key (.ssh/id_rsa)
    *   Build trigger: Build when a change is pushed to GitLab. GitLab webhook URL: http://192.168.16.5:8080/project/train-schedule
    accept default options for now
    * Build
      * invoke Gradle script
      * Use Gradle Wrapper
      * tasks: build
    * Post-build Actions
      * Archive the Artifacts: Files to archive: dist/trainSchedule.zip


* In Manage Jenkins, Config sys:
  * Uncheck: Enable authentication for '/project' end-point
* Back to Integrations, test push event
* Add 192.168.16.8 gitlabce.davecoate.com to /etc/hosts on jenkinsdocker
* Add 192.168.16.5 jenkins.davecoate.com to /etc/hosts on gitlab as code

Secondary source??
* https://medium.com/@teeks99/continuous-integration-with-jenkins-and-gitlab-fa770c62e88a

Questions
What adjustments, if any, are needed in the /etc/hosts

### Detritus
### In GitHub
* My Settings
* Developer Settings
* Personal Access Token
* Generate new token
  * Name: (jeinkins)
  * admin:repo_hook 
  * Generate token  ()

### In Jenkins
* Manage Jenkins
* Configure System
  * GitHub, Add

Git lab tutorial series
* https://www.youtube.com/watch?v=0z28J0RfaJM

Gitlab ssl:  https://www.youtube.com/watch?v=d7PCc2hjncI - purchase a cert
* Uses Chef... might have to work through this, but moving on for now

`git config --global http.sslVerify false`