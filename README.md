# action-dotenv-to-setenv

GitHub action to export a `.env` file to environment variables (via [$GITHUB_ENV](https://help.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-an-environment-variable))

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
uses: c-py/action-dotenv-to-setenv@v5
with:
  env-file: .env
```

## Usage with `NODE_OPTIONS`

Unfortunately, `NODE_OPTIONS` cannot be set in this action due to GitHub [security settings](https://github.com/c-py/action-dotenv-to-setenv/issues/9). To work around this `NODE_OPTIONS` is automatically output under `node_options`.

```
  - uses: c-py/action-dotenv-to-setenv@v5
    id: source-env
    with:
      env-file: .env
  - run: echo ${{ steps.source-env.outputs.node_options }} 
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
TEST_SINGLE_QUOTE_NO_INTERPOLATE=${TEST}
TEST_DOUBLE_QUOTED=1 2 3 4
TEST_INTERPOLATION=a=1 b=2 c=3 d=4
TEST_EXISTING=new-value
TEST_DOTENV_OVERRIDES_DEFAULT=expected
TEST_SPECIAL_CHARACTER=special(character
TEST_NO_NEWLINE=still there

Testing blank line parsing: ok
Testing unquoted: ok
Testing single quoted: ok
Testing single-quoted variables arent interpolated: ok
Testing double quoted: ok
Testing interpolation: ok
Testing overwrite of existing variables: ok
Testing parsing of last line: ok
Test loading variables from default.env file: ok
Test .env variables override variables from default.env file: ok
Testing special characters: ok
Test error message from missing .env file: ok
Test NODE_OPTIONS skipped: ok
Test NODE_OPTIONS set in output: ok
$
```
