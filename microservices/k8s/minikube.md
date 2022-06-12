# Minikube
- [Hello Minikube](https://kubernetes.io/docs/tutorials/hello-minikube/)
- 可在本機上輕易架設一個 K8S Cluster
- Minikube 會在本機上跑起一個 VM，並且在這 VM 裡建立一個 signle-node K8S Cluster
- 本身並不支援 HA (High availability)，也不推薦在實際應用上運行
- 範例
    - https://minikube.sigs.k8s.io/docs/start/
- demo
    <br><img src="https://github.com/ShaqtinAFool/gitbook/blob/master/img/kubernetes/hello-minikube.png?raw=true" alt="drawing" width="700"/>
- minikube 基本指令
    - 啟動 minikube
        - `minikube start --driver=docker`
    - 開啟 dashboard
        - `minikube dashboard`
    - 查詢 minikube 對外的 IP
        - `minikube ip`
- k8s 基本指令
    - 列出所有 pod
        - `kubectl get pods --all-namespaces; kubectl get pods -A`
    - 查看 pod 資訊
        - `kubectl describe pods kubernetes-dashboard-ccd587f44-vdgwv -n kubernetes-dashboard`

# Set up Ingress on Minikube with the NGINX Ingress Controller (not finish)
- To enable the NGINX Ingress controller
    - `minikube addons enable ingress`
- Verify that the NGINX Ingress controller is running
    - `kubectl get pods -n ingress-nginx`
- Deploy a hello, world app
    - `kubectl create deployment web --image=gcr.io/google-samples/hello-app:1.0`
- Expose the Deployment
    - `kubectl expose deployment web --type=NodePort --port=8080`
- Verify the Service is created and is available on a node port
    - `kubectl get service web`
        ```
        [azadmin@t-minikube ~]$ k get svc
        NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
        kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP          11h
        nginx        NodePort    10.109.171.121   <none>        80:30911/TCP     9s
        web          NodePort    10.99.162.7      <none>        8080:32281/TCP   57m
        ```
- Visit the Service via NodePort
    - `minikube service web --url`
- Create an Ingress
    - `kubectl apply -f https://k8s.io/examples/service/networking/example-ingress.yaml`
    - `example-ingress.yaml`
        ```yaml
        apiVersion: networking.k8s.io/v1
        kind: Ingress
        metadata:
        name: example-ingress
        annotations:
          nginx.ingress.kubernetes.io/rewrite-target: /$1
        spec:
        rules:
          - host: hello-world.info
          http:
            paths:
            - path: /
              pathType: Prefix
              backend:
              service:
                name: web
                port:
                number: 8080
        ```
- Verify the IP address is set
    - `kubectl get ingress`