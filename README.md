# action-dotenv-to-setenv

GitHub action to export a `.env` file to environment variables (via [set-env](https://help.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-an-environment-variable))

Adapted from https://github.com/madcoda/dotenv-shell

## Inputs

### `env-file`

**Required** Path to the dotenv file. Default `".env"`.

## Outputs

[`echo "{name}={value}"`](https://help.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-an-environment-variable) workflow commands to `$GITHUB_ENV`.

```shell
echo "TEST_DEFAULT_ENVFILE=expected" >> $GITHUB_ENV
echo "TEST_DOTENV_OVERRIDES_DEFAULT=unexpected" >> $GITHUB_ENV
echo "TEST_UNQUOTED=unexpected" >> $GITHUB_ENV
echo "TEST_UNQUOTED=a=1 b=2 c=3" >> $GITHUB_ENV
echo "TEST_SINGLE_QUOTED=1 2 3 4" >> $GITHUB_ENV
echo "TEST_DOUBLE_QUOTED=1 2 3 4" >> $GITHUB_ENV
echo "TEST_INTERPOLATION=a=1 b=2 c=3 d=4" >> $GITHUB_ENV
echo "TEST_EXISTING=new-value" >> $GITHUB_ENV
echo "TEST_DOTENV_OVERRIDES_DEFAULT=expected" >> $GITHUB_ENV
echo "TEST_NO_NEWLINE=still there" >> $GITHUB_ENV
```

## Example Usage

```
uses: c-py/action-dotenv-to-setenv@v1
with:
  env-file: .env
```

## Tests

```
$ bash tests/dotenv-test.sh
Contents of $GITHUB_ENV file:
TEST_DEFAULT_ENVFILE=expected
TEST_DOTENV_OVERRIDES_DEFAULT=unexpected
TEST_UNQUOTED=unexpected
TEST_UNQUOTED=a=1 b=2 c=3
TEST_SINGLE_QUOTED=1 2 3 4
TEST_DOUBLE_QUOTED=1 2 3 4
TEST_INTERPOLATION=a=1 b=2 c=3 d=4
TEST_EXISTING=new-value
TEST_DOTENV_OVERRIDES_DEFAULT=expected
TEST_NO_NEWLINE=still there

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
