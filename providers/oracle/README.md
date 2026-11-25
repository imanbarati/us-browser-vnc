# Oracle Cloud Always Free (US region)

Oracle's Always Free ARM shape (`VM.Standard.A1.Flex`, 1 OCPU / 6 GB) is the
best free persistent VM for this use case. Pick a US region such as
`us-ashburn-1` when creating the compartment/VCN. The IP is an Oracle datacenter
IP.

## Before you start

- Create your own Oracle Cloud account and OCI CLI keys. I do not create
  accounts or store credentials.
- Free ARM capacity is often unavailable; retry later or use a different US
  availability domain.
- Allow TCP 80, 443 and (optionally) 6080 in the VCN security list, and 22 from
  your IP.

## Deploy

```bash
export COMPARTMENT_ID=ocid1.compartment...
export SUBNET_ID=ocid1.subnet...
export AVAILABILITY_DOMAIN=...
export IMAGE_ID=ocid1.image...       # Ubuntu 22.04 aarch64
export SSH_PUBLIC_KEY="$HOME/.ssh/id_rsa.pub"
bash providers/oracle/deploy.sh
```

Then run the printed SCP/SSH commands and `scripts/bootstrap.sh`. The Compose
file builds an ARM-compatible Debian image.

## Limits

Still a datacenter IP; site bans and CAPTCHAs remain possible. Do not use this
to create multiple accounts or claim repeated promotional credits.
