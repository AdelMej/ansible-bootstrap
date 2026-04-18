# Bootstrap Ansible Host

## Sets up a host for Ansible

- creates user
- configures sudo
- installs SSH key
- ensures Python is installed

---

## Usage

```bash

KEY=$(cat ~/.ssh/id_rsa.pub)

ssh root@<host> "bash -s -- --user ansible --key \"$KEY\" --force" < install.sh

```

---

## Options

```
--user  target user (default to ansible)
--key   SSH public key (required)
--force  overwrite existing configs (optional)
--debug  enable debug logs (optional)
```

---

## Example

```bash
ssh root@192.168.1.10 "bash -s -- --user ansible --key \"$(cat ~/.ssh/id_rsa.pub)\" --force" < install.sh
```

---

## Result

✔ SSH access configured
✔ sudo configured
✔ Python installed
✔ ready for Ansible

---

## Notes

- Script is idempotent
- Safe to rerun
- Fails fast on errors

