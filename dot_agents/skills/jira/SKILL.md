---
name: jira-acli
description: Interact with Jira using the Atlassian CLI (acli). Use when the user needs to create, update, transition, or manage Jira work items (issues), manage authentication, or perform administrative tasks via command line. Covers work item CRUD operations, status transitions, user management, and authentication workflows.
---

# Jira ACLI

Interact with Jira using the Atlassian Command Line Interface (acli).

## Prerequisites

Ensure `acli` is installed on the system. See [installation guide](https://developer.atlassian.com/cloud/acli/guides/install-acli/).

## Authentication

### API Token (Recommended)

Generate an API token from [Atlassian account settings](https://id.atlassian.com/manage-profile/security/api-tokens).

Login via stdin:
```bash
echo "<token>" | acli jira auth login --site "mysite.atlassian.net" --email "user@atlassian.com" --token
```

Or from file:
```bash
acli jira auth login --site "mysite.atlassian.net" --email "user@atlassian.com" --token < token.txt
```

### OAuth (Interactive)

```bash
acli jira auth login --web
```

Opens browser for authentication. Select the same site in terminal after accepting.

## Command Structure

```bash
acli jira <entity> <action> [FLAGS]
```

- `entity`: The Jira object (e.g., `workitem`, `auth`, `project`)
- `action`: The operation (e.g., `create`, `edit`, `transition`, `list`)
- `FLAGS`: Optional parameters (defaults apply if omitted)

## Work Item Operations

### Create Work Item

```bash
# Quick create with summary, project, and type
acli jira workitem create --summary "New Task" --project "TEAM" --type "Task"

# With assignee and labels
acli jira workitem create --summary "Bug fix" --project "PROJ" --type "Bug" --assignee "user@atlassian.com" --label "bug,cli"

# Create from file
acli jira workitem create --from-file "workitem.txt" --project "PROJ" --type "Bug"

# Generate JSON template for complex creation
acli jira workitem create --generate-json

# Create from JSON file
acli jira workitem create --from-json "workitem.json"
```

### Edit Work Item

```bash
# Edit by key(s)
acli jira workitem edit --key "KEY-1,KEY-2" --summary "New Summary"

# Edit by JQL query
acli jira workitem edit --jql "project = TEAM" --assignee "user@atlassian.com"

# Edit by filter ID
acli jira workitem edit --filter 10001 --description "Updated description" --yes

# Generate edit template
acli jira workitem edit --generate-json

# Edit from JSON
acli jira workitem edit --from-json "workitem.json"
```

### Transition Work Item

```bash
# Transition by key(s)
acli jira workitem transition --key "KEY-1,KEY-2" --status "Done"

# Transition by JQL
acli jira workitem transition --jql "project = TEAM" --status "In Progress"

# Transition by filter ID with auto-confirm
acli jira workitem transition --filter 10001 --status "To Do" --yes
```

### List/Search Work Items

```bash
# List by JQL
acli jira workitem list --jql "project = TEAM AND status = 'In Progress'"

# List by filter
acli jira workitem list --filter 10001
```

### Get Work Item Details

```bash
acli jira workitem get --key "KEY-1"
```

## Project Operations

```bash
# List projects
acli jira project list

# Get project details
acli jira project get --key "PROJ"
```

## User Management (Admin)

Requires admin API key authentication.

```bash
# Activate user by email
acli admin user activate --email "john@example.com"

# Activate multiple users
acli admin user activate --email "john@example.com,anna@example.com"

# Activate by account ID
acli admin user activate --id "abcd,123"

# Activate from file
acli admin user activate --from-file "users.txt"
```

## Common Flags

| Flag | Description |
|------|-------------|
| `--site` | Atlassian site (e.g., `mysite.atlassian.net`) |
| `--email` | User email for authentication |
| `--token` | API token (can be piped) |
| `--key` | Work item key(s), comma-separated |
| `--project` | Project key |
| `--type` | Work item type (Task, Bug, Story, etc.) |
| `--summary` | Work item title |
| `--description` | Work item description |
| `--assignee` | Assignee email |
| `--status` | Target status for transitions |
| `--label` | Comma-separated labels |
| `--jql` | JQL query string |
| `--filter` | Filter ID |
| `--from-file` | Read content from file |
| `--from-json` | Read content from JSON file |
| `--generate-json` | Generate JSON template |
| `--yes` | Auto-confirm prompts |
| `--output` | Output format (json, yaml, table) |

## Output Formats

Add `--output <format>` to any command:
- `json` - Machine-readable JSON
- `yaml` - YAML format
- `table` - Human-readable table (default)

## Examples

### Bulk Update Scenario

Update all open bugs in a project:
```bash
acli jira workitem edit \
  --jql "project = PROJ AND type = Bug AND status != Done" \
  --label "needs-review" \
  --output json
```

### Create and Transition

Create a bug and move it to In Progress:
```bash
KEY=$(acli jira workitem create --summary "Critical bug" --project "PROJ" --type "Bug" --output json | jq -r '.key')
acli jira workitem transition --key "$KEY" --status "In Progress"
```

### Export Work Items

Export issues to JSON for processing:
```bash
acli jira workitem list \
  --jql "project = TEAM AND updated >= -7d" \
  --output json > recent_issues.json
```

## Best Practices

1. **Always specify output format** when piping results: `--output json`
2. **Use `--yes` flag** for non-interactive scripts to auto-confirm prompts
3. **Store credentials securely** - use environment variables or secure vaults
4. **Use JQL for bulk operations** instead of multiple individual commands
5. **Test with `--output json`** and inspect before applying changes with `--yes`

## Troubleshooting

### Authentication Errors
- Verify API token is valid and not expired
- Check site URL format: `mysite.atlassian.net` (no https://)
- Ensure email matches Atlassian account

### Permission Errors
- Verify user has permissions for the project/operation
- Admin operations require organization admin API key

### JQL Syntax Errors
- Wrap JQL in quotes: `--jql "project = TEAM"`
- Escape special characters in strings

## References

- [ACLI Documentation](https://developer.atlassian.com/cloud/acli/)
- [JQL Reference](https://support.atlassian.com/jira-software-cloud/docs/advanced-search-reference-jql-fields/)
- [API Token Management](https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/)
