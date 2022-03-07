# ansible-vault-pass-client [![Build Status](https://img.shields.io/github/workflow/status/bkahlert/ansible-vault-pass-client/build?label=Build&logo=github&logoColor=fff)](https://github.com/bkahlert/ansible-vault-pass-client/actions/workflows/build.yml) [![Repository Size](https://img.shields.io/github/repo-size/bkahlert/ansible-vault-pass-client?color=01818F&label=Repo%20Size&logo=Git&logoColor=fff)](https://github.com/bkahlert/ansible-vault-pass-client) [![Repository Size](https://img.shields.io/github/license/bkahlert/ansible-vault-pass-client?color=29ABE2&label=License&logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA1OTAgNTkwIiAgeG1sbnM6dj0iaHR0cHM6Ly92ZWN0YS5pby9uYW5vIj48cGF0aCBkPSJNMzI4LjcgMzk1LjhjNDAuMy0xNSA2MS40LTQzLjggNjEuNC05My40UzM0OC4zIDIwOSAyOTYgMjA4LjljLTU1LjEtLjEtOTYuOCA0My42LTk2LjEgOTMuNXMyNC40IDgzIDYyLjQgOTQuOUwxOTUgNTYzQzEwNC44IDUzOS43IDEzLjIgNDMzLjMgMTMuMiAzMDIuNCAxMy4yIDE0Ny4zIDEzNy44IDIxLjUgMjk0IDIxLjVzMjgyLjggMTI1LjcgMjgyLjggMjgwLjhjMCAxMzMtOTAuOCAyMzcuOS0xODIuOSAyNjEuMWwtNjUuMi0xNjcuNnoiIGZpbGw9IiNmZmYiIHN0cm9rZT0iI2ZmZiIgc3Ryb2tlLXdpZHRoPSIxOS4yMTIiIHN0cm9rZS1saW5lam9pbj0icm91bmQiLz48L3N2Zz4%3D)](https://github.com/bkahlert/ansible-vault-pass-client/blob/master/LICENSE)

## About
**ansible-vault-pass-client** is an Ansible vault password client script to integrate your password manager (LastPass, 1Password, etc.).


## Installation

### Package Managers

```shell
brew install bkahlert/ansible-vault-pass-client/ansible-vault-pass-client
```

### Manual
`ansible-vault-pass-client` is a Bash script. 

In order to use it, it needs to be downloaded, put on your `$PATH`
and made executable,
which is exactly what the following line is doing:
```shell
sudo curl -LfsSo /usr/local/bin/ansible-vault-pass-client \
https://raw.githubusercontent.com/bkahlert/ansible-vault-pass-client/master/ansible-vault-pass-client
sudo chmod +x /usr/local/bin/ansible-vault-pass-client
```

## Configuration

Edit your `.bashrc`, `.zshrc`, ... depending on the password manager you want
to integrate.

### LastPass

Please install [lastpass-cli](https://github.com/lastpass/lastpass-cli) and customize
your environment as follows:
```sh
export ANSIBLE_VAULT_PASS_CLIENT=lastpass
export ANSIBLE_VAULT_PASS_CLIENT_USERNAME='john.doe@example.com'
export ANSIBLE_VAULT_PASSWORD_FILE=$(command -v ansible-vault-pass-client)
```

### 1Password

You need to install [op-cli](https://support.1password.com/command-line-getting-started/) and
follow its instructions to create a so called `shorthand` which you'll need in your configuration:
```sh
export ANSIBLE_VAULT_PASS_CLIENT=1password
export ANSIBLE_VAULT_PASS_CLIENT_SHORTHAND='<SHORTHAND GOES HERE>'
export ANSIBLE_VAULT_PASSWORD_FILE=$(command -v ansible-vault-pass-client)
```

## Usage

Whenever Ansible needs a password `ansible-vault-pass-client` will use
your configured password manager to retrieve it.

**The query used to find the best matching password manager item is based on
your current working directory.  
If an item is found, its password will is turned back to Ansible.**

Suppose your current working directory is `/root/tld.comain/parent/current`
- First, the directory's name `current` is given a go.
- If nothing is found, the parent directory's name `parent` is added: `current.parent`
- If that still no match is produced the search goes on the same way.  
  Now comes the domain-like name `tld.domain` which will be reversed to `domain.tld`
  before being added: `current.parent.domain.tld`
- The directory `root` is the last one given a shot: `current.parent.domain.tld.root`
- If no item was matched until now, no password is returned.

If you use a vault ID its label will be added to each query.

For the just described case and the option `--vault-id label` or `--vault-id label@source`
this would produce the following queries to be attempted:
- `current:label`
- `current.parent:label`
- `current.parent.domain.tld:label`
- `current.parent.domain.tld.root:label`

Only if the label is `default`, no label is added to the query.


## Testing

1. To test your configuration, go in a directory of your choosing and type:
   ```shell
   mkdir -p foo/bar
   cd foo/bar
   ansible-vault create secrets.yml
   ```

2. Supposing you don't already have a matching item,
   you will be informed that no password can be found.  
   Now create an item with the name `bar.foo` in your 
   password manager's vault.

3. Try again `ansible-vault create secrets.yml`  
   Ansible should successfully create `secrets.yml`.

4. Run `ansible-vault --vault-id baz show secrets.yml`  
   Ansible will be unable to decrypt as it's looking
   for `bar.foo:baz`.

5. Change your item's name to `bar.foo:baz`.

6. Run `ansible-vault --vault-id baz show secrets.yml` again.  
   Ansible will show the contents of `secrets.yml`.

7. Create a new item `bar:baz` with a different password
   in your password manager's vault.

8. Run `ansible-vault --vault-id baz show secrets.yml` again.  
   Ansible will no longer decrypt `secrets.yml` because
   item `bar:baz` is returned instead of `bar.foo:baz`.


## Contributing

Want to contribute? Awesome! The most basic way to show your support is to star the project, or to raise issues. You
can also support this project by making
a [PayPal donation](https://www.paypal.me/bkahlert) to ensure this journey continues indefinitely!

Thanks again for your support, it is much appreciated! :pray:


## License

MIT. See [LICENSE](LICENSE) for more details.
