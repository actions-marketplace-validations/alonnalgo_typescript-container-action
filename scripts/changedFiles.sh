#!/bin/bash
           printenv 
          # echo "::set-output debug=$(if [ -z ${ALGOSEC_IS_DEBUG} ]; then echo false; else echo true; fi;)"
 # Pull Request
          printenv 
          echo "INPUT_GITHUB_BASE_REF: ${INPUT_GITHUB_BASE_REF}, INPUT_GITHUB_SHA: ${INPUT_GITHUB_SHA}"
          git fetch origin "${INPUT_GITHUB_BASE_REF}" --depth=1
          # Get the list of all changed resources
          diff_result=$(git diff --name-only "origin/${INPUT_GITHUB_BASE_REF}" ${INPUT_GITHUB_SHA} )
          echo "Diff between origin/${INPUT_GITHUB_BASE_REF} and ${INPUT_GITHUB_SHA}"

          # Extract terraform's files
          terraform_files=$(echo $diff_result | tr -s '[[:space:]]' '\n' | grep -o '.*\.tf$')
          echo "Changed Terraform's files: $terraform_files"

          #extract folders where the changed teraforms files are stored
          #and create json to proceed them in the matrix style
          matrix_output="{\"include\":[ "
          for line in in $terraform_files
          do 
            if [[ $line == *".tf"* ]];
            then
              echo "Working line: $line" 
              dir=$(dirname $line) 
              echo "extracted dir: $dir"
              matrix_output="$matrix_output{\"folder\":\"$dir\"},"
            fi
          done
          matrix_output="$matrix_output ]}"

          # echo "Prepared working matrix: $matrix_output"
          # echo "::set-output name=matrix::${matrix_output}"

