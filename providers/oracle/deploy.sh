#!/usr/bin/env bash
# Launches one Always Free ARM VM via the OCI CLI. Does not create an account.
set -euo pipefail

: "${COMPARTMENT_ID:?set COMPARTMENT_ID}"
: "${SUBNET_ID:?set SUBNET_ID}"
: "${AVAILABILITY_DOMAIN:?set AVAILABILITY_DOMAIN}"
: "${IMAGE_ID:?set IMAGE_ID (Ubuntu 22.04 aarch64)}"
: "${SSH_PUBLIC_KEY:?set SSH_PUBLIC_KEY path}"

command -v oci >/dev/null 2>&1 || { echo "Install the OCI CLI first." >&2; exit 1; }
[ -f "$SSH_PUBLIC_KEY" ] || { echo "No SSH public key at $SSH_PUBLIC_KEY" >&2; exit 1; }

INSTANCE_ID="$(oci compute instance launch \
  --compartment-id "$COMPARTMENT_ID" \
  --availability-domain "$AVAILABILITY_DOMAIN" \
  --subnet-id "$SUBNET_ID" \
  --shape VM.Standard.A1.Flex \
  --shape-config '{"OCPUs":1,"MemoryInGB":6}' \
  --image-id "$IMAGE_ID" \
  --ssh-authorized-keys-file "$SSH_PUBLIC_KEY" \
  --assign-public-ip true \
  --display-name us-browser-vnc \
  --query 'data.id' --raw-output)"

for _ in $(seq 1 30); do
  STATE="$(oci compute instance get --instance-id "$INSTANCE_ID" --query 'data."lifecycle-state"' --raw-output 2>/dev/null || true)"
  [ "$STATE" = "RUNNING" ] && break
  sleep 10
done

PUBLIC_IP="$(oci compute instance list-vnics --compartment-id "$COMPARTMENT_ID" \
  --instance-id "$INSTANCE_ID" --query 'data[0]."public-ip"' --raw-output)"

echo "Instance: $INSTANCE_ID"
echo "Public IP: $PUBLIC_IP"
echo "Next steps (run yourself):"
echo "  scp -r . ubuntu@$PUBLIC_IP:~/us-browser-vnc"
echo "  ssh ubuntu@$PUBLIC_IP 'cd ~/us-browser-vnc && bash scripts/bootstrap.sh'"
echo "Remember to allow 80/443/6080 in the VCN security list."
