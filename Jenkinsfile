pipeline {
	agent any
	tools {
   	 
    	maven 'MAVEN_HOME-3.6.3'

	}
	
	stages {
    
    	stage('Enviroment Variables'){
            steps{
                script{
               load "$JENKINS_HOME/workspace/$Job_Name/envar.groovy"        
            
                }
                
            }
            
        }

    	stage ('Initialization') {
        	steps {
            	sh '''
                	echo "PATH = ${PATH}"
           	 
            	'''
            	 //zAP Setup and Initialization
               /* script {
                    startZap(host: "${host}", port: "${port}", timeout:"${timeout}", zapHome: "${zapHome}",allowedHosts:["${allowedHosts}"]) // Start ZAP at /opt/zaproxy/zap.sh, allowing scans on github.com
                }*/
        	         
             }
    	    }

     	stage("Build"){
        	steps{
           	         
				git url:"${configGitUrl}",branch:"${configBranch}",  credentialsId: 'GitLab-KEY'
            	sh "mvn  compile"  
          	 
        	}
    	}
 
	 
 		stage('Code Analysis') {
		  	steps {
		    	script {
		      		// requires SonarQube Scanner 2.8+
		      		scannerHome = tool 'SonarQubeScanner'
		    			}
		    	withSonarQubeEnv('sonarqube') {
		             
						git url:"${configGitUrl}",branch:"${configBranch}", credentialsId: 'GitLab-KEY'
		       	 		sh "mvn clean package sonar:sonar"
		          
		    		}
		  	}
		}

    
	
   
    
 		stage('Build Images') {
        	steps {

					git url:"${configGitUrl}",branch:"${configBranch}", credentialsId: 'GitLab-KEY'
                	sh 'mvn clean package'
            		script {
                		docker.withRegistry('docker-registry.cdacmumbai.in:443') {
                    	def image = docker.build("${configimage}")
        				}
      				}
 
    			}
		}
    

/*		stage('Security Testing') {
        	steps {
            	script {
                	// Proxy tests through ZAP
                	runZapCrawler(host:"${configUrl}")
            	}
           	 
        	}
    	}*/

		stage('Upload Images to SIT/QA'){
    	     	steps{
    	     	
      				withCredentials([string(credentialsId: 'DockerRegistryID', variable: 'DockerRegistryID')]) {
       			}

        		//sh  "docker push ${serverimage}"
         		sh  " docker push ${configimage}"
         		
     			}      	 
 			}
 			
 		stage('Build Images to UAT') {
        	steps {

					git url:"${configGitUrl}",branch:"${configBranch}", credentialsId: 'GitLab-KEY'
                	sh 'mvn clean package'
            		script {
                		docker.withRegistry('docker-registry.ecgc.in:443') {
                    	def image = docker.build("${uatimage}")
        				}
      				}
 
    			}
		}
	    	
	    stage('Upload Images to UAT'){
    	     	steps{
    	     	
      				withCredentials([string(credentialsId: 'DockerRegistryID', variable: 'DockerRegistryID')]) {
       			}

        		//sh  "docker push ${serverimage}"
         		sh  " docker push ${uatimage}"
         		
     			}      	 
 			}
	    
	
      
		}

		post {
	    	// Always runs. And it runs before any of the other post conditions.
	    	always {
	       	 
	    	//ZAP Report
	        /*	script {
	            	archiveZap(failAllAlerts: 0, failHighAlerts: 0, failMediumAlerts: 0, failLowAlerts: 0)
	        	}*/
	  	 
	        	// Let's wipe out the workspace before we finish!
	         	cleanWs()
	    	}
   	 
		}

}
