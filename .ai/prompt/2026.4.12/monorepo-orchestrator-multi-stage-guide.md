# Monorepo Release Orchestrator - Multi-Stage Support

## Overview

The Monorepo Release Orchestrator now supports three different release stages:
- **Production**: Full production release using `rw_release_complete.yaml`
- **Staging**: Staging/RC release using `rw_release_staging_complete.yaml`
- **Validation**: Pre-release validation using `rw_release_validation_complete.yaml`

## Usage

### Basic Example - Production Release (Default)

```yaml
jobs:
  release:
    uses: Chisanan232/GitHub-Action_Reusable_Workflows-Python/.github/workflows/rw_monorepo_release_orchestrator.yaml@master
    with:
      packages: '["core", "utils"]'
      release-mode: sequential
    secrets:
      DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}
      DOCKERHUB_TOKEN: ${{ secrets.DOCKERHUB_TOKEN }}
      PYPI_API_TOKEN: ${{ secrets.PYPI_API_TOKEN }}
      TEST_PYPI_API_TOKEN: ${{ secrets.TEST_PYPI_API_TOKEN }}
```

### Staging Release

```yaml
jobs:
  staging-release:
    uses: Chisanan232/GitHub-Action_Reusable_Workflows-Python/.github/workflows/rw_monorepo_release_orchestrator.yaml@master
    with:
      packages: '["core", "utils"]'
      release-stage: staging  # Use staging workflow
      release-mode: sequential
    secrets:
      DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}
      DOCKERHUB_TOKEN: ${{ secrets.DOCKERHUB_TOKEN }}
      PYPI_API_TOKEN: ${{ secrets.PYPI_API_TOKEN }}
      TEST_PYPI_API_TOKEN: ${{ secrets.TEST_PYPI_API_TOKEN }}
```

### Validation Only

```yaml
jobs:
  validate-release:
    uses: Chisanan232/GitHub-Action_Reusable_Workflows-Python/.github/workflows/rw_monorepo_release_orchestrator.yaml@master
    with:
      packages: '["core", "utils"]'
      release-stage: validation  # Use validation workflow
      release-mode: parallel  # Can run validations in parallel
    # Note: Validation workflow doesn't require secrets
```

### Advanced Example - Custom Release Configuration

```yaml
jobs:
  custom-release:
    uses: Chisanan232/GitHub-Action_Reusable_Workflows-Python/.github/workflows/rw_monorepo_release_orchestrator.yaml@master
    with:
      packages: '["core", "utils"]'
      release-stage: production
      level: minor  # Force minor version bump
      python: force  # Force Python package release
      docker: skip  # Skip Docker image release
      docs: auto  # Auto-detect documentation needs
      notes: |
        ## What's New
        - Feature A
        - Feature B
      release-mode: sequential
    secrets:
      DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}
      DOCKERHUB_TOKEN: ${{ secrets.DOCKERHUB_TOKEN }}
      PYPI_API_TOKEN: ${{ secrets.PYPI_API_TOKEN }}
      TEST_PYPI_API_TOKEN: ${{ secrets.TEST_PYPI_API_TOKEN }}
```

## Input Parameters

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `packages` | JSON array of package names to release | `[]` (auto-detect) | No |
| `base-ref` | Base reference for change detection | Repository default branch | No |
| `release-mode` | Release mode: `parallel` or `sequential` | `sequential` | No |
| `release-stage` | Release stage: `production`, `staging`, or `validation` | `production` | No |
| `level` | Release level: `auto`, `patch`, `minor`, or `major` | `auto` | No |
| `python` | Python package release: `auto`, `force`, or `skip` | `auto` | No |
| `docker` | Docker image release: `auto`, `force`, or `skip` | `auto` | No |
| `docs` | Documentation versioning: `auto`, `force`, or `skip` | `auto` | No |
| `notes` | Release notes text | `''` (empty) | No |
| `dry-run` | Dry run mode - show what would be released | `false` | No |

### Parameter Support by Stage

| Parameter | Production | Staging | Validation |
|-----------|-----------|---------|------------|
| `level` | ✅ | ✅ | ✅ |
| `python` | ✅ | ❌ | ✅ |
| `docker` | ✅ | ❌ | ✅ |
| `docs` | ✅ | ❌ | ✅ |
| `notes` | ✅ | ❌ | ❌ |

## Permissions

The orchestrator requires the following permissions:

```yaml
permissions:
  contents: write    # For creating tags and releases
  packages: write    # For publishing packages
  id-token: write    # For OIDC authentication
```

