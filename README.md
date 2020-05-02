# certbot-aliyun
带有阿里云DNS插件的certbot镜像，用于letsencrypt的ssl证书获取

## 用法

首次创建证书

```bash
docker run --rm -it \
    -e "ALY_KEY=<YOUR_KEY_HERE>" \
    -e "ALY_TOKEN=<YOUR_TOKEN_HERE>" \
    -v "/your/local/path:/etc/letsencrypt" \
    -v "/your/local/path:/var/lib/letsencrypt" \
    lonord/certbot-aliyun \
    certonly \
    --non-interactive \
    --manual-public-ip-logging-ok \
    --agree-tos \
    -d *.your.domain \
    -d your.domain \
    -m your_email@abc.com
```

后续更新执行

```bash
docker run --rm -it \
    -e "ALY_KEY=<YOUR_KEY_HERE>" \
    -e "ALY_TOKEN=<YOUR_TOKEN_HERE>" \
    -v "/your/local/path:/etc/letsencrypt" \
    -v "/your/local/path:/var/lib/letsencrypt" \
    lonord/certbot-aliyun \
    renew
```

### 使用docker-compose

首次创建证书

```yaml
version: '3'
services:
  certbot:
    image: lonord/certbot-aliyun
    environment:
      ALY_KEY: <YOUR_KEY_HERE>
      ALY_TOKEN: <YOUR_TOKEN_HERE>
    command:
      - "certonly"
      - "--non-interactive"
      - "--manual-public-ip-logging-ok"
      - "--agree-tos"
      - "-d"
      - "*.your.domain"
      - "-d"
      - "your.domain"
      - "-m"
      - "your_email@abc.com"
    volumes:
      - "/your/local/path:/etc/letsencrypt"
      - "/your/local/path:/var/lib/letsencrypt"
```

后续更新执行

```yaml
version: '3'
services:
  certbot:
    image: lonord/certbot-aliyun
    environment:
      ALY_KEY: <YOUR_KEY_HERE>
      ALY_TOKEN: <YOUR_TOKEN_HERE>
    command:
      - "renew"
    volumes:
      - "/your/local/path:/etc/letsencrypt"
      - "/your/local/path:/var/lib/letsencrypt"
```

### 在k8s中使用

首次创建证书，执行以下job

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: your-domain-ssl-create
spec:
  backoffLimit: 3
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: your-domain-ssl-create
        image: lonord/certbot-aliyun
        env:
        - name: ALY_KEY
          value: <YOUR_KEY_HERE>
        - name: ALY_TOKEN
          value: <YOUR_TOKEN_HERE>
        args:
        - "certonly"
        - "--non-interactive"
        - "--manual-public-ip-logging-ok"
        - "--agree-tos"
        - "-d"
        - "*.your.domain"
        - "-d"
        - "your.domain"
        - "-m"
        - "your_email@abc.com"
        volumeMounts:
        - mountPath: /etc/letsencrypt
          name: letsencrypt-etc
        - mountPath: /var/lib/letsencrypt
          name: letsencrypt-lib
      volumes:
      - name: letsencrypt-etc
        # your volume def
      - name: letsencrypt-lib
        # your volume def
```

后续更新使用cronjob

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: your-domain-ssl-update
spec:
  schedule: "15 20 * * *"
  jobTemplate:
    spec:
      backoffLimit: 3
      template:
        spec:
          restartPolicy: Never
          containers:
          - name: certbot-aliyun
            image: lonord/certbot-aliyun
            env:
            - name: ALY_KEY
              value: <YOUR_KEY_HERE>
            - name: ALY_TOKEN
              value: <YOUR_TOKEN_HERE>
            args:
            - "renew"
            volumeMounts:
            - mountPath: /etc/letsencrypt
              name: letsencrypt-etc
            - mountPath: /var/lib/letsencrypt
              name: letsencrypt-lib
          volumes:
            - name: letsencrypt-etc
                # your volume def
            - name: letsencrypt-lib
                # your volume def
```

## License

MIT