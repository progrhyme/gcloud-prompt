## 0.6.0 (2020-05-23)

Improve:

- Add test codes and CI using GitHub Actions (#1)

## 0.5.2 (2020-05-21)

Improve:

- Refresh cached config values dynamically when cache keys are changed, specified
  by `$GCLOUD_PROMPT_CONFIG_KEYS`
- Add exclusive lock on modifying cache contents to avoid data race

Change:

- Change default contents root path from `$HOME/.gcloud_prompt` to `<Repository Root>/var`
  directory which is specified by variable `$GCLOUD_PROMPT_ROOT`

## 0.5.1 (2020-05-18)

Change:

- Modify variable name `$GCLOUD_PROMPT_SEPARATOR` which was `$GCLOUD_PROMPT_SEPARATER`

## 0.5.0 (2020-05-17)

Initial release.
