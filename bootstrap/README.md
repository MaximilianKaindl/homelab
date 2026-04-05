# Bootstrap

This directory represents the machine-bootstrap layer of the homelab.

The public repository includes a limited subset of real bootstrap code where the files are already generic enough to share safely.

Included here:

- host-prep entrypoint playbooks for `build-01` and `git-01`
- the parameterized Terraform root for `git-01`
- the Docker Compose payload for the self-hosted GitLab VM

Still omitted:

- CI pipeline wiring
- local `.env` files
- Terraform state, plans, and module caches
- bootstrap files that still encode internal control-plane or edge-routing assumptions
