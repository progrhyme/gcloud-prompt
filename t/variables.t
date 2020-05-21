GCLOUD_PROMPT_ROOT=$(pwd)/tmp
mkdir -p $GCLOUD_PROMPT_ROOT

. gcloud-prompt.sh

t_is $GCLOUD_PROMPT_ENABLED on '$GCLOUD_PROMPT_ENABLED = "on"'
t_is $GCLOUD_PROMPT_SHOW_CONFIG_PARAMS yes '$GCLOUD_PROMPT_SHOW_CONFIG_PARAMS = "yes"'
t::group '$GCLOUD_PROMPT_CONFIG_KEYS = (core.account core.project)' ({
  case "$SHOVE_SHELL" in
    *bash )
      t_is ${GCLOUD_PROMPT_CONFIG_KEYS[0]} core.account
      t_is ${GCLOUD_PROMPT_CONFIG_KEYS[1]} core.project
      ;;
    *zsh )
      t_is ${GCLOUD_PROMPT_CONFIG_KEYS[1]} core.account
      t_is ${GCLOUD_PROMPT_CONFIG_KEYS[2]} core.project
      ;;
    * ) t_fail ;;
  esac
})
t_is $GCLOUD_PROMPT_SEPARATOR '|' '$GCLOUD_PROMPT_SEPARATOR = "|"'
t_is $GCLOUD_PROMPT_ROOT $(pwd)/tmp "\\$GCLOUD_PROMPT_ROOT = $(pwd)/tmp"
t_is $GCLOUD_PROMPT_VAR_DIR $(pwd)/tmp/var "\\$GCLOUD_PROMPT_VAR_DIR = $(pwd)/tmp/var"
t_is $GCLOUD_PROMPT_CACHE_DIR $(pwd)/tmp/var/cache "\\$GCLOUD_PROMPT_CACHE_DIR = $(pwd)/tmp/var/cache"

t_directory $GCLOUD_PROMPT_CACHE_DIR 'Directory $GCLOUD_PROMPT_CACHE_DIR exists'

rm -rf $GCLOUD_PROMPT_ROOT/*

# vim:set ft=sh :
