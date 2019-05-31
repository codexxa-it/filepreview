# File Preview Image Service

_An implementaion of the schul-cloud file preview image service._

The filepreview service creates preview images from downloadable files by using the [filepreview-es6](https://www.npmjs.com/package/filepreview-es6) generator.

## Usage
The filepreview service provides an http(s) endpoint to process incoming requests:
```
POST /filepreview
{
    "download_url": "http://example.com/static/powerpoint1.ppt",
    "signed_s3_url": "https://example.com/powerpoint1.png?options...",
    "callback_url": "http://example.com/callback/powerpoint1.ppt",
    "options": {
        "width": 200
    }
}
```
The service downloads the file from `download_url`, creates the preview image, 
makes a PUT request to the `signed_s3_url` and reports the success/error to the `callback_url`.

More information to [presigned url](https://docs.aws.amazon.com/AmazonS3/latest/dev/ShareObjectPreSignedURL.html) you can find on AWS.

The payload has to be valid json, whereby the url parts are mandatory and the options optional.
The options can be.
Valid values are:
- `width`, `height`: integer (pixel)
    The default `width` is 640, the height is calculated by the convert tool.
- `quality`: 0-100 (used for jpeg)
- `outputFormat`: [png (default), jpg, gif]
- `orientation`: landscape
    If this option is used, a preview image will be created in landscape orientation, based on the width. The height is calculated according to DIN A4 standard.

The success report to the `callback_url` is a request:
```
POST <callback_url>
 {'previewUrl': 'https://example.com/powerpoint1.png'}
```
The error report to the `callback_url` is a request:
```
POST <callback_url>
 {'error': 'An error occured: <errormessage>'}
```

## Authentification
The filepreview service is protected by BasicAuth authentification strategy.
For this, a `USERNAME` and a `PASSWORD` has to be provided as environment variables at startup.


## File types
The supported file-types are: [document-formats](https://www.npmjs.com/package/filepreview-es6#document-formats) (only the usual office types are tested)

The file-type detection is based on the download file's `content-type` header field. The file server __must__ provide this header! The according file-type / extension mapping is taken from the [filepreview-es6 generators database](https://github.com/sahilsharmafrank/filepreview/blob/master/db.json).

## Requirements
Since the filepreview service uses [kue](https://github.com/Automattic/kue) job queue, a redis server is necessary. For this, the `REDIS_HOST` has to be provided as environment variables at startup.

## Docker
A docker image is created based on the `node:10.5.0-stretch` Debian-Stretch NodeJS image.
In development mode, `docker-compose` is used to get both executed and connected. (See more details in `docker-compose.yml`)
In production mode, however, an existing `docker-compose.yml` file can already be used. This file must be adjusted accordingly. The necessary environment variables are `USERNAME`, `PASSWORD` and the `REDIS_HOST` (and `REDIS_AUTH` if needed).

## Non-Docker installation
If docker should not be used, the service can be installed in a Debian Stretch virtual machine (or container).
Adapt installation procedure from `Dockerfile`. Set the environment variables according to the `docker-compose.yml`.

## Docker build
```
docker build --rm -t pbsnet/filepreview:latest .
```

### File Preview tests
http://localhost:8090/BJDGIWwcuyvsEnRoYbfORRSmGBZlZQfZ51II9XCYp5uUf3yexw7d2VUl0qU9-eAQQr6RprsJZ9olC0AWtt-uiec/Qma8jsQS6Pmvwfo4cQptFA77pSc3mbfnbQbgTKM1jetXPp/wifey.jpg