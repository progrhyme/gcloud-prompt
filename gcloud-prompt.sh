# bash/zsh

if ! command -v gcloud &>/dev/null; then
  "[ERROR] Command \"gcloud\" is missing! Can't load gcloud-prompt.sh"
  return
fi

GCLOUD_PROMPT_ENABLED=on
GCLOUD_PROMPT_SHOW_CONFIG_PARAMS=${GCLOUD_PROMPT_SHOW_CONFIG_PARAMS:-yes}
if [[ -z "${GCLOUD_PROMPT_CONFIG_KEYS:-}" ]]; then
  GCLOUD_PROMPT_CONFIG_KEYS=(core.account core.project)
fi
GCLOUD_PROMPT_SEPARATOR=${GCLOUD_PROMPT_SEPARATOR:-'|'}

GCLOUD_PROMPT_ROOT=${GCLOUD_PROMPT_ROOT:-$HOME/.gcloud_prompt}
GCLOUD_PROMPT_CACHE_DIR="$GCLOUD_PROMPT_ROOT/cache"

# initialize cache directory
[[ -d $GCLOUD_PROMPT_CACHE_DIR ]] && rm -rf $GCLOUD_PROMPT_CACHE_DIR
mkdir -p $GCLOUD_PROMPT_CACHE_DIR

if [[ -z "${GCLOUD_PROMPT_SDK_CONFIG_DIR:-}" ]]; then
  GCLOUD_PROMPT_SDK_CONFIG_DIR=$(gcloud info --format='value(config.paths.global_config_dir)')
fi

# prompt builder function
gcloud_prompt() {
  if [[ -z "${GCLOUD_PROMPT_ENABLED:-}" ]]; then
    return
  fi

  if [[ "$GCLOUD_PROMPT_SHOW_CONFIG_PARAMS" = "yes" ]]; then
    printf '%s%s%s' \
      $(_gcloud_prompt_sdk_active_config) \
      $GCLOUD_PROMPT_SEPARATOR \
      $(_gcloud_prompt_config_values)
  else
    printf '%s' $(_gcloud_prompt_sdk_active_config)
  fi
}

# toggle show/hide prompt
toggle_gcloud_prompt() {
  if [[ -z "${GCLOUD_PROMPT_ENABLED:-}" ]]; then
    GCLOUD_PROMPT_ENABLED=on
  else
    GCLOUD_PROMPT_ENABLED=
  fi
}

# fetch activated configuration
_gcloud_prompt_sdk_active_config() {
  if [[ -n "${CLOUDSDK_ACTIVE_CONFIG_NAME:-}" ]]; then
    echo $CLOUDSDK_ACTIVE_CONFIG_NAME
  else
    cat "${GCLOUD_PROMPT_SDK_CONFIG_DIR}/active_config"
  fi
}

# fetch config values
_gcloud_prompt_config_values() {
  local cfgn=$(_gcloud_prompt_sdk_active_config)
  local cfgn_path="${GCLOUD_PROMPT_SDK_CONFIG_DIR}/configurations/config_${cfgn}"

  local cache_keys="${GCLOUD_PROMPT_CACHE_DIR}/config_${cfgn}.keys"
  local cache_values="${GCLOUD_PROMPT_CACHE_DIR}/config_${cfgn}.values"

  # join arrays into comma-separated string
  local keys="$(IFS=,; echo "${GCLOUD_PROMPT_CONFIG_KEYS[*]}")"

  if [[ ! -r "$cache_keys" || "$keys" != "$(cat $cache_keys)" ]]; then
    echo $keys > $cache_keys
    _gcloud_prompt_write_config_values $keys $cache_values
  elif [[ ! -r "$cache_values" || "$cfgn_path" -nt "$cache_values" ]]; then
    _gcloud_prompt_write_config_values $keys $cache_values
  fi

  cat $cache_values
}

# Write config values onto cache file
_gcloud_prompt_write_config_values() {
  local keys=$1
  local _path=$2
  gcloud config list --format="csv[no-heading]($keys)" > $_path
}
