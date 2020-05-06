# Init submodules if necessary, complain if out of sync
if (${UPDATE_SUBMODULES})

  # Update submodules but only if there are no local uncommited changes
  # 1. Check for uncommitted changes
  execute_process(COMMAND git submodule foreach --recursive
    git status -uno --porcelain OUTPUT_VARIABLE SUBMODULE_STATUS)
  string(REGEX MATCH "Entering [^\n]*\n M [^\n]*"
    CHANGED_FILES_IN_SUBMODULES ${SUBMODULE_STATUS})
  if(NOT ("${CHANGED_FILES_IN_SUBMODULES}" STREQUAL ""))
    # There are uncommitted changes in submodules; list them
    message(FATAL_ERROR "There are uncommited changes in submodules:\n${CHANGED_FILES_IN_SUBMODULES}")
  else()
    # 2. Check for mismatches in submodules; fail if they don't match.
    execute_process(COMMAND git diff OUTPUT_VARIABLE SUBMODULE_STATUS)
    string(REGEX MATCH "Subproject commit " CHANGED_SUBMODULES ${SUBMODULE_STATUS})
    if(NOT ("${CHANGED_SUBMODULES}" STREQUAL ""))
      message(FATAL_ERROR "There are mismatches between the recorded commit hash "
        "and the local commit hash for some submodules. Run git --diff in "
        "${CMAKE_CURRENT_SOURCE_DIR} for details, then commit local changes "
        "or update the respective submodules.")
    endif()
  else() # new checkout, no submodules initialized
    # Initialize/update all submodules
    execute_process(COMMAND git submodule update --init --recursive --no-fetch
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
  endif()
endif()
