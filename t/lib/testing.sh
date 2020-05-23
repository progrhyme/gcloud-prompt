# bash/zsh
#
# Library for testing

test_gcloud_prompt_setup() {
  TEMP_DIR="$(pwd)/tmp"
  GCLOUD_PROMPT_ROOT="${TEMP_DIR}/prompt"
  mkdir -p $GCLOUD_PROMPT_ROOT

  # Set up test stub
  export TEST_GCLOUD_ROOT=$TEMP_DIR
  export TEST_GCLOUD_CONFIG_DIR="${TEMP_DIR}/gcloud"
  export TEST_GCLOUD_ACCOUNT="bob@example.com"
  export TEST_GCLOUD_PROJECT="my-project"
  export TEST_GCLOUD_REGION="us-east1"
  export TEST_GCLOUD_PROMPT_DEBUG=

  TEST_GCLOUD_ACTIVE_CONFIG_NAME=
  TEST_GCLOUD_DEFAULT_CONFIG_NAME=default
  mkdir -p $TEST_GCLOUD_CONFIG_DIR/configurations
  test_gcloud_prompt_activate_config $TEST_GCLOUD_DEFAULT_CONFIG_NAME

  PATH="t/lib:$PATH"

  # load gcloud-prompt.sh
  . ./gcloud-prompt.sh

  test_gcloud_prompt_gen_stub_lib
}

test_gcloud_prompt_teardown() {
  rm -rf $TEMP_DIR/*
}

# Pseudo function corresponds to `gcloud config configurations activate $1`
test_gcloud_prompt_activate_config() {
  local cfgn=$1

  TEST_GCLOUD_ACTIVE_CONFIG_NAME=$cfgn
  echo $cfgn > "${TEST_GCLOUD_CONFIG_DIR}/active_config"
  touch "${TEST_GCLOUD_CONFIG_DIR}/configurations/config_${cfgn}"
}

test_gcloud_prompt_renew_config() {
  # Ensure to renew timestamp
  local now=$(date +%Y%m%d%H%M)
  touch -t $((now+1)) \
    "${TEST_GCLOUD_CONFIG_DIR}/configurations/config_${TEST_GCLOUD_ACTIVE_CONFIG_NAME}"
}

# Create shell script to load from test stub
test_gcloud_prompt_gen_stub_lib() {
  export TEST_GCLOUD_PROMPT_STUB_LIB="${TEMP_DIR}/test_gcloud.sh"
  # Write out config keys because array cannot export in Bash
  local keys="${GCLOUD_PROMPT_CONFIG_KEYS[@]}"
  echo "GCLOUD_PROMPT_CONFIG_KEYS=($keys)" > $TEST_GCLOUD_PROMPT_STUB_LIB
}
