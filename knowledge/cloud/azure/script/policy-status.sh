#!/bin/bash

subscription="a7bdf2e3-b855-4dda-ac93-047ff722cbbd"

az policy state summarize \
--subscription a7bdf2e3-b855-4dda-ac93-047ff722cbbd \
--query "policyAssignments[].policyAssignmentId" \
-o tsv