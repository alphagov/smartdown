#!/bin/bash -x
set -e

function ensure_venv {
  VENV_PATH="${HOME}/venv/${JOB_NAME}"

  [ -x ${VENV_PATH}/bin/pip ] || virtualenv ${VENV_PATH}
  . ${VENV_PATH}/bin/activate

  pip install -q ghtools
}

function notify {
  local STATUS="$1"
  local MESSAGE="$2"
  echo $STATUS
  gh-status "$REPO" "$GIT_COMMIT" "${STATUS}" -d "\"Build #${BUILD_NUMBER} ${MESSAGE} on Jenkins\"" -u "$BUILD_URL" >/dev/null
}

REPO="alphagov/smartdown"
rm -f Gemfile.lock
bundle install --path "${HOME}/bundles/${JOB_NAME}"

notify pending "is running"

if bundle exec rake; then
  notify success "succeeded"

  bundle exec rake publish_gem --trace
else
  notify failure "failed"
  exit 1
fi

