#
# Tries to find the clang-tidy and clang-format modules
#
# Usage of this module as follows:
#
#  find_package(ClangTools)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  ClangToolsBin_HOME -
#   When set, this path is inspected instead of standard library binary locations
#   to find clang-tidy and clang-format
#
# This module defines
#  CLANG_TIDY_BIN, The path to the clang tidy binary
#  CLANG_TIDY_FOUND, Whether clang tidy was found
#  CLANG_FORMAT_BIN, The path to the clang format binary
#  CLANG_FORMAT_FOUND, Whether clang format was found

if (DEFINED ENV{HOMEBREW_PREFIX})
    set(HOMEBREW_PREFIX "${ENV{HOMEBREW_PREFIX}")
else()
    set(HOMEBREW_PREFIX "/usr/local")
endif()

find_program(CLANG_TIDY_BIN
        NAMES clang-tidy
        clang-tidy-6.0.1
        clang-tidy-6.0
        clang-tidy-4.0
        clang-tidy-3.9
        clang-tidy-3.8
        clang-tidy-3.7
        clang-tidy-3.6
        clang-tidy
        PATHS ${ClangTools_PATH} $ENV{CLANG_TOOLS_PATH} /usr/local/bin /usr/bin "${HOMEBREW_PREFIX}/bin"
        NO_DEFAULT_PATH
        )

if ( "${CLANG_TIDY_BIN}" STREQUAL "CLANG_TIDY_BIN-NOTFOUND" )
    set(CLANG_TIDY_FOUND 0)
else()
    set(CLANG_TIDY_FOUND 1)
endif()

if (CLANG_FORMAT_VERSION)
    find_program(CLANG_FORMAT_BIN
            NAMES clang-format-${CLANG_FORMAT_VERSION}
            PATHS
            ${ClangTools_PATH}
            $ENV{CLANG_TOOLS_PATH}
            /usr/local/bin /usr/bin "${HOMEBREW_PREFIX}/bin"
            NO_DEFAULT_PATH
            )

    # If not found yet, search alternative locations
    if (("${CLANG_FORMAT_BIN}" STREQUAL "CLANG_FORMAT_BIN-NOTFOUND") AND APPLE)
        # Homebrew ships older LLVM versions in /usr/local/opt/llvm@version/
        STRING(REGEX REPLACE "^([0-9]+)\\.[0-9]+" "\\1" CLANG_FORMAT_MAJOR_VERSION "${CLANG_FORMAT_VERSION}")
        STRING(REGEX REPLACE "^[0-9]+\\.([0-9]+)" "\\1" CLANG_FORMAT_MINOR_VERSION "${CLANG_FORMAT_VERSION}")
        if ("${CLANG_FORMAT_MINOR_VERSION}" STREQUAL "0")
            find_program(CLANG_FORMAT_BIN
                    NAMES clang-format
                    PATHS "${HOMEBREW_PREFIX}/opt/llvm@${CLANG_FORMAT_MAJOR_VERSION}/bin"
                    NO_DEFAULT_PATH
                    )
        else()
            find_program(CLANG_FORMAT_BIN
                    NAMES clang-format
                    PATHS "${HOMEBREW_PREFIX}/opt/llvm@${CLANG_FORMAT_VERSION}/bin"
                    NO_DEFAULT_PATH
                    )
        endif()

        if ("${CLANG_FORMAT_BIN}" STREQUAL "CLANG_FORMAT_BIN-NOTFOUND")
            # binary was still not found, look into Cellar
            # TODO: This currently only works for '.0' patch releases as
            #       find_program does not support regular expressions
            #       in the paths.
            find_program(CLANG_FORMAT_BIN
                    NAMES clang-format
                    PATHS "${HOMEBREW_PREFIX}/Cellar/llvm/${CLANG_FORMAT_VERSION}.0/bin"
                    NO_DEFAULT_PATH
                    )
        endif()
    endif()
else()
    find_program(CLANG_FORMAT_BIN
            NAMES clang-format
            clang-format-6.0.1
            clang-format-6.0
            clang-format-4.0
            clang-format-3.9
            clang-format-3.8
            clang-format-3.7
            clang-format-3.6
            clang-format
            PATHS ${ClangTools_PATH} $ENV{CLANG_TOOLS_PATH} /usr/local/bin /usr/bin "${HOMEBREW_PREFIX}/bin"
            NO_DEFAULT_PATH
            )
endif()

if ( "${CLANG_FORMAT_BIN}" STREQUAL "CLANG_FORMAT_BIN-NOTFOUND" )
    set(CLANG_FORMAT_FOUND 0)
else()
    set(CLANG_FORMAT_FOUND 1)
endif()