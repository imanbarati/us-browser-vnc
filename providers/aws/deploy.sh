#!/usr/bin/env bash
# Provisions a single t2.micro Ubuntu VM in a US region. It does NOT create an
# AWS account and does not store credentials. Configure AWS CLI yourself first.
set -euo pipefail

REGION="${AWS_REGION:-us-east-1}"
KEY_NAME="${KEY_NAME:-us-vnc-key}"
SSH_PUBLIC_KEY="${SSH_PUBLIC_KEY:-$HOME/.ssh/id_rsa.pub}"
SG_NAME="${SG_NAME:-us-browser-vnc}"

command -v aws >/dev/null 2>&1 || { echo "Install the AWS CLI first." >&2; exit 1; }
[ -f "$SSH_PUBLIC_KEY" ] || { echo "No SSH public key at $SSH_PUBLIC_KEY" >&2; exit 1; }

AMI="$(aws ssm get-parameter \
  --name /aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id \
  --region "$REGION" --query Parameter.Value --output text)"

SG_ID="$(aws ec2 describe-security-groups --region "$REGION" \
  --filters "Name=group-name,Values=$SG_NAME" --query 'SecurityGroups[0].GroupId' --output text 2>/dev/null || true)"
if [ -z "$SG_ID" ] || [ "$SG_ID" = "None" ]; then
  SG_ID="$(aws ec2 create-security-group --region "$REGION" \
    --group-name "$SG_NAME" --description 'noVNC browser (single VM)' --query GroupId --output text)"
fi

MY_IP="$(curl -fsS https://checkip.amazonaws.com | tr -d '\r\n')"
if [ -n "$MY_IP" ]; then
  aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$SG_ID" \
    --protocol tcp --port 22 --cidr "$MY_IP/32" >/dev/null 2>&1 || true
fi
for port in 80 443; do
  aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$SG_ID" \
    --protocol tcp --port "$port" --cidr 0.0.0.0/0 >/dev/null 2>&1 || true
done

aws ec2 import-key-pair --region "$REGION" --key-name "$KEY_NAME" \
  --public-key-material "fileb://$SSH_PUBLIC_KEY" >/dev/null 2>&1 || true

INSTANCE_ID="$(aws ec2 run-instances --region "$REGION" --image-id "$AMI" \
  --instance-type t2.micro --key-name "$KEY_NAME" --security-group-ids "$SG_ID" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=us-browser-vnc}]" \
  --query 'Instances[0].InstanceId' --output text)"

aws ec2 wait instance-running --region "$REGION" --instance-ids "$INSTANCE_ID"
PUBLIC_IP="$(aws ec2 describe-instances --region "$REGION" --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)"

echo "Instance: $INSTANCE_ID"
echo "Public IP: $PUBLIC_IP"
echo "Next steps (run yourself):"
echo "  scp -r . ubuntu@$PUBLIC_IP:~/us-browser-vnc"
echo "  ssh ubuntu@$PUBLIC_IP 'cd ~/us-browser-vnc && bash scripts/bootstrap.sh'"
echo "Then open https://YOUR-DOMAIN/vnc.html or http://$PUBLIC_IP:6080/vnc.html"
