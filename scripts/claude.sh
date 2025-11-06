#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

# Determine current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch: $BRANCH_NAME"

# Ensure TEAM_NAME is provided (either as an env var or argument)
TEAM_NAME=${TEAM_NAME:-${1:-}}
if [[ -z "$TEAM_NAME" ]]; then
  echo "Usage: TEAM_NAME=myteam ./$SCRIPT_NAME"
  echo "or pass team name as first argument."
  exit 1
fi

PROMPT_FEATURE="./prompts/feature.prompt"
if [[ ! -f "$PROMPT_FEATURE" ]]; then
  echo "Error: Prompt feature file '$PROMPT_FEATURE' not found."
  exit 1
fi

PROMPT_FILE="./prompts/${TEAM_NAME}.prompt"
if [[ ! -f "$PROMPT_FILE" ]]; then
  echo "Error: Prompt with team conventions file '$PROMPT_FILE' not found."
  exit 1
fi

PROMPT_LOCAL="./prompts/local.prompt"


# Build combined prompt
OUTPUT_FILE="combined_prompt.txt"

if [[ -f $OUTPUT_FILE ]]; then
  echo "Removing existing $OUTPUT_FILE"
  rm $OUTPUT_FILE
fi

{
  echo "You are supposed to work and implement this feature:"
  echo
  cat $PROMPT_FEATURE
  echo
  echo "Common code and ways of working conventions:"
  echo
  cat "$PROMPT_FILE"
  echo
  if [[ -f $PROMPT_LOCAL ]]; then
    echo "Remember to follow these additional conventions:"
    echo
    cat $PROMPT_LOCAL
    echo
  fi
} > "$OUTPUT_FILE"

echo "Prompt built successfully in $OUTPUT_FILE"
echo "Prompt to be run:"
echo
cat $OUTPUT_FILE

read -r -p "Do you want to proceed and run the prompt? [Y/n]" response

if [[ "$response" == "y" || "$response" == "yes" || -z "$response" ]]; then
    cat $OUTPUT_FILE | claude
fi
