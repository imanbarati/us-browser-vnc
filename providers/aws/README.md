# AWS EC2 free tier (US region)

AWS does not provide VNC as a service. You launch **one** t2.micro Ubuntu VM in
a US region (for example `us-east-1`) and run the noVNC stack on it. The VM's IP
is an AWS datacenter IP.

## Before you start

- Create your own AWS account on `signin.aws.amazon.com` and configure
  `aws configure` locally. I do not create accounts or store credentials.
- Stay inside the free tier and set a billing alarm. Free tier is time-limited.
- Read the AWS Customer Agreement and Acceptable Use Policy.

## Deploy

```bash
export AWS_PROFILE=default
export AWS_REGION=us-east-1
export SSH_PUBLIC_KEY="$HOME/.ssh/id_rsa.pub"
bash providers/aws/deploy.sh
```

The script prints the SSH/SCP commands to copy this repo and run
`scripts/bootstrap.sh` on the VM. It opens port 22 only to your current IP, and
80/443 publicly for HTTPS. No credentials are written to the repo.

## Limits

t2.micro is 1 GB RAM — enough for one Chromium session, not heavy browsing.
The IP is a well-known cloud range; many consumer sites challenge or block it.
