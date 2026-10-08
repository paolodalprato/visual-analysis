# Visual Analysis

A skill for Codex and Claude that produces a deep, curatorial reading of one image and delivers a formatted PDF containing that image.

Current version: 0.24.3. See the [changelog](CHANGELOG.md).

## What it does

Visual Analysis examines what an image communicates and how its visual choices produce that meaning. It covers:

- Composition and visual hierarchy: what attracts the eye, where it moves, and how figures, spaces, and directions relate.
- Light and tonal values: distribution, shadows, highlights, contrast, and expressive function.
- Color: relationships, emphasis, separation, and atmosphere.
- Technical reading: visible choices appropriate to photography, painting, drawing, illustration, or graphic design.
- Action and narrative: gestures, opposing forces, and possible developments that a single frame leaves unresolved.
- Strengths and limits: specific judgments supported by visible details.
- Artistic and photographic references: only when relevant, with a consistency check between the interpretation and its sources.

It analyzes photographs, paintings, drawings, illustrations, digital art, posters, covers, logos, and other images with an aesthetic purpose. Charts, tables, and operational diagrams are outside its scope.

It reads the work as presented. It does not propose retouching, alternate compositions, or changes to the author's work.

## How it works

1. Image reading: examines the attached image and identifies the relationships that matter.
2. Interpretation: explains what the image communicates and connects each judgment to visible evidence.
3. Critical review: checks technical claims, strengths and limits, and the consistency of artistic references.
4. PDF: produces a sober editorial document with the complete image, the analysis, and a final critical synthesis.

The report follows the language of the request or conversation. English is the fallback when no other language can be determined.

## Where it works

| Environment | Installation |
| --- | --- |
| Codex desktop, CLI, and IDE extension | Local installer or manual copy |
| Claude Code | Local installer or manual copy |
| Claude Chat and Claude Desktop Chat | Upload the skill ZIP to the Claude account |
| Claude Cowork | Upload the skill ZIP to the Claude account |

Claude Code's local skills folder does not install a skill into Claude Chat or Cowork. Those environments use skills enabled in the Claude account.

## Requirements

An installed, signed-in host that supports custom skills and can read images. PDF creation requires file creation or code execution in that host. In Claude Chat, enable Code execution and file creation.

The installer requires no Git, Python, API key, or administrator access. It copies the skill into the selected host's personal skills directory. Visual Analysis uses the host's model and available tools.

## Installation

### Option 1: Windows installer

1. Download the installation ZIP from [Releases page](https://github.com/paolodalprato/visual-analysis/releases/latest).
2. Extract the entire archive.
3. Double-click install.cmd.
4. Choose Codex, Claude Code, or both.
5. Start a new session in the selected application.

For installation from a terminal:

    powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Target codex

Replace codex with claude or both as needed. The launcher applies its execution policy only to that process.

### Option 2: macOS or Linux installer

Download and extract the installation ZIP. Open a terminal in the extracted folder and run:

    sh install.sh

Choose Codex, Claude Code, or both. A direct command is also available:

    sh install.sh codex

Replace codex with claude or both as needed. Start a new session after installation.

### Option 3: Claude Chat, Desktop Chat, or Cowork

1. Download [visual-analysis-skill.zip](https://github.com/paolodalprato/visual-analysis/releases/latest/download/visual-analysis-skill.zip) from Releases, or use the copy inside the installation archive.
2. Keep this ZIP intact.
3. Open Claude and go to Customize > Skills.
4. Select +, then Create skill, then Upload a skill.
5. Upload the ZIP and enable Visual Analysis.

### Option 4: Manual installation or Git clone

Copy the visual-analysis folder from this repository into the appropriate skills directory:

| Host | Windows | macOS / Linux |
| --- | --- | --- |
| Codex | C:\Users\<username>\.agents\skills\ | ~/.agents/skills/ |
| Claude Code | C:\Users\<username>\.claude\skills\ | ~/.claude/skills/ |

Create the skills directory if necessary. The result must be a folder named visual-analysis containing SKILL.md.

If the repository was downloaded with GitHub's Code > Download ZIP button, the installers are in the extracted repository root. The skill folder is inside that root.

## Verify the installation

Start a new session, attach one image, and invoke Visual Analysis. In Codex, select the skill or type $visual-analysis. In Claude Code, use /visual-analysis. In Claude Chat or Cowork, ask Claude to use Visual Analysis on the attached image.

No title, author, camera settings, or other preliminary details are required. The PDF should contain the image and a specific, supported reading of it.

## Updates and backups

Download the new installation ZIP and run the installer again. Before replacing an existing visual-analysis folder, it saves that folder under ~/.visual-analysis/backups/. On Windows, this is in the user's profile folder. Backups are outside the skills directories so they do not appear as duplicate skills.

For Claude account skills, upload the new skill ZIP through Customize > Skills.

To remove a local installation, remove only the visual-analysis folder from the selected host's skills directory. Remove an uploaded Claude skill through Customize > Skills.

## Structure

    visual-analysis/
    ├── SKILL.md
    ├── LICENSE
    ├── agents/
    │   └── openai.yaml
    └── assets/
        └── icon.png
    install.cmd
    install.ps1
    install.sh
    README.md
    CHANGELOG.md
    LICENSE

The installation archive contains these files. The Claude upload archive contains only the visual-analysis skill folder.

## Scope and limitations

The skill can identify visible technical effects, but it cannot reliably recover camera settings, equipment, authorship, or an event's outcome from appearance alone. It distinguishes observations from interpretations.

It contains no user photographs, sample reports, credentials, connectors, or marketplace configuration. It does not upload images itself; the selected host handles the conversation and its attachments.

If the host cannot generate a PDF, Visual Analysis provides the complete analysis in the conversation and explains the file creation limitation.

## Contributing

Issues and pull requests are welcome. Useful reports include the host, the operating system, and the behavior observed. Image examples should be shared only with the appropriate rights.

## Documentation

- [OpenAI: local skills](https://learn.chatgpt.com/docs/build-skills)
- [Claude Code: skills](https://code.claude.com/docs/en/skills)
- [Claude: upload and use custom skills](https://support.claude.com/en/articles/12512180-use-skills-in-claude)

## License

[MIT](LICENSE). Copyright (c) 2026 Paolo Dalprato.

The license is included in both the repository and the installable skill folder.

## Authors

- Author: Paolo Dalprato.
- Co-author: GPT-6 Sol (OpenAI), for the development of the analytical workflow, instructions, and installation package in collaboration with Paolo Dalprato.
