# ☁️ [Akash](https://akash.network/) deployment Tutorial 🐇


![Akash](app/images/Akash.jpg)

## About
**Censorship-resistant, permissionless, and self-sovereign, Akash Network is the world’s first open source cloud. $AKT**
## About
| Key | Value |
| --- | --- |
| `Source ` | 🕳️ [Documentation](https://docs.akash.network/guides/deploy) |
| `Tutorial Author ` | ☕ `Julian Wendland` |
| `$AKT Address` | `akash1srujzhj2v9fkzhnn635udlczyhdpetuh34mhad` |


## Variables
:information_source: **Note:** you can always check if all the required variables are set using "echo $variable" before your command.
|Name|Description|Example values |
|---|---|---|
|`AKASH_NET`| The URL of Akash Network. In This Tutorial we are using Mainnet | `https://raw.githubusercontent.com/ovrclk/net/master/mainnet` |
|`AKASH_VERSION`| Akash Version. | `0.10.1` |
|`AKASH_NODE`| Akash network configuration base URL. | `http://rpc.akash.forbole.com:80` |
|`AKASH_CHAIN_ID`| Chain ID of the Akash network connecting to. | `akashnet-2` |
|`ACCOUNT_ADDRESS`| The address of your account. | `akash1srujzhj2v9fkzhnn635udlczyhdpetuh34mhad` |
|`KEYRING_BACKEND`| Keyring backend to use for local keys. (os,file or test) | `file` |
|`KEY_NAME` | The name of the key you will be deploying from. | `julian` |



# Prepare `akash` environment ☁️

**Setup required variables for Installation & later use. `AKASH_NET`,`AKASH_VERSION`, `AKASH_NODE` & `AKASH_CHAIN_ID`**
```sh

export AKASH_NET="https://raw.githubusercontent.com/ovrclk/net/master/mainnet"
export AKASH_VERSION="$(curl -s "$AKASH_NET/version.txt")"
export AKASH_NODE="$(curl -s "$AKASH_NET/rpc-nodes.txt" | shuf -n 1)"
export AKASH_CHAIN_ID="$(curl -s "$AKASH_NET/chain-id.txt")"

curl -s "$AKASH_NET/genesis.json" > genesis.json 
curl -s "$AKASH_NET/seed-nodes.txt" | paste -d, -s
curl -s "$AKASH_NET/peer-nodes.txt" | paste -d, -s


# Check variables
echo AKASH_NET: $AKASH_NET, AKASH_VERSION: $AKASH_VERSION, AKASH_NODE: $AKASH_NODE, AKASH_CHAIN_ID: $AKASH_CHAIN_ID
```

## 🏳️ Start Installation
```sh
curl https://raw.githubusercontent.com/ovrclk/akash/master/godownloader.sh | sh -s -- "$AKASH_VERSION"
export akash=$PATH:/bin/akash
 ```

## 💳 Wallet Setup 
**Setup required variables `KEY_NAME` and `KEYRING_BACKEND` for wallet creation**
```sh
export KEY_NAME=julian
```


**🔑 How to add key if you haven't yet setup a key**
```sh
akash keys add $KEY_NAME  --keyring-backend file
```
:warning: **Important** write this mnemonic phrase in a safe place. It is the only way to recover your account if you ever forget your password.


**How to export keys** 🔒
```sh
akash keys export $KEY_NAME --keyring-backend file
```


**How to recover keys** 🔓
```sh
akash keys add $KEY_NAME --keyring-backend file --recover
```


**📬 How to retrieve and export `ACCOUNT_ADDRESS` as variable**
```sh
export ACCOUNT_ADDRESS=$(akash --keyring-backend file keys show $KEY_NAME -a)
echo $ACCOUNT_ADDRESS
```


**💰 How to check if there is enought `$AKT` to send transactions**
 
The balance indicated is denominated in uAKT (AKT x 10^-6) We're now setup to deploy.
```sh
akash query bank balances --node $AKASH_NODE $ACCOUNT_ADDRESS
```

ℹ️ **Note: You can buy `$AKT` on [BitMax](https://bitmax.io/register?inviteCode=LQDS1MMP) using this link** and withdraw them to your deployment `ACCOUNT_ADDRESS`


## 📜 Prepare for deployment
[Choose deployment image](https://github.com/ovrclk/awesome-akash)
Create a deployment configuration file: `deploy.yml` to deploy the `ovrclk/lunie-light` for [Lunie Light](https://github.com/ovrclk/lunie-light) Node app container using [SDL](https://github.com/ovrclk/docs/blob/5d695ab63f391ebf255d48859ed3f626040fbf47/sdl/README.md):

```sh
cat > deploy.yml <<EOF
---
version: "2.0"

services:
  web:
    image: ovrclk/lunie-light
    expose:
      - port: 3000
        as: 80
        to:
          - global: true

profiles:
  compute:
    web:
      resources:
        cpu:
          units: 0.1
        memory:
          size: 512Mi
        storage:
          size: 512Mi
  placement:
    westcoast:
      attributes:
        host: akash
      signedBy:
        anyOf:
          - "akash1365yvmc4s7awdyj3n2sav7xfx76adc6dnmlx63"
      pricing:
        web: 
          denom: uakt
          amount: 1000

deployment:
  web:
    westcoast:
      profile: web
      count: 1

EOF
```


**How to generate certificate** `requires $AKT fees` 
```sh
echo akash tx cert create client --chain-id $AKASH_CHAIN_ID --keyring-backend file --from $KEY_NAME --node $AKASH_NODE --fees 5000uakt
```
⚠️ **Important** certificate needs to be created only once per account and can be used across all deployments. 

**How to revore certificate** `requires $AKT fees` 
```sh
echo akash tx cert revoke --chain-id=$AKASH_CHAIN_ID --from=$KEY_NAME --node=$AKASH_NODE --fees=5000uakt --keyring-backend file 
```

## 💣 How to deploy 
`requires $AKT fees`
```sh
echo akash deploy create deploy.yml --from $KEY_NAME --chain-id $AKASH_CHAIN_ID --keyring-backend file --node $AKASH_NODE --fees 5000uakt
```

You should see a response similar to:

```text
jw@ChainLink:~$ akash deploy create deploy.yml --from $KEY_NAME --chain-id $AKASH_CHAIN_ID --keyring-backend $KEYRING_BACKEND --node $AKASH_NODE --fees 5000uakt
Enter keyring passphrase:
I[2021-03-14|16:43:00.592] tx sent successfully                         hash=58F0A15FCCB40B79BB98031DC43FB99DB2DB0824D966EE45B94C977EB39703B8 code=0 codespace= action=create-deployment dseq=83887
I[2021-03-14|16:43:03.834] deployment created                           addr=akash1ny2lt9mcfet63k8ur2ue9xqaunxe80we64hket dseq=83887
I[2021-03-14|16:43:03.834] order for deployment created                 addr=akash1ny2lt9mcfet63k8ur2ue9xqaunxe80we64hket dseq=83887 oseq=1
I[2021-03-14|16:43:09.767] bid for order created                        addr=akash1ny2lt9mcfet63k8ur2ue9xqaunxe80we64hket dseq=83887 oseq=1 price=100uakt
D[2021-03-14|16:43:09.767] Processing bid
D[2021-03-14|16:43:09.767] All groups have at least one bid
I[2021-03-14|16:43:24.767] Done waiting on bids                         qty=1
I[2021-03-14|16:43:24.767] Winning bid                                  gseq=1 price=100uakt provider=akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz
I[2021-03-14|16:43:28.417] All expected leases created                  addr=akash1ny2lt9mcfet63k8ur2ue9xqaunxe80we64hket dseq=83887
I[2021-03-14|16:43:28.417] lease for order created                      addr=akash1ny2lt9mcfet63k8ur2ue9xqaunxe80we64hket dseq=83887 oseq=1 price=100uakt
I[2021-03-14|16:43:28.417] Waiting on leases to be ready                leaseQuantity=1
D[2021-03-14|16:43:28.417] Checking status of lease                     lease=akash1ny2lt9mcfet63k8ur2ue9xqaunxe80we64hket/83887/1/1/akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz
D[2021-03-14|16:43:28.528] Could not get lease status                   lease=akash1ny2lt9mcfet63k8ur2ue9xqaunxe80we64hket/83887/1/1/akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz err="remote server returned 404"
I[2021-03-14|16:43:28.918] sending manifest to provider                 action=send-manifest provider=akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz dseq=83887
D[2021-03-14|16:43:29.055] Could not get lease status                   lease=akash1ny2lt9mcfet63k8ur2ue9xqaunxe80we64hket/83887/1/1/akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz err="remote server returned 503"
I[2021-03-14|16:43:36.133] service ready                                lease=akash1ny2lt9mcfet63k8ur2ue9xqaunxe80we64hket/83887/1/1/akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz service=web
I[2021-03-14|16:43:36.133] lease ready                                  leaseID=akash1ny2lt9mcfet63k8ur2ue9xqaunxe80we64hket/83887/1/1/akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz
{
 "name": "web",
 "available": 1,
 "total": 1,
 "uris": [
  "5pvofe14fp8uhcmi1lhij63g0s.ingress.ams1p0.mainnet.akashian.io"
 ],
 "observed_generation": 1,
 "replicas": 1,
 "updated_replicas": 1,
 "ready_replicas": 1,
 "available_replicas": 1
}
```

ℹ️ **Note:** 🎉 `SERVICE_NAME` is "web"
```sh
export SERVICE_NAME=web 
```

**How to retrive market lease for `PROVIDER`, `DSEQ`, `GSEQ` and `OSEQ` information**
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

and export the following variables `PROVIDER`, `DSEQ`, `GSEQ`, `OSEQ` from **your** deployment.

```sh
export PROVIDER=akash1ccktptfkvdc67msasmesuy5m7gpc76z75kukpz
export DSEQ=83876
export GSEQ=1
export OSEQ=1

echo $PROVIDER $DSEQ $GSEQ $OSEQ
``` 

**How to verify deployment creation**
```sh
# List all deloyments
akash query deployment list --owner $ACCOUNT_ADDRESS --chain-id $AKASH_CHAIN_ID --node $AKASH_NODE

# List specific dployment
akash query deployment get --owner $ACCOUNT_ADDRESS --node $AKASH_NODE --dseq $DSEQ
``` 

**How to list market bid**
```sh
akash query market bid list --owner $ACCOUNT_ADDRESS --chain-id $AKASH_CHAIN_ID --node $AKASH_NODE
``` 

**How to create market lease**
```sh
akash  tx market lease create --from $KEY_NAME --owner $ACCOUNT_ADDRESS --chain-id $AKASH_CHAIN_ID --node $AKASH_NODE --dseq $DSEQ --oseq $OSEQ --gseq $GSEQ --provider $PROVIDER --fees=500uakt --keyring-backend file
``` 


**How to get market lease**
```sh
akash query market lease list --owner $ACCOUNT_ADDRESS --chain-id $AKASH_CHAIN_ID --node $AKASH_NODE
akash query market lease get --owner $ACCOUNT_ADDRESS --dseq $DSEQ --oseq $OSEQ --gseq $GSEQ --provider $PROVIDER --chain-id $AKASH_CHAIN_ID --node $AKASH_NODE

``` 

**🔍 How to view deployment**
```sh
akash provider lease-status --log_level=info --dseq $DSEQ --from $KEY_NAME --home ~/.akash --provider $PROVIDER --keyring-backend file --node $AKASH_NODE
```

**📝 How to view logs**
```sh
akash --node $AKASH_NODE provider service-logs --service $SERVICE_NAME --owner $ACCOUNT_ADDRESS --dseq $DSEQ --gseq $GSEQ --oseq $OSEQ --provider $PROVIDER
akash --node $AKASH_NODE provider lease-logs --from $ACCOUNT_ADDRESS --provider $PROVIDER --dseq $DSEQ --keyring-backend file --service SERVICE_NAME --home ~/.akash 
```


**♻️ How to Update Deployment** `requires $AKT fees`
```sh
echo akash tx deployment update deploy.yml --from $KEY_NAME --node $AKASH_NODE --chain-id $AKASH_CHAIN_ID --fees 5000uakt --keyring-backend file --dseq $DSEQ 
``` 


**❌ How to close deployment** `requires $AKT fees`
```sh
echo akash tx deployment close --node $AKASH_NODE --chain-id $AKASH_CHAIN_ID --dseq $DSEQ  --owner $ACCOUNT_ADDRESS --from $KEY_NAME --keyring-backend file -y --fees 5000uakt  --gas=auto
``` 

### 💡 End 💲 `AKT` 🚀 🌕

[![Top Langs](https://github-readme-stats.vercel.app/api/top-langs/?username=JulianWe&layout=compact)](https://github.com/anuraghazra/github-readme-stats)





