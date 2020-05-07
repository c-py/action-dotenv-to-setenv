# action-dotenv-to-setenv

GitHub action to export a `.env` file to environment variables (via [set-env](https://help.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-an-environment-variable))

Adapted from https://github.com/madcoda/dotenv-shell

## Inputs

### `env-file`

**Required** Path to the dotenv file. Default `".env"`.

## Outputs

[set-env](https://help.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-an-environment-variable) workflow commands to stdout. 

```
::set-env name=TEST_DEFAULT_ENVFILE::expected
::set-env name=TEST_DOTENV_OVERRIDES_DEFAULT::unexpected
::set-env name=TEST_UNQUOTED::unexpected
::set-env name=TEST_UNQUOTED::a=1 b=2 c=3
::set-env name=TEST_SINGLE_QUOTED::1 2 3 4
::set-env name=TEST_DOUBLE_QUOTED::1 2 3 4
::set-env name=TEST_INTERPOLATION::a=1 b=2 c=3 d=4
::set-env name=TEST_EXISTING::new-value
::set-env name=TEST_DOTENV_OVERRIDES_DEFAULT::expected
::set-env name=TEST_NO_NEWLINE::still there
```

## Example Usage

```
uses: c-py/action-dotenv-to-setenv@latest
with:
  env-file: .env
```

## Tests

```
$ bash tests/dotenv-test.sh
::set-env name=TEST_DEFAULT_ENVFILE::expected
::set-env name=TEST_DOTENV_OVERRIDES_DEFAULT::unexpected
::set-env name=TEST_UNQUOTED::unexpected
::set-env name=TEST_UNQUOTED::a=1 b=2 c=3
::set-env name=TEST_SINGLE_QUOTED::1 2 3 4
::set-env name=TEST_DOUBLE_QUOTED::1 2 3 4
::set-env name=TEST_INTERPOLATION::a=1 b=2 c=3 d=4
::set-env name=TEST_EXISTING::new-value
::set-env name=TEST_DOTENV_OVERRIDES_DEFAULT::expected
::set-env name=TEST_NO_NEWLINE::still there
Testing blank line parsing: ok
Testing unquoted: ok
Testing single quoted: ok
Testing double quoted: ok
Testing interpolation: ok
Testing overwrite of existing variables: ok
Testing parsing of last line: ok
Test loading variables from default.env file: ok
Test .env variables override variables from default.env file: ok
$
```
