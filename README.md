![test](https://github.com/progrhyme/gcloud-prompt/workflows/test/badge.svg)

# gcloud-prompt

Fetch gcloud client configuration information to show on shell prompt.

Currently, Bash & Zsh are supported.
Prompts built by external processes, such as [Starship](https://starship.rs/), are also supported.

# Usage

## Zsh

```sh
. path/to/gcloud-prompt/gcloud-prompt.sh
# Example prompt setting
PROMPT="%F{cyan}[\$(gcloud_prompt)]%f %n@%m%# "
```

## Bash

```sh
. path/to/gcloud-prompt/gcloud-prompt.sh
# Example prompt setting
PS1="\[\e[0;36m\]<\$(gcloud_prompt)>\[\e[m\]\n\h:\W \u\$ "
```

Execute `toggle_gcloud_prompt` function to hide/show gcloud information.

## Starship

`gcloud_prompt_export` exports the output of `gcloud_prompt` as `$GCLOUD_PROMPT_TEXT`.
Call it before each prompt and show the variable with Starship's `env_var` module.
`$GCLOUD_PROMPT_TEXT` is unset while the prompt is hidden by `toggle_gcloud_prompt`,
so the module is hidden too.

```sh
# ~/.zshrc
. path/to/gcloud-prompt/gcloud-prompt.sh
precmd_functions+=(gcloud_prompt_export)
eval "$(starship init zsh)"
```

```toml
# ~/.config/starship.toml
[env_var.GCLOUD_PROMPT_TEXT]
variable = "GCLOUD_PROMPT_TEXT"
format = "[$env_value]($style) "
style = "cyan"
```

# Examples

Here are some output examples.

```sh
# Default setting & default configuration
$ gcloud_prompt
default|bob@example.com,my-project

# GCLOUD_PROMPT_CONFIG_KEYS=(core.project compute.region)
$ gcloud_prompt
default|my-project,asia-northeast1

# GCLOUD_PROMPT_SHOW_CONFIG_PARAMS=no
$ gcloud_prompt
default
```

# Configuration

You can change below variables to customize the prompt output.

 Variable | Default | Type | Description
----------|:-------:|:----:|---------------
 GCLOUD_PROMPT_ENABLED | on | String | If this variable is not set, `gcloud_prompt` prints nothing
 GCLOUD_PROMPT_SHOW_CONFIG_PARAMS | yes | String | If this variable doesn't equal to "yes", only current active configuration shows on prompt
 GCLOUD_PROMPT_CONFIG_KEYS | `(core.account core.project)` | Array | When `GCLOUD_PROMPT_SHOW_CONFIG_PARAMS` is set to `yes`, these properties appears on prompt
 GCLOUD_PROMPT_SEPARATOR | `\|` | String | Delimiter between active configuration and config properties

For available properties to set in `GCLOUD_PROMPT_CONFIG_KEYS`, refer to https://cloud.google.com/sdk/gcloud/reference/config/get-value

# Dependencies

This script depends on the current implementation of Cloud SDK; such as configuration
directory structure, configuration data structure etc.

# License

The MIT License.

Copyright (c) 2020 IKEDA Kiyoshi.
