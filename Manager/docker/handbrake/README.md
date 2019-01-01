# Handbrake

https://hub.docker.com/r/jlesage/handbrake

mkdir -p /mnt/nas/docker/handbrake

sudo docker service create \
  --name handbrake \
  --publish published=5800,target=5800,protocol=tcp,mode=ingress \
  --mount type=bind,src=/mnt/nas/docker/handbrake,dst=/config:rw \
  --mount type=bind,src=/mnt/nas/media/jobs/watch,dst=/watch:rw \
  --mount type=bind,src=/mnt/nas/media/jobs/storage,dst=/storage:ro \
  --replicas=1 \
  jlesage/handbrake

