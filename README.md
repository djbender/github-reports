# github-reports

List all repos for a given organization.

This uses basic auth via curl: `-u username:password` so the
`<token-username>` below is your username associated with your `GITHUB_TOKEN`.

## Usage

    $ GITHUB_TOKEN=<your-github-api-token> ./list-repos.sh <token-username> <org>

    $ cat output.txt
