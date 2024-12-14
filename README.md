# Firebase Auth Service
This microservice is designed to use with nginx to authenticate the requests with firebase-admin SDK.

## Environment Variables
The following environment variables is mandatory to use this image 
- **PORT**: The port that will be exposed by the container
- **GOOGLE_APPLICATION_CREDENTIALS**: This is the path to the `admin-credentials.json` file. You should also bind a volume to this file from your host system.

## Headers 
It will use the token value in the `Authorization` header and tries to decode it.

 Following headers will be added to the request if the decode successfull to be consumed by the downstream services: 
| Header | Value | Description | 
| - | - | - | 
| X-User-UID | uid | The user's uid value |
| X-User-Data | decodedToken | The decoded token object as a stringified json |


---
## The example nginx configuration: 
```
upstream authenticate {
    server auth:<PORT>;
}

upstream api {
    server <yourapiservice>
}

server {
    listen <PORT>;
    server_tokens off;

    location /api/ {
        auth_request /auth;

        # Get the headers from auth service
        auth_request_set $user_uid  $upstream_http_x_user_uid; 
        auth_request_set $user_data $upstream_http_x_user_data;

        # Set the headers to the request so it can be used downstream
        proxy_set_header X-User-UID $user_uid;
        proxy_set_header X-User-data $user_data;

        proxy_set_header Host $host;
        proxy_set_header X-Original-URI $request_uri;

        proxy_pass http://api/;
    }

    location /auth {
        internal;

        proxy_pass http://authenticate;
        proxy_set_header Authorization $http_authorization;
        proxy_set_header Host $host;
        
        proxy_pass_request_body off;
        proxy_set_header Content-Length "";
    }
}

```
