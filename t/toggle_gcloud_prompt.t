# set up testing configs
. ./t/lib/testing.sh
test_gcloud_prompt_setup

# start testing
. ./gcloud-prompt.sh

t_is $GCLOUD_PROMPT_ENABLED on '$GCLOUD_PROMPT_ENABLED = "on"'
toggle_gcloud_prompt
t_blank "$GCLOUD_PROMPT_ENABLED" '$GCLOUD_PROMPT_ENABLED is blank'

# tear down testing
test_gcloud_prompt_teardown

# vim:set ft=sh :
