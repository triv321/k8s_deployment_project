# **Kubernetes Deployment Demo: Automated Scaling & Self Healing**

This repository contains a project designed to provide a practical, real world demonstration of the core capabilities of Kubernetes Deployments. Through a declarative manifest and an automation script, this project showcases how Kubernetes manages application scaling and achieves automated recovery from failure, two of the most critical features of the platform.

## **Table of Contents**

* [Core Concepts Explained](https://www.google.com/search?q=%23core-concepts-explained)  
  * [What is a Kubernetes Deployment?](https://www.google.com/search?q=%23what-is-a-kubernetes-deployment)  
  * [The Principle of Desired State](https://www.google.com/search?q=%23the-principle-of-desired-state)  
  * [Automated Self Healing](https://www.google.com/search?q=%23automated-self-healing)  
* [Repository Contents](https://www.google.com/search?q=%23repository-contents)  
* [Prerequisites](https://www.google.com/search?q=%23prerequisites)  
* [Step by Step Usage Instructions](https://www.google.com/search?q=%23step-by-step-usage-instructions)  
* [Understanding the Script's Output](https://www.google.com/search?q=%23understanding-the-scripts-output)  
* [Conclusion](https://www.google.com/search?q=%23conclusion)

## **Core Concepts Explained**

### **What is a Kubernetes Deployment?**

A Deployment is a Kubernetes object that intelligently manages a set of identical Pods. While a Pod is the smallest unit that runs your container, a Deployment is the manager that ensures your application is always running, scalable, and up to date. You provide the Deployment a blueprint for your Pods, and it handles the rest.

### **The Principle of Desired State**

Kubernetes operates on a declarative model. You do not provide step by step commands. Instead, you define the **desired state** of your application in a YAML manifest. For example, you declare "I want 3 replicas of my web server running". The Kubernetes Control Plane then continuously works to make the actual state of the cluster match your desired state. This is a foundational principle that enables powerful automation.

### **Automated Self Healing**

A key responsibility of the Deployment controller is to watch its Pods. If a Pod or even an entire server node fails, the controller detects that the actual state (e.g., 2 running replicas) no longer matches the desired state (3 replicas). It will then automatically schedule a new Pod on a healthy node to bring the system back into compliance. This happens without any human intervention.

## **Repository Contents**

* **deployment.yaml**: A declarative Kubernetes manifest that defines a Deployment. This file is the "source of truth" for our NGINX application, specifying that we desire 2 replicas running the nginx:1.22.0 container image.  
* **scaler.sh**: A Bash automation script that uses the kubectl command line tool to interact with our live Deployment. The script is designed to demonstrate both scaling and self healing in a controlled sequence.

## **Prerequisites**

To run this demonstration, you will need the following tools installed and configured on your local machine:

* A running Kubernetes cluster. [minikube](https://minikube.sigs.k8s.io/docs/start/) is recommended for local development.  
* The Kubernetes command line tool, [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/).  
* A container runtime, such as [Docker](https://www.docker.com/).

## **Step by Step Usage Instructions**

Follow these steps from your terminal to run the demonstration.

1. Clone the Repository  
   Clone this repository to your local machine.  
   git clone \<https://github.com/triv321/k8s\_deployment\_project\>  
   cd \<k8s\_deployment\_project\>

2. Start Your Local Cluster  
   Ensure your local Kubernetes cluster is running.  
   minikube start \--driver=docker

3. Deploy the Application  
   Apply the deployment.yaml manifest to your cluster. This action creates the Deployment object and Kubernetes will begin creating the 2 desired Pods.  
   kubectl apply \-f deployment.yaml

   You can verify the initial state by running kubectl get deployments.  
4. Make the Script Executable  
   Change the permissions on the scaler.sh script to allow it to be executed.  
   chmod \+x scaler.sh

5. Run the Demonstration Script  
   Execute the script to begin the automated sequence.  
   ./scaler.sh

## **Understanding the Script's Output**

The script is designed to be self explanatory. As it runs, it will print headers describing each action it takes. You will witness the following sequence:

1. **Scaling Up**: The script first issues a kubectl scale command to change the Deployment's desired state from 2 to 4 replicas.  
2. **Intelligent Wait**: The script then enters a loop, continuously checking the status of the Deployment until all 4 replicas are in a READY state. This is a best practice in automation.  
3. **Pod Destruction**: To simulate a failure, the script identifies one of the running Pods and uses kubectl delete pod to terminate it.  
4. **Self Healing in Action**: After a brief pause, the script lists the final set of Pods. You will observe that the deleted Pod is gone, but a new Pod with a different name has been automatically created to replace it, bringing the total back to 4\. This demonstrates the self healing capability of the Deployment.

## **Conclusion**

This project provides a tangible example of the power and reliability of Kubernetes. By managing applications through a declarative Deployment object, engineers can build resilient, scalable systems that automatically recover from common failures, a critical requirement for modern cloud native applications.