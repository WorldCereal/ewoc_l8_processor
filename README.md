# EWoC Landsat 8 processor docker image

## Use EWoC Landsat 8 processor docker image

### Retrieve EWoC Landsat 8 processor docker image

```sh
docker login 643vlk6z.gra7.container-registry.ovh.net -u ${harbor_username}
docker pull 643vlk6z.gra7.container-registry.ovh.net/world-cereal/ewoc_l8_processing:${tag_name}
```

#### Generate L8 ARD from L8 product ID

To run the generation of ARD from L8 product ID with upload of data, you need to pass to the docker image a file with some credentials with the option `--env-file /path/to/env.file`. This file contains the variables related to `ewoc_dag`. For a test on aws, you need to set: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` with our credentials and `EWOC_CLOUD_PROVIDER=aws`.

:warning: Adapt the `tag_name` to the right one

Example:

```sh
docker run --rm --env-file /local/path/to/env.file 643vlk6z.gra7.container-registry.ovh.net/world-cereal/ewoc_l8_processing:${tag_name} ewoc_generate_l8_ard -v 31TCJ LC08_L2SP_199029_20211216_20211223_02_T1 LC08_L2SP_199030_20211216_20211223_02_T1
```

:grey_exclamation: Please consult `ewoc_l8`  for more information on the ewoc_l8 CLI.

## Build EWoC Landsat 8 processor docker image

To build the docker you need to have the following private python packages close to the Dockerfile:

- ewoc_dag
- ewoc_l8

You can now run the following command to build the docker image:

```sh
docker build --build-arg EWOC_L8_DOCKER_VERSION=$(git describe) --pull --rm -f "Dockerfile" -t ewoc_l8_processing:$(git describe) "."
```

### Advanced build

:warning: No guarantee on the results

You can pass the following version with `--build-arg` option to bypass encoded version:

- `EWOC_L8_VERSION`
- `EWOC_DAG_VERSION`

## Push EWoC Sentinel-1 processor docker image

:warning: Push is done by github-actions! Use these commands only in specific case.

```sh
docker login 643vlk6z.gra7.container-registry.ovh.net -u ${harbor_username}
docker tag ewoc_l8_processing:${tag_name} 643vlk6z.gra7.container-registry.ovh.net/world-cereal/ewoc_l8_processing:${tag_name}
docker push 643vlk6z.gra7.container-registry.ovh.net/world-cereal/ewoc_l8_processing:${tag_name}
```