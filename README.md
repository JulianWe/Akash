## Akash Deployment Tutorial
Censorship-resistant, permissionless, and self-sovereign, Akash Network is the world’s first open source cloud. | $AKT

Tutorial Author: Julian Wendland
Address: akash1srujzhj2v9fkzhnn635udlczyhdpetuh34mhad

# Variables:
|Name|Description|Example|
|---|---|---|
|`AKASH_NODE`| Akash network configuration base URL. | http://135.181.60.250:26657* |
|`AKASH_CHAIN_ID`| Chain ID of the Akash network connecting to. | akashnet-2* |
|`ACCOUNT_ADDRESS`| The address of your account. | akash1srujzhj2v9fkzhnn635udlczyhdpetuh34mhad* |
|`KEYRING_BACKEND`| Keyring backend to use for local keys. (os,file or test) | os |
|`KEY_NAME` | The name of the key you will be deploying from. | julian* | 
|`AKASH_NET`| The URL of Akash Network. In This Tutorial we are using Mainnet | https://raw.githubusercontent.com/ovrclk/net/master/mainnet |
|`AKASH_VERSION`| Akash Version. | 0.10.1* | 

**Note:** you can always check if all the required variables are set using "echo " before your command.



## Installation:

```sh
AKASH_VERSION="$(curl -s "$AKASH_NET/version.txt")"
curl https://raw.githubusercontent.com/ovrclk/akash/master/godownloader.sh | sh -s -- "$AKASH_VERSION"
```


## Wallet Setup:
**Variables needed for wallet creation**
```sh
export KEY_NAME=julian
export KEYRING_BACKEND=os
```


**How to add key if you haven't yet setup a key**
```sh
akash --keyring-backend "$KEYRING_BACKEND" keys add "$KEY_NAME
```
:warning: **Important** write this mnemonic phrase in a safe place. It is the only way to recover your account if you ever forget your password.


**How to recover keys**
```sh
akash --keyring-backend "$KEYRING_BACKEND" keys add "$KEY_NAME" --recover
```


**How to export keys**
```sh
akash --keyring-backend "$KEYRING_BACKEND" keys export "$KEY_NAME"
```


**How to retrieve wallet address**
```sh
akash --keyring-backend "$KEYRING_BACKEND" keys show "$KEY_NAME" -a
```


**How to check if there is enought $AKT to send transactions**
```sh
akash query bank balances --node $AKASH_NODE $ACCOUNT_ADDRESS
```
**Note:** You can buy $AKT on BitMax using this link: https://bitmax.io/register?inviteCode=LQDS1MMP



## Setup required Variables
```sh
AKASH_NET="https://raw.githubusercontent.com/ovrclk/net/master/mainnet"
AKASH_VERSION="$(curl -s "$AKASH_NET/version.txt")"

curl -s "$AKASH_NET/genesis.json" > genesis.json 
curl -s "$AKASH_NET/seed-nodes.txt" | paste -d, -s
curl -s "$AKASH_NET/peer-nodes.txt" | paste -d, -s

AKASH_CHAIN_ID="$(curl -s "$AKASH_NET/chain-id.txt")"
AKASH_NODE="$(curl -s "$AKASH_NET/rpc-nodes.txt" | shuf -n 1)"
```


**Check AKASH_NODE & AKASH_CHAIN_ID variable**
```sh
echo $AKASH_NODE AKASH_CHAIN_ID
```


**How to retrieve and export ACCOUNT_ADDRESS as variable**
```sh
export ACCOUNT_ADDRESS=$(akash --keyring-backend "$KEYRING_BACKEND" keys show "$KEY_NAME" -a)
```


**How to generate certificate**
****requires fees**** :warning:  **Important** certificate needs to be created only once per account and can be used across all deployments. 
```sh
echo akash tx cert create client --chain-id $AKASH_CHAIN_ID --keyring-backend $KEYRING_BACKEND --from $KEY_NAME --node $AKASH_NODE --fees 5000uakt
```


**How to download example deployment file**
```sh
curl -s https://raw.githubusercontent.com/ovrclk/docs/master/guides/deploy/deploy.yml > deploy.yml
```


**How to deploy**
****requires fees****
```sh
echo akash deploy create deploy.yml --from $KEY_NAME --chain-id $AKASH_CHAIN_ID --keyring-backend $KEYRING_BACKEND --node $AKASH_NODE --fees 5000uakt
```


**How to retrive market lease for PROVIDER, DSEQ, GSEQ and OSEQ variables**
Example values: DSEQ=27977, akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz
```sh
akash query market lease list --owner $ACCOUNT_ADDRESS --node $AKASH_NODE --state active
```

You should see a response similar to:

```yaml
leases:
- escrow_payment:
    account_id:
      scope: deployment
      xid: akash1ny2lt9mcfet63k8ur2ue9xqaunxe80we64hket/83492
    balance:
      amount: "0"
      denom: uakt
    owner: akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz
    payment_id: 1/1/akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz
    rate:
      amount: "100"
      denom: uakt
    state: open
    withdrawn:
      amount: "0"
      denom: uakt
  lease:
    created_at: "83498"
    lease_id:
      dseq: "83492"
      gseq: 1
      oseq: 1
      owner: akash1ny2lt9mcfet63k8ur2ue9xqaunxe80we64hket
      provider: akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz
    price:
      amount: "100"
      denom: uakt
    state: active
```   


and extract the following variables:

```sh
export DSEQ=83876
export PROVIDER=akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz

echo $DSEQ $PROVIDER
``` 



**How to view logs**
```sh
export AKASH_HOME=/home/jw/.akash
export SERVICE_NAME=web 

akash --home "$AKASH_HOME" --node "$AKASH_NODE" provider service-logs --service $SERVICE_NAME --owner "$ACCOUNT_ADDRESS" --dseq "$DSEQ" --gseq $GSEQ --oseq $OSEQ --provider "$PROVIDER"
``` 


**How to Update Deployment**
****requires fees****
```sh
echo akash tx deployment update deploy.yml --from $KEY_NAME --node $AKASH_NODE --chain-id $AKASH_CHAIN_ID --fees 5000uakt --dseq $DSEQ
``` 


**How to close deployment**
****requires fees****
```sh
echo akash tx deployment close --node $AKASH_NODE --chain-id $AKASH_CHAIN_ID --dseq $DSEQ  --owner $ACCOUNT_ADDRESS --from $KEY_NAME --keyring-backend $KEYRING_BACKEND -y --fees 5000uakt
``` 

