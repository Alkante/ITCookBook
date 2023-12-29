# Pipeline Jenkins

## Links
https://jenkins.io/doc/book/pipeline/

# Context
To define pipeline you can:
 - use classic UI
 - SCM file
 - Blue Ocean plugin

 The pipeline is decribe in a **Jenkinsfile**

##  SCM polling trigger with gitlab ?


      steps {
        //enable remote triggers
        script {
            properties([pipelineTriggers([pollSCM('')])])
        }
        //define scm connection for polling
        git branch: develop, credentialsId: 'my-credentials', url: 'ssh://gitlab.exemple.com:entreprise/project-template.git'
      }


```Jenkinsfile
pipeline {
  agent any
  stages {
    stage('Fetch dependencies') {
      agent {
        docker 'node:13-stretch'
      },
      steps {
        sh 'npm install'      // CLI
        stash includes: 'node_modules/', name: 'node_modules'
      }
    }
    stage('Lint') {
      agent {
        docker 'node:13-stretch'
      }
      steps {
        unstash 'node_modules'
        sh 'npm run lint'     // CLI
      }
    }
    stage('Build release') {
      agent {
        docker 'node:13-stretch'
      }
      steps {
        unstash 'node_modules'
        sh 'npm run prod'
        stash includes: 'dist/', name: 'dist'
      }
    }
    stage('Build docker wityh release') {
      agent any
      environment {
        DOCKER_PUSH = credentials('docker_push')
      }
      steps {
        unstash 'dist'
        sh 'docker build -t $DOCKER_PUSH_URL/frontend .'
      }
    }
  }
}
```


```
    stage('Build') {
        withEnv(["NPM_CONFIG_LOGLEVEL=warn"]) {
            sh 'npm install'
        }
        steps {
            echo ' Stage Building ...'
            sh 'npm install || true'
            sh 'ng build || true'
            archiveArtifacts artifacts: 'target/', fingerprint: true  // Save build result
        }
        steps {
            echo ' Stage Building ...'
            sh 'npm install || true'
            sh 'ng prod || true'
            archiveArtifacts artifacts: 'target/', fingerprint: true  // Save build result
        }
        },
    stage('UnitTests') {
        steps {
            echo ' Stage Unit tests ...'
            sh 'ls'
        }
    },
    stage('IntegrationTests') {
        steps {
            echo ' Stage Integration tests ...'
            sh 'ls'
        }
    },
    stage('DeployTests') {
        steps {
            echo ' Stage Deploy tests ...'
            sh 'ls'
        }
    }
    }
}
```
