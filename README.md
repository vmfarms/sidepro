# SidePro Application Cloud CLI

This repository releases contains the SidePro CLI.

Check out the docs at: https://docs.sidepro.cloud/

To download the CLI, you can use the following script, which will fetch the latest release:

```console
curl -s https://api.github.com/repos/vmfarms/sidepro/releases/latest \
    | grep "browser_download_url.*sidepro" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi - -O sidepro && \
    chmod +x sidepro && \
    sudo mv sidepro /usr/local/bin
```
