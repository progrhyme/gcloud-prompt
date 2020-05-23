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
t_is "$(gcloud_prompt)" $expected_prompt "gcloud_prompt = '${expected_prompt}'"

t::group 'Config values are cached; reusable next time' ({
  cnt1="$(gcloud get-config-called-count)"
  t_is "$(gcloud_prompt)" $expected_prompt "gcloud_prompt = '${expected_prompt}'"
  cnt2="$(gcloud get-config-called-count)"
  t_eq $cnt1 $cnt2 "'gcloud config' is not called"
})

t::group 'When config is updated, cache file is no longer available' ({
  cnt1="$(gcloud get-config-called-count)"
  test_gcloud_prompt_renew_config
  t_is "$(gcloud_prompt)" $expected_prompt "gcloud_prompt = '${expected_prompt}'"
  cnt2="$(gcloud get-config-called-count)"
  t_eq $((cnt1+1)) $cnt2 "'gcloud config' is called"
})

t::group 'When config keys are changed, cache file is not available and config values are fetched from current properties' ({
  cnt1="$(gcloud get-config-called-count)"

  GCLOUD_PROMPT_CONFIG_KEYS=(core.project compute.region)
  # re-generate script for stub
  test_gcloud_prompt_gen_stub_lib

  expected_prompt="$(
    printf '%s%s%s,%s' \
      $TEST_GCLOUD_DEFAULT_CONFIG_NAME \
      $GCLOUD_PROMPT_SEPARATOR \
      $TEST_GCLOUD_PROJECT \
      $TEST_GCLOUD_REGION
  )"

  t_is "$(gcloud_prompt)" $expected_prompt "gcloud_prompt = '${expected_prompt}'"
  cnt2="$(gcloud get-config-called-count)"
  t_eq $((cnt1+1)) $cnt2 "'gcloud config' is called"
})

# tear down testing
test_gcloud_prompt_teardown

# vim:set ft=sh :
