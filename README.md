## Akash
Censorship-resistant, permissionless, and self-sovereign, Akash Network is the world’s first open source cloud. | $AKT


# Variables:
|Name|Description|
|---|---|
|`AKASH_NODE`| Akash network configuration base URL. See [Documentation]().|
|`AKASH_CHAIN_ID`| Chain ID of the Akash network connecting to. See [Documentation](https://docs.akash.network/guides/version).|
|`ACCOUNT_ADDRESS`| The address of your account.  See [Documentation](https://docs.akash.network/guides/wallet).|
|`KEYRING_BACKEND`| Keyring backend to use for local keys. See [Documentation](https://docs.akash.network/guides/wallet)|
|`KEY_NAME` | The name of the key you will be deploying from. See [Documentation](https://docs.akash.network/guides/wallet) if you haven't yet setup a key|

|`AKASH_NET`| The URL of Akash Network.  See [Documentation]().|
|`AKASH_VERSION`| Akash Version. See [Documentation]()|

Note: you can always check if all the required variables are set using "echo " before your command.


## Installation:
# Variables: 
```bash
AKASH_VERSION="$(curl -s "$AKASH_NET/version.txt")"
curl https://raw.githubusercontent.com/ovrclk/akash/master/godownloader.sh | sh -s -- "$AKASH_VERSION"
```

## Wallet Setup:
# Variables:
export KEY_NAME=julian
export KEYRING_BACKEND=os

akash --keyring-backend "$KEYRING_BACKEND" keys add "$KEY_NAME

**Important** write this mnemonic phrase in a safe place. It is the only way to recover your account if you ever forget your password.

# Recover Keys:
akash --keyring-backend "$KEYRING_BACKEND" keys add "$KEY_NAME" --recover

# How to recover Keys:
akash --keyring-backend "$KEYRING_BACKEND" keys export "$KEY_NAME"

# How to retrieve Wallet Address:
akash --keyring-backend "$KEYRING_BACKEND" keys show "$KEY_NAME" -a

# How to check if there is enought $AKT to send transactions
akash query bank balances --node $AKASH_NODE $ACCOUNT_ADDRESS


# Setup required Variables:
AKASH_NET="https://raw.githubusercontent.com/ovrclk/net/master/mainnet"
AKASH_VERSION="$(curl -s "$AKASH_NET/version.txt")"

curl -s "$AKASH_NET/genesis.json" > genesis.json 
curl -s "$AKASH_NET/seed-nodes.txt" | paste -d, -s
curl -s "$AKASH_NET/peer-nodes.txt" | paste -d, -s

AKASH_CHAIN_ID="$(curl -s "$AKASH_NET/chain-id.txt")"
AKASH_NODE="$(curl -s "$AKASH_NET/rpc-nodes.txt" | shuf -n 1)"

# Check AKASH_NODE variable
echo $AKASH_NODE


# How to retrieve and export ACCOUNT_ADDRESS as variable
export ACCOUNT_ADDRESS=$(akash --keyring-backend "$KEYRING_BACKEND" keys show "$KEY_NAME" -a)


# How to generate certificate:
# FEES required

echo akash tx cert create client --chain-id $AKASH_CHAIN_ID --keyring-backend $KEYRING_BACKEND --from $KEY_NAME --node $AKASH_NODE --fees 5000uakt


# How to download example deployment file:
curl -s https://raw.githubusercontent.com/ovrclk/docs/master/guides/deploy/deploy.yml > deploy.yml


# How to deploy:
# FEES required

echo akash deploy create deploy.yml --from $KEY_NAME --chain-id $AKASH_CHAIN_ID --keyring-backend $KEYRING_BACKEND --node $AKASH_NODE --fees 5000uakt


# How to retrive market lease for DSEQ and PROVIDER Variable: EXAMPLE Values: 27977, akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz
akash query market lease list --owner $ACCOUNT_ADDRESS --node $AKASH_NODE --state active

export DSEQ=83876
export PRIVDER=akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz


# How to view logs:
# Variables: AKASH_HOME= , SERVICE_NAME
export AKASH_HOME=/home/jw/.akash
export SERVICE_NAME=web 
export GSEQ=1
export OSEQ=1

akash --home "$AKASH_HOME" --node "$AKASH_NODE" provider service-logs --service $SERVICE_NAME --owner "$ACCOUNT_ADDRESS" --dseq "$DSEQ" --gseq 1 --oseq $OSEQ --provider "$PROVIDER"


# How to Update Deployment:
echo akash tx deployment update deploy.yml --from $KEY_NAME --node $AKASH_NODE --chain-id $AKASH_CHAIN_ID --fees 5000uakt --dseq $DSEQ


# How to close deployment:
# FEES required
# Variables: AKASH_HOME, SERVICE_NAME=web (the name of the deployment in the deployment file), GSEQ=1, OSEQ=1, PROVIDER

echo akash tx deployment close --node $AKASH_NODE --chain-id $AKASH_CHAIN_ID --dseq $DSEQ  --owner $ACCOUNT_ADDRESS --from $KEY_NAME --keyring-backend $KEYRING_BACKEND -y --fees 5000uakt


