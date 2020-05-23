# bash/zsh
#
# Library for testing

test_gcloud_prompt_setup() {
  TEMP_DIR="$(pwd)/tmp"
  GCLOUD_PROMPT_ROOT="${TEMP_DIR}/prompt"
  mkdir -p $GCLOUD_PROMPT_ROOT

  # Configure for test stub
  export TEST_GCLOUD_CONFIG_DIR="${TEMP_DIR}/gcloud"
  export TEST_GCLOUD_PROMPT_DEBUG=

  PATH="t/lib:$PATH"
}

test_gcloud_prompt_teardown() {
  rm -rf $TEMP_DIR/*
}
