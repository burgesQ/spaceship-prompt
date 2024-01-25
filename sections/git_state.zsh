#
# Git status
#

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_GIT_STATE_SHOW="${SPACESHIP_GIT_STATE_SHOW=false}"
SPACESHIP_GIT_STATE_ASYNC="${SPACESHIP_GIT_STATE_ASYNC=true}"
SPACESHIP_GIT_STATE_PREFIX="${SPACESHIP_GIT_STATE_PREFIX=""}"
SPACESHIP_GIT_STATE_SUFFIX="${SPACESHIP_GIT_STATE_SUFFIX=""}"
SPACESHIP_GIT_STATE_COLOR="${SPACESHIP_GIT_STATE_COLOR="blue"}"
SPACESHIP_GIT_STATE_CHERRY_PICK="${SPACESHIP_GIT_STATE_CHERRY_PICK="cherry_pick"}"
SPACESHIP_GIT_STATE_REBASE="${SPACESHIP_GIT_STATE_REBASE="rebase"}"
SPACESHIP_GIT_STATE_MERGE="${SPACESHIP_GIT_STATE_MERGE="merge"}"
SPACESHIP_GIT_STATE_REVERT="${SPACESHIP_GIT_STATE_REVERT="revert"}"
SPACESHIP_GIT_STATE_BISECT="${SPACESHIP_GIT_STATE_BISECT="bisect"}"
SPACESHIP_GIT_STATE_AM="${SPACESHIP_GIT_STATE_AM="am"}"
SPACESHIP_GIT_STATE_AM_OR_REBASE="${SPACESHIP_GIT_STATE_AM_OR_REBASE="am_or_rebase"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# We used to depend on OMZ git library,
# But it doesn't handle many of the status indicator combinations.
# Also, It's hard to maintain external dependency.
# See PR #147 at https://git.io/vQkkB
# See git help status to know more about status formats
spaceship_git_state() {
  [[ $SPACESHIP_GIT_STATE_SHOW == false ]] && return
  spaceship::is_git || return

  local INDEX=$(command git status 2> /dev/null) git_state=
ec
  vcs_info

  # appliy/total patch: %n/%a

  # thx https://github.com/zsh-users/zsh/blob/master/Functions/VCS_Info/Backends/VCS_INFO_get_data_git
  gitaction
  VCS_INFO_git_getaction()

  git_state="$gitaction"
  # # Check for bisect in progress
  # # thx: https://stackoverflow.com/questions/37667324/how-do-i-get-the-current-status-of-a-git-bisect
  # if $(command git bisect visualize > /dev/null); then
  #   local tot=$(command git bisect visualize --oneline | wc -l)
  #   let "left = $tot / 2"
  #   let step=$(print -v int %.0f `echo "l($left)/l(2)" | bc -l`)

  #   git_state="$SPACESHIP_GIT_STATE_BISECT ($tot left, rougly $step)$git_state"
  # fi

  if [[ -n $git_state ]]; then
    # Status prefixes are colorized
    spaceship::section \
      --color "$SPACESHIP_GIT_STATE_COLOR" \
      "$SPACESHIP_GIT_STATE_PREFIX$git_state$SPACESHIP_GIT_STATE_SUFFIX"
  fi
}
