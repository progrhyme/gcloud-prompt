# set up testing configs
. ./t/lib/testing.sh
test_gcloud_prompt_setup

expected_prompt="$(
  printf '%s%s%s,%s' \
    $TEST_GCLOUD_DEFAULT_CONFIG_NAME \
    $GCLOUD_PROMPT_SEPARATOR \
    $TEST_GCLOUD_ACCOUNT \
    $TEST_GCLOUD_PROJECT
)"

gcloud_prompt_export
t_is "$GCLOUD_PROMPT_TEXT" $expected_prompt "\$GCLOUD_PROMPT_TEXT = '${expected_prompt}'"
t_is "$(env | grep '^GCLOUD_PROMPT_TEXT=')" "GCLOUD_PROMPT_TEXT=${expected_prompt}" '$GCLOUD_PROMPT_TEXT is exported'

# t::group runs in a subshell; the toggled state doesn't leak out of it
t::group 'When the prompt is hidden, $GCLOUD_PROMPT_TEXT is unset; shown again, it is restored' ({
  toggle_gcloud_prompt
  gcloud_prompt_export
  t_blank "$(env | grep '^GCLOUD_PROMPT_TEXT=')" '$GCLOUD_PROMPT_TEXT is not exported'
  t_is "${GCLOUD_PROMPT_TEXT-unset}" unset '$GCLOUD_PROMPT_TEXT is unset'

  toggle_gcloud_prompt
  gcloud_prompt_export
  t_is "$GCLOUD_PROMPT_TEXT" $expected_prompt "\$GCLOUD_PROMPT_TEXT = '${expected_prompt}'"
})

# tear down testing
test_gcloud_prompt_teardown

# vim:set ft=sh :
