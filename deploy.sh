# build images
echo "BUILDING IMAGES"
docker build -t nileshmiskin/multi-client:latest -t nileshmiskin/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t nileshmiskin/multi-server:latest -t nileshmiskin/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t nileshmiskin/multi-worker:latest -t nileshmiskin/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# already logged into docker hub, so just push
echo "CREATING LATEST TAG"
docker push nileshmiskin/multi-client:latest
docker push nileshmiskin/multi-server:latest
docker push nileshmiskin/multi-worker:latest

echo "CREATING $SHA TAG"
docker push nileshmiskin/multi-client:$SHA
docker push nileshmiskin/multi-server:$SHA
docker push nileshmiskin/multi-worker:$SHA

echo "APPLY K8S"
# apply k8s 
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=nileshmiskin/multi-server:$SHA
kubectl set image deployments/client-deployment client=nileshmiskin/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=nileshmiskin/multi-worker:$SHA