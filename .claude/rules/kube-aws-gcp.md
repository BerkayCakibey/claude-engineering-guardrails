# Kubernetes, AWS, and GCP Safety Rules

Default mode is read-only investigation. Mutating cloud or cluster resources requires explicit user approval and a clear rollback path.

## Operating Principles

1. Verify identity and target before every cloud or cluster operation.
2. Prefer read-only commands until the user explicitly asks for a change.
3. Treat production, shared clusters, IAM, networking, databases, and public exposure as high risk.
4. Never print secrets, tokens, private keys, kubeconfigs, or credential material.
5. Keep command output concise; summarize large plans, logs, and resource lists.

## Pre-Flight Checklist

Before proposing or running any infrastructure command, identify:

- Cloud provider and account/project/subscription.
- Region, cluster, namespace, or environment.
- Whether the target is production, staging, development, or unknown.
- Whether the command is read-only or mutating.
- Verification command and rollback path if mutation is requested.

If any target detail is unclear, ask before continuing.

## Kubernetes

Safe diagnostic commands:

```bash
kubectl config current-context
kubectl config get-contexts
kubectl get ...
kubectl describe ...
kubectl logs ...
kubectl top ...
kubectl auth can-i ...
```

Commands that require explicit approval:

```bash
kubectl apply ...
kubectl delete ...
kubectl patch ...
kubectl scale ...
kubectl rollout restart ...
kubectl exec ...
kubectl cp ...
kubectl port-forward ...
```

Kubernetes workflow:

1. Run `kubectl config current-context`.
2. Confirm namespace with `kubectl config view --minify` or an explicit `-n`.
3. Use `kubectl diff` before `kubectl apply` when possible.
4. For rollouts, inspect current state first with `kubectl rollout status` and `kubectl describe`.
5. After an approved mutation, verify with `kubectl get`, `kubectl describe`, or `kubectl rollout status`.

Never assume production safety from cluster names alone. If the namespace or context looks shared or production-like, escalate.

## AWS

Safe diagnostic commands:

```bash
aws sts get-caller-identity
aws configure list-profiles
aws <service> describe-...
aws <service> list-...
aws <service> get-...
```

Commands that require explicit approval:

```bash
aws <service> create-...
aws <service> update-...
aws <service> delete-...
aws <service> put-...
aws <service> attach-...
aws <service> detach-...
aws <service> modify-...
```

AWS workflow:

1. Confirm profile and account with `aws sts get-caller-identity`.
2. Confirm region before resource inspection or mutation.
3. Use service-specific dry-run or preview modes where available.
4. Treat IAM, KMS, Route53, CloudFront, S3 bucket policy, RDS, and security groups as high-risk categories.
5. Never dump secret values from Secrets Manager, SSM Parameter Store secure strings, or environment variables.

For Terraform-managed AWS resources, prefer Terraform plan review over direct AWS mutations.

## GCP

Safe diagnostic commands:

```bash
gcloud config list
gcloud projects list
gcloud <service> list ...
gcloud <service> describe ...
```

Commands that require explicit approval:

```bash
gcloud <service> create ...
gcloud <service> update ...
gcloud <service> delete ...
gcloud <service> set-iam-policy ...
gcloud <service> add-iam-policy-binding ...
gcloud <service> remove-iam-policy-binding ...
```

GCP workflow:

1. Confirm active account and project with `gcloud config list`.
2. Confirm region/zone for compute, GKE, and database resources.
3. Treat IAM, service accounts, firewall rules, public buckets, load balancers, and Cloud SQL as high risk.
4. Use describe/list first, then propose the smallest change.
5. Verify after approved mutation with describe/list output.

## Sensitive Data Handling

Never output:

- credentials
- tokens
- private keys
- kubeconfig contents
- database passwords
- signed URLs
- secret environment variables
- full connection strings

If a command may reveal secrets, either avoid it or redact values before showing output.

## Escalation Rules

Escalate before continuing when:

- The environment is production or unknown.
- The command mutates infrastructure or cluster state.
- The action changes IAM, networking, database, DNS, or public exposure.
- The rollback path is unclear.
- The output includes secret-like material.

If the user asks for a dangerous direct command, propose a safer inspection or plan-first alternative.
