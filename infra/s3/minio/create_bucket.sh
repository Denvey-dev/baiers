#!/bin/sh

#Ждем Minio
echo "Waiting for MinIO server..."
until mc alias set myminio http://minio:${S3_INTERNAL_PORT} ${MINIO_ROOT_USER} ${MINIO_ROOT_PASSWORD}; do
  echo "...waiting for MinIO..."
  sleep 2
done
echo "MinIO server is up. Alias 'myminio' configured."

#Публичный 
if mc ls myminio/${S3_PUBLIC_BUCKET} > /dev/null 2>&1; then
    echo "Public bucket '${S3_PUBLIC_BUCKET}' already exists."
else
    mc mb myminio/${S3_PUBLIC_BUCKET}
    mc anonymous set download myminio/${S3_PUBLIC_BUCKET}
    echo "Public bucket '${S3_PUBLIC_BUCKET}' created and set to public."
fi

#Приватный
if mc ls myminio/${S3_PRIVATE_BUCKET} > /dev/null 2>&1; then
    echo "Private bucket '${S3_PRIVATE_BUCKET}' already exists."
else
    mc mb myminio/${S3_PRIVATE_BUCKET}
    echo "Private bucket '${S3_PRIVATE_BUCKET}' created (access restricted)."
fi

echo "MinIO setup completed."
exit 0