hack script +ARGS='': 
  yarn ts-node --script-mode hack/{{script}} {{ARGS}}

release version:
  #!/bin/bash
  just hack build.ts
  yarn version --new-version {{version}}
  just hack pkgjson.ts
  yarn workspaces run publish --new-version {{version}}