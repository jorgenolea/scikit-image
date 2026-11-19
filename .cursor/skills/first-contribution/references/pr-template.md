# Pull-request draft

Draft the description. Do not open or push a pull request unless asked.

Upstream sections follow [.github/PULL_REQUEST_TEMPLATE.md](../../../../.github/PULL_REQUEST_TEMPLATE.md) and [CONTRIBUTING.md](../../../../CONTRIBUTING.md) ("Before submitting the pull request", "Review process", "Document changes", and "AI Policy"). Acme sections are SYNTH additions from the [conventions inventory](../../../../docs/acme/conventions-inventory.md). They are not in the upstream template or the contributor guide.

## Upstream requirements

- Title: concise and descriptive. The contributor guide does not require a ticket prefix.
- Description: state the change and link the relevant context.
- A maintainer adds a category label. CI fails on a new pull request until that label is present ([CONTRIBUTING.md](../../../../CONTRIBUTING.md)).
- Suggest `run-all-tests` only when the change is not confined to one subpackage ([testing.md](../../../../doc/source/development/testing.md)).
- Release note: changelist builds it from the title and labels. The template's `release-note` block is optional. Include it only when the title is not enough. Do not edit `doc/source/release_notes/` by hand.
- A deprecation that schedules a removal still needs a `TODO.txt` reminder ([CONTRIBUTING.md](../../../../CONTRIBUTING.md), "Document changes").
- AI use: required only when generative tools were used. [CONTRIBUTING.md](../../../../CONTRIBUTING.md), "AI requirements": "If you use AI as above, you must: Always declare tool usage." Say which part of the task. Omit the note when no AI was used. A person writes the description. That policy also says not to use AI to write pull-request descriptions.

## Acme additions

Not upstream requirements. The ticket-id title is a SYNTH inventory row. Nothing in this repository's workflows checks the prefix.

- Title form: `ACME-123: Concise description`.
- Problem and change summary.
- Acceptance-criteria evidence: each criterion mapped to code, a test, or check output.
- Actual checks and results from [check.sh](../scripts/check.sh). Quote the command and the output it printed, including a non-zero exit. If the script or a required command is missing, say that. Do not write that checks passed unless the output says so.
- Optional release-note text, and only when the upstream block is warranted. Leave it out when the title is enough.

## Skeleton

````markdown
<!--
Upstream. Contribution guide:
https://scikit-image.org/docs/dev/development/contribute.html
AI policy:
https://scikit-image.org/docs/dev/development/contribute.html#ai-policy
-->

<!-- Problem, change, and links to context. -->

### Release note (optional)

<!-- Upstream. Omit this whole section when the title is enough for changelist.
See CONTRIBUTING.md, "Document changes". -->

```release-note
...
```

<!-- Acme additions. Not part of the upstream template. -->

### Ticket

ACME-123: Concise description

### Problem and change

...

### Acceptance criteria

- Criterion: evidence (path, test, or check output)

### Checks

Command and output from `.cursor/skills/first-contribution/scripts/check.sh`.
Paste the run. Do not replace it with a summary.

### AI use

Omit this heading when no generative tool was used.
Otherwise name the tool and which part of the task it did.
````