**Note:** These permissions are required for production and staging releases. Validation only needs read permissions, but the orchestrator must declare write permissions to support all stages.

## Secrets

Required secrets depend on the release stage:

### Production & Staging
- `DOCKERHUB_USERNAME` (optional)
- `DOCKERHUB_TOKEN` (optional)
- `PYPI_API_TOKEN` (optional)
- `TEST_PYPI_API_TOKEN` (optional)

### Validation
- No secrets required

## Workflow Behavior

### Stage-Specific Jobs

The orchestrator creates three conditional jobs:
1. `release-packages-production` - Runs when `release-stage == 'production'`
2. `release-packages-staging` - Runs when `release-stage == 'staging'`
3. `release-packages-validation` - Runs when `release-stage == 'validation'`

Only one job will execute based on the selected stage.

### Auto-Detection

When `packages` is empty (`[]`), the orchestrator automatically detects changed packages by:
1. Loading package definitions from `intent.yaml`
2. Comparing changes against `base-ref`
3. Identifying packages with modifications

### Release Modes

- **Sequential**: Releases packages one at a time (`max-parallel: 1`)
- **Parallel**: Releases up to 10 packages simultaneously (`max-parallel: 10`)

## Example Workflows

### CI/CD Pipeline with Validation → Staging → Production

```yaml
name: Complete Release Pipeline

on:
  push:
    branches: [main]

jobs:
  # Step 1: Validate
  validate:
    uses: Chisanan232/GitHub-Action_Reusable_Workflows-Python/.github/workflows/rw_monorepo_release_orchestrator.yaml@master
    with:
      release-stage: validation
      release-mode: parallel

  # Step 2: Staging Release
  staging:
    needs: [validate]
    if: needs.validate.outputs.all-successful == 'true'
    uses: Chisanan232/GitHub-Action_Reusable_Workflows-Python/.github/workflows/rw_monorepo_release_orchestrator.yaml@master
    with:
      release-stage: staging
      release-mode: sequential
    secrets:
      DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}
      DOCKERHUB_TOKEN: ${{ secrets.DOCKERHUB_TOKEN }}
      TEST_PYPI_API_TOKEN: ${{ secrets.TEST_PYPI_API_TOKEN }}

  # Step 3: Production Release (manual approval)
  production:
    needs: [staging]
    if: needs.staging.outputs.all-successful == 'true'
    environment: production  # Requires manual approval
    uses: Chisanan232/GitHub-Action_Reusable_Workflows-Python/.github/workflows/rw_monorepo_release_orchestrator.yaml@master
    with:
      release-stage: production
      release-mode: sequential
    secrets:
      DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}
      DOCKERHUB_TOKEN: ${{ secrets.DOCKERHUB_TOKEN }}
      PYPI_API_TOKEN: ${{ secrets.PYPI_API_TOKEN }}
```

## Outputs

| Output | Description |
|--------|-------------|
| `packages-released` | JSON array of packages that were released |
| `release-count` | Number of packages released |
| `all-successful` | Whether all releases succeeded (`true`/`false`) |

## Summary Display

The workflow generates a summary showing:
- Mode (Dry Run or Live Release)
- Stage (production, staging, or validation)
- Package count and list
- Success/failure status

Example summary:
```
## Monorepo Release Orchestrator Summary

🚀 **Mode**: Live Release
🎯 **Stage**: staging
📊 **Packages to release**: 2

**Package List**:
- core
- utils

✅ All package releases completed successfully!
```

## Migration from Previous Version

If you're using the old orchestrator without stage support:

**Before:**
```yaml
uses: .../rw_monorepo_release_orchestrator.yaml@master
with:
  packages: '["core"]'
secrets: inherit  # This was broken
```

**After:**
```yaml
uses: .../rw_monorepo_release_orchestrator.yaml@master
with:
  packages: '["core"]'
  release-stage: production  # Optional, defaults to production
secrets:
  DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}
  DOCKERHUB_TOKEN: ${{ secrets.DOCKERHUB_TOKEN }}
  PYPI_API_TOKEN: ${{ secrets.PYPI_API_TOKEN }}
  TEST_PYPI_API_TOKEN: ${{ secrets.TEST_PYPI_API_TOKEN }}
```

## Benefits

1. **Unified Interface**: Single orchestrator for all release stages
2. **Flexible Testing**: Validate before staging, stage before production
3. **Parallel Validation**: Run validation checks in parallel for speed
4. **Sequential Releases**: Ensure production releases happen one at a time
5. **Clear Separation**: Each stage uses its dedicated workflow with appropriate permissions
