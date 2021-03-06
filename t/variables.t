# set up testing configs
. ./t/lib/testing.sh
test_gcloud_prompt_setup

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
t_is $GCLOUD_PROMPT_VAR_DIR "${GCLOUD_PROMPT_ROOT}/var" \
  "\\$GCLOUD_PROMPT_VAR_DIR = ${GCLOUD_PROMPT_ROOT}/var"
t_is $GCLOUD_PROMPT_CACHE_DIR "${GCLOUD_PROMPT_ROOT}/var/cache" \
  "\\$GCLOUD_PROMPT_CACHE_DIR = ${GCLOUD_PROMPT_ROOT}/var/cache"

# Set by test stub "info" subcommand
t_is $GCLOUD_PROMPT_SDK_CONFIG_DIR "${TEST_GCLOUD_CONFIG_DIR}" \
  "\\$GCLOUD_PROMPT_SDK_CONFIG_DIR is set to ${TEST_GCLOUD_CONFIG_DIR}"

t_directory $GCLOUD_PROMPT_CACHE_DIR 'Directory $GCLOUD_PROMPT_CACHE_DIR exists'

# tear down testing
test_gcloud_prompt_teardown

# vim:set ft=sh :
