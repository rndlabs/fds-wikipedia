# Swarming Wikipedia!

This repository contains the docker configuration and deployment scripts that allow for downloading of a specified `zim` file, which is then packaged and uploaded to the Swarm network. You may see an _example_ of this container in action by checking out the [video presentation](presentation/recording.mp4).

The Swarm mainnet version containing the full Wikipedia is available under the `feed` hash of [`61a4a1073a19c273ac0cdf663a1d4d83c01ef01bdbb60db596975f2518b28593`](https://api.gateway.ethswarm.org/bzz/61a4a1073a19c273ac0cdf663a1d4d83c01ef01bdbb60db596975f2518b28593/).

When running the container, specify the following environment variables:

- `SOURCE_URL`, ie. "https://dumps.wikimedia.org/other/kiwix/zim/wikipedia/wikipedia_en_100_maxi_2022-07.zim"
- `BEE_API_URL`, ie. "http://127.0.0.1:1633"
- `BEE_HERDER_BEE_POSTAGE_BATCH`, ie. "a075fea328a830eaedcb80b6b51db56127fdcaa61527901bb6be186533855c12"
- `BEE_HERDER_UPLOAD_RATE`, ie. 1500

# Components

This docker container makes extensive use of:

1. `bee_herder` - https://github.com/rndlabs/bee-herder
2. `wiki_extractor` - https://github.com/rndlabs/wiki-extractor
3. `swarm-wikipedia` https://github.com/rndlabs/swarm-wikipedia

Respective licenses and instructions for the use of these tools can be found in their repositories.