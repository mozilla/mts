# Marian Translation Service

The code in this repository implements a Marian-based translation service. 
Currently, it offers an REST http server. The lack of https is currently on purpose,
as in the vast majority of the use cases that I envision, the service will run locally
and not through a registered domain address, so only self-signed certificates would work.
If you need https, go through a proxy and put the Marian REST server behind a firewall.

Currently, the server can serve only a single configuration (model or ensemble of models).

The REST API is described [here](https://github.com/ugermann/mts/wiki/BergamotAPI/wiki/BergamotAPI).

## Compilation
### Local
Notice that you need all the dependencies and libraries for a full compilation of 
[Marian](http://github.com/marian-nmt/marian-dev).

```
git clone https://github.com/ugermann/mts /path/to/your/local/clone/of/mts
mkdir /path/to/where/you/want/to/build
cd /path/to/where/you/want/to/build/mts
cmake /path/to/your/local/clone/of/mts
make -j
```

### Dockerized Version
(coming soon, based on http://github.com/ugermann/marian-docker ...)

## Configuring a Model to serve
These instructions assume that you have the following files from a marian training process:

- at least one model (more for ensemble decoding; do not try ensembed decoding unless your REST server has access to a GPU)
- the respective vocabulary file(s)
- a shortlist file for faster hypothesis generation (optional)

### Preparation
- Convert the model file(s) to binary format with 
  ```
  marian-conv -f model.npz -t model.bin
  ```
  This is optional, but makes the model load faster.
  
- Create a decoder.yml file, e.g. like this one:
  ```
  relative-paths: true
  models: [ model.bin ]
  vocabs: [ joint-vocab.spm, joint-vocab.spm ]
  beam-size: 4
  normalize: 1
  word-penalty: 0
  mini-batch: 128
  maxi-batch: 100
  maxi-batch-sort: src

  # The following are specific to the marian REST server
  # source-language and target-language are used for the Demo
  # interface; the ssplit-prefix-file is from the Moses sentence splitter
  # and comes with the marian REST server image. Pick the right one
  # for your source language. SSPLIT_ROOT_DIR is set to the appropriate
  # value in the `mariannmt/marian-rest-server` image.
  source-language: German
  target-language: English
  ssplit-prefix-file: ${SSPLIT_ROOT_DIR}/nonbreaking_prefixes/nonbreaking_prefix.de
  ```
- Copy the appropriate `nonbreaking_prefix.*` file for sentence splitting into an appropriate
  location, or 
  ```
  export SSPLIT_ROOT_DIR=/path/to/your/local/clone/of/mts/3rd_party/ssplit-cpp
  ```
  
## Running the Server
```
/path/to/your/build/directory/rest-server -c /path/to/decoder.yml -p <port of your choice>
```

# Known bugs
- Rest-server currently inherits the version info from the marian submodule, which is obviously incorrect.
